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

##########

#' Tells you which polling firms are in Gahners data
#'
#' @return A list of polling firms
#'
#' @examples
#' library(pollsDK)
#' gahner_pollingfirms()
#'
#' @source \url{https://github.com/erikgahner}
#' @export
#'

gahner_pollingfirms <- function(){
  poll <- gahner()
  pollingfirms <- sort(unique(poll$pollingfirm))
  return(pollingfirms)
}

##########

#' Tells you which parties are in Gahners data
#'
#' @return A list of party letters
#'
#' @examples
#' library(pollsDK)
#' gahner_partyletters()
#'
#' @source \url{https://github.com/erikgahner}
#' @export
#'

gahner_partyletters <- function(){
  poll <- gahner()
  poll <- dplyr::select(poll, party_a:party_aa)
  poll <- tidyr::gather(poll, partyletter, percentage)

  poll$partyletter <- stringr::str_replace_all(poll$partyletter, "party_", "")
  poll$partyletter <- stringr::str_replace_all(poll$partyletter, "aa", "å")
  poll$partyletter <- stringr::str_replace_all(poll$partyletter, "oe", "ø")
  poll$partyletter <- stringr::str_to_upper(poll$partyletter)

  partyletter <- sort(unique(poll$partyletter))
  return(partyletter)
}

