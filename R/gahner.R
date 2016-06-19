#' Collects poll data from Erik Gahners Github
#'
#' @return A data frame of all poll data from Erik Gahners Github
#'
#' @examples
#' library(pollsDK)
#' gahner()
#'
#' @source \url{https://github.com/erikgahner}
#' @export
#'

gahner <- function(){
  loc <- readr::locale(encoding = "Latin1")

  polls <- readr::read_csv("https://raw.githubusercontent.com/erikgahner/polls/master/polls.csv",
                           locale = loc)

  message("Polls collected by Erik Gahner\nTwitter: @erikgahner \nGithub: https://github.com/erikgahner")

  return(polls)
}


