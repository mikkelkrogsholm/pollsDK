#' Collects the most recent numbers from the Ritzau Index
#'
#' @return A list of data frames each containing a different poll, but all containing the Ritzau Index.
#'
#' @examples
#' library(pollsDK)
#' ritzauindex()
#'
#' @source \url{https://www.ritzau.dk/Produkter og Services/Ritzau Index.aspx}
#'
#' @export
#'
ritzauindex <- function(){

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



