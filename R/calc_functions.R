#' Margin of Error for a Proportion
#'
#' Calculate the margin of error for a poll resultat
#'
#' @param p the poll result
#' @param n respondents in the poll
#' @param z the z score
#'
#' @return a number
#' @export
#'
#' @examples
#' calc_uncertainty(.04, 1200)
calc_uncertainty <- function(p, n, z = 1.96){

  if(p > 1) {
    p <- p / 100
  }

  out <- z * sqrt((p * (1-p)) / n)

  return(out)

}


#' Population of a Poll
#'
#' Calculate the how many respondents were in a poll
#' from just the proportion and the uncertainty. Use it
#' to reverse engineer poll of polls.
#'
#' @param p the poll result
#' @param unc the uncertainty
#' @param z the x score
#'
#' @return a number
#' @export
#'
#' @examples
#' unc <- calc_uncertainty(.04, 1200)
#' calc_population(.04, unc)
calc_population <- function(p, unc, z = 1.96){

  if(p > 1) {
    p <- p / 100
  }

  if(unc > .2) {
    unc <- unc / 100
  }

  out <- (p * (1-p)) / (unc / z)^2

  return(out)
}





