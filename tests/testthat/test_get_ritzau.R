library(testthat)
library(pollsDK)

context("Testing the get_ritzau() function")

r <- get_ritzau()

test_that("r has the right structure", {

  expect_true(is.list(r),
              info = "Testing that r is a list")

  inst <- c("Voxmeter", "Epinion", "Gallup", "Norstat", "Greens", "Wilke")
  expect_true(all(stringr::str_detect(names(r), inst)),
              info = "Testing that names are correct")

  expect_true(length(r) > 0,
              info = "Testing that r is longer than 0")

  the_classes <- unlist(sapply(r, class))
  expect_true(all(sapply(r, tibble::is_tibble)),
              info = "Testing that all entries are tibbles")

  expect_true(all(purrr::map_lgl(r, function(x){
    all(dim(x) == c(12, 13))
  })),
  info = "Testing that all dimensions are correct")


  my_names <- c("PartyId", "Party", "PartyName", "PartyLogo", "PartyBlock",
                "PartyColor", "Percentage", "Mandate", "RitzauPartyColor",
                "RitzauPercentage", "RitzauMandate", "ChartSortOrder", "IsOfficial")

  expect_true(all(purrr::map_lgl(r, function(x){
    all(names(x) == my_names)
  })),
  info = "Testing that all names in the tibbles are correct")
})
