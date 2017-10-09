# get_berlingske ----

#' Collects poll data from Berlingske Barometer
#'
#' @param year is the year you want data for
#' @return A data frame containing a year of Berlingske Barometer data
#'
#' @examples
#' \dontrun{
#' library(pollsDK)
#' b <- get_berlingske()
#' }
#'
#' @source \url{http://www.politiko.dk/barometeret}
#' @export
#'

get_berlingske <- function(year = lubridate::year(Sys.Date())){

  url <- paste0("http://www.b.dk/upload/webred/bmsandbox/opinion_poll/", year, "/pollofpolls.xml")

  berlingske <- xml2::read_xml(url)
  berlingske <- xml2::xml_children(berlingske)

  pollofpolls <- pbapply::pblapply(berlingske, function(poll){
    tryCatch({
      poll <- xml2::as_list(poll)

      poll_data <- lapply(poll$entries, function(x){
        letter <- x$party$letter[[1]]
        percent <- x$percent[[1]]
        mandates <- x$mandates[[1]]
        support <- x$supports[[1]]
        uncertainty <- x$uncertainty[[1]]

        tibble::tibble(letter, percent, mandates, support, uncertainty)
      })

      poll_data <- dplyr::bind_rows(poll_data)

      poll_data$datetime <- poll$datetime[[1]]

      return(poll_data)

    }, error=function(e){})

  })

  pollofpolls <- dplyr::bind_rows(pollofpolls)

  pollofpolls$datetime <- lubridate::ymd_hms(pollofpolls$datetime, tz = "CET")

  # Floor to day
  pollofpolls$datetime_floor <- lubridate::floor_date(pollofpolls$datetime, "days")

  # Keep only newest on date
  pollofpolls <- dplyr::group_by(pollofpolls, letter, datetime_floor)
  pollofpolls <- dplyr::arrange(pollofpolls, desc(datetime))
  pollofpolls <- dplyr::slice(pollofpolls, 1)
  pollofpolls <- dplyr::ungroup(pollofpolls)
  pollofpolls <- dplyr::arrange(pollofpolls, datetime)

  # Remove datetime_floor
  pollofpolls$datetime_floor <- NULL

  # Floor to day
  pollofpolls$datetime <- lubridate::floor_date(pollofpolls$datetime, "days")

  # Make numeric
  pollofpolls[,2:5] <- sapply(pollofpolls[,2:5], function(x) as.numeric(x))

  return((pollofpolls))
}

# get_polls ----

#' Collects poll data from Berlingske
#'
#' @param year is the year you want data for
#' @return A data frame containing a year of polling data
#'
#' @examples
#' \dontrun{
#' library(pollsDK)
#' p <- get_polls()
#' }
#'
#' @source \url{http://www.politiko.dk/barometeret}
#' @export
#'

get_polls <- function(year = lubridate::year(Sys.Date())){

  url <- paste0("http://www.b.dk/upload/webred/bmsandbox/opinion_poll/", year, "/all.xml")

  berlingske <- xml2::read_xml(url)
  berlingske <- xml2::xml_children(berlingske)

  polls <- pbapply::pblapply(berlingske, function(poll){
    tryCatch({
      poll <- xml2::as_list(poll)

      poll_data <- lapply(poll$entries, function(x){
        letter <- x$party$letter[[1]]
        percent <- x$percent[[1]]
        mandates <- x$mandates[[1]]
        support <- x$supports[[1]]
        uncertainty <- x$uncertainty[[1]]

        tibble::tibble(letter, percent, mandates, support, uncertainty)
      })

      poll_data <- dplyr::bind_rows(poll_data)

      # Add meta data
      poll_data$pollster <- poll$name[[1]]
      poll_data$description <- poll$description[[1]]
      poll_data$respondents <- poll$respondents[[1]]
      poll_data$datetime <-  poll$datetime[[1]]

      # Return data
      return(poll_data)

    }, error=function(e){})

  })

  polls <- dplyr::bind_rows(polls)

  polls$datetime <- lubridate::ymd_hms(polls$datetime, tz = "CET")

  # Floor to day
  polls$datetime_floor <- lubridate::floor_date(polls$datetime, "days")

  # Keep only newest on date
  polls <- dplyr::group_by(polls, letter, pollster, datetime_floor)
  polls <- dplyr::arrange(polls, desc(datetime))
  polls <- dplyr::slice(polls, 1)
  polls <- dplyr::ungroup(polls)
  polls <- dplyr::arrange(polls, datetime)

  # Remove datetime_floor
  polls$datetime_floor <- NULL

  # Floor to day
  polls$datetime <- lubridate::floor_date(polls$datetime, "days")

  polls[, c(2:5, 8)] <- sapply(polls[, c(2:5, 8)], function(x) as.numeric(x))

  return((polls))
}

# get_gahner ----

#' Collects poll data from Erik Gahners Github
#'
#' @return A data frame of all poll data from Erik Gahners Github
#'
#' @examples
#' \dontrun{
#' library(pollsDK)
#' g <- get_gahner()
#' }
#'
#' @source \url{https://github.com/erikgahner}
#' @export
#'

get_gahner <- function(){
  loc <- readr::locale(encoding = "Latin1")

  polls <- readr::read_csv("https://raw.githubusercontent.com/erikgahner/polls/master/polls.csv",
                           locale = loc)

  message("Polls collected by Erik Gahner\nTwitter: @erikgahner \nGithub: https://github.com/erikgahner")

  return(polls)
}

# get_ritzau ----

#' Collects the most recent numbers from the Ritzau Index
#'
#' @return A list of data frames each containing a different poll, but all containing the Ritzau Index.
#'
#' @examples
#' \dontrun{
#' library(pollsDK)
#' r <- get_ritzau()
#' }
#'
#' @source \url{https://www.ritzau.dk/Produkter og Services/Ritzau Index.aspx}
#'
#' @export
#'
get_ritzau <- function(){

  url <- "https://www.ritzau.dk/index/?chart=partier&mode=undefined&token=C1D33E00-EC0C-4C57-A7E7-D03B2B185865#party"

  html_data <- xml2::read_html(url)
  text <- rvest::html_text(html_data)

  text <- stringr::str_split(text, "(\\= \\{)|(\\};)")
  text <- unlist(text)

  text1 <- stringr::str_trim(text[2])
  text1 <- stringr::str_c("{", text1, "}")

  text2 <- stringr::str_trim(text[4])
  text2 <- stringr::str_c("{", text2, "}")

  test1 <- jsonlite::fromJSON(text1)
  test2 <- jsonlite::fromJSON(text2)

  polls <- test2$Polls$Percentage
  polls <- lapply(polls, dplyr::as_data_frame)

  names(polls) <- test2$Polls$PollName


  message_text <- paste0("List with data frames of polls:\n", paste(test2$Polls$PollName, collapse = "\n"),
                         "\nEach data frame include the Ritzau Index")

  message(message_text)

  return(polls)

}
