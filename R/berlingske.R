#' Collects poll data from Berlingske Barometer
#'
#' @param year is the year you want data for
#' @return A data frame containing a year of Berlingske Barometer data
#'
#' @examples
#' library(pollsDK)
#' b16 <- berlingskebarometer()
#' b15 <- berlingskebarometer(2015)
#' b14 <- berlingskebarometer(2014)
#' b <- rbind(b16, b15, b14)
#' b
#'
#' @source \url{http://www.politiko.dk/barometeret}
#' @export
#'

berlingskebarometer <- function(year = 2016){

  url <- paste0("http://www.b.dk/upload/webred/bmsandbox/opinion_poll/",year,"/pollofpolls.xml")

  berlingske <- xml2::read_xml(url)
  berlingske <- xml2::xml_children(berlingske)

  pollofpolls <- lapply(berlingske, function(poll){
    tryCatch({
      poll <- xml2::as_list(poll)
      datetime <- poll$datetime[[1]]

      poll_data <- lapply(poll$entries, function(x){
        letter <- x$party$letter[[1]]
        percent <- x$percent[[1]]
        mandates <- x$mandates[[1]]
        support <- x$supports[[1]]
        uncertainty <- x$uncertainty[[1]]

        data.frame(letter, percent, mandates, support, uncertainty,
                   stringsAsFactors = F)
      })

      poll_data <- do.call(rbind, poll_data)

      poll_data$datetime <- datetime

      return(poll_data)

    }, error=function(e){})

  })

  pollofpolls <- do.call(rbind, pollofpolls)

  rownames(pollofpolls) <- NULL

  pollofpolls$datetime <- lubridate::ymd_hms(pollofpolls$datetime)

  pollofpolls[,2:5] <- sapply(pollofpolls[,2:5], function(x) as.numeric(x))

  message("Be aware that Berlingske can have several entries for the same party on the same day")

  return((pollofpolls))
}
