#' Visualizes poll data from Erik Gahners Github
#'
#' @return A ggplot of danish polls
#'
#' @examples
#' library(pollsDK)
#' gahner_plot()
#'
#' @source \url{https://github.com/erikgahner}
#'
#' @export

gahner_plot <- function(pollingfirms = NULL, parties = NULL){

  poll <- gahner()

  poll$date <- lubridate::ymd(stringr::str_c(poll$year, "-",
                                             stringr::str_pad(poll$month, 2, "left", 0), "-",
                                             stringr::str_pad(poll$day, 2, "left", 0))
  )


  if(!(is.null(pollingfirms))){
    vizdata <- dplyr::filter(poll, poll$pollingfirm %in% pollingfirms)} else {
      vizdata <- poll
    }

  vizdata <- dplyr::select(vizdata, party_a:party_aa, date)
  vizdata <- tidyr::gather(vizdata, partyletter, percentage, -date)

  vizdata$partyletter <- stringr::str_replace_all(vizdata$partyletter, "party_", "")
  vizdata$partyletter <- stringr::str_replace_all(vizdata$partyletter, "aa", "å")
  vizdata$partyletter <- stringr::str_replace_all(vizdata$partyletter, "oe", "ø")
  vizdata$partyletter <- stringr::str_to_upper(vizdata$partyletter)

  if(!(is.null(parties))){vizdata <- dplyr::filter(vizdata, partyletter %in% parties)}

  vizdata <- na.omit(vizdata)

  gg <- ggplot2::ggplot(vizdata, ggplot2::aes(date, percentage, group = partyletter,
                                              color = partyletter)) +
    ggplot2::geom_point(alpha = .2, show.legend = F) +
    ggplot2::labs(x = "", y = "") +
    ggplot2::scale_color_manual(values = partycolors) +
    ggplot2::theme_minimal()

  return(gg)
}


