# get_berlingske ----

#' Collects poll data from Berlingske Barometer
#'
#' @param year is the year you want data for
#' @return A data frame containing a year of Berlingske Barometer data
#'
#' @examples
#' library(pollsDK)
#' b <- get_berlingske()
#'
#' @source \url{http://www.politiko.dk/barometeret}
#' @export
#'

get_berlingske <- function(year = lubridate::year(Sys.Date())){

  url <- paste0("http://www.b.dk/upload/webred/bmsandbox/opinion_poll/", year, "/pollofpolls.xml")

  berlingske <- xml2::read_xml(url)
  berlingske <- xml2::xml_children(berlingske)

  # Nullify global variable for CRAN
  letter <- datetime_floor <- desc <- datetime <- NULL

  # Loop to get polls
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

  # Nullify global variable for CRAN
  letter <- pollster <- datetime_floor <- desc <- datetime <- NULL

  # Loop to get polls
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
#' library(pollsDK)
#' g <- get_gahner()
#'
#' @source \url{https://github.com/erikgahner}
#' @export
#'

get_gahner <- function(){
  polls <- readr::read_csv("https://raw.githubusercontent.com/erikgahner/polls/master/polls.csv")

  message("Polls collected by Erik Gahner\nTwitter: @erikgahner \nGithub: https://github.com/erikgahner")

  return(polls)
}

# get_ritzau ----

#' Collects the most recent numbers from the Ritzau Index
#'
#' @return A list of data frames each containing a different poll, but all containing the Ritzau Index.
#'
#' @examples
#' library(pollsDK)
#' r <- get_ritzau()
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

  poll_text <- stringr::str_trim(text[4])
  poll_text <- stringr::str_c("{", poll_text, "}")

  polls_list <- jsonlite::fromJSON(poll_text)

  polls <- polls_list$Polls$Percentage
  polls <- lapply(polls, tibble::as.tibble)
  names(polls) <- polls_list$Polls$PollName

  message_text <- paste0("List with data frames of polls:\n", paste(polls$Polls$PollName, collapse = "\n"),
                         "\nEach data frame include the Ritzau Index")

  message(message_text)

  return(polls)

}

# get_voter_migration ----

#' Collect voter migration from dr.dk
#'
#' @return a list
#' @export
#'
#' @importFrom magrittr %>%
#'
#' @examples
#' vote_mig <- get_voter_migration()
#'
get_voter_migration <- function(){

  # Get the data ----
  url <- "https://www.dr.dk/surveymeter/v2/candidate_movement.json"

  my_data <- suppressWarnings(jsonlite::fromJSON(url))

  # Return the data
  return(my_data)
}
