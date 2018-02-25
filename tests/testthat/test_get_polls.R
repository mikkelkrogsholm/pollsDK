library(testthat)
library(pollsDK)

context("Testing the get_polls() function")

p <- get_polls()

test_that("p has the right structure", {

  expect_true(tibble::is_tibble(p),
              info = "Testing that b is a tibble")

  expect_true(all(names(p) == c("letter","percent", "mandates", "support",
                                "uncertainty", "pollster", "description",
                                "respondents", "datetime" )),
              info = "Testing that names are correct")

  expect_true(nrow(p) > 0,
              info = "Testing that p has more than 0 rows")

  expect_true(ncol(p) == 9,
              info = "Testing that p has 9 columns")

  the_classes <- unlist(sapply(p, class))
  expect_true(all(the_classes == c("character", "numeric", "numeric", "numeric",
                                   "numeric", "character", "character", "numeric",
                                   "POSIXct", "POSIXt")),
              info = "Testing that classes are correct")

})


p <- get_polls(2012)

test_that("p with giving year has the right structure", {

  expect_true(tibble::is_tibble(p),
              info = "Testing that b is a tibble")

  expect_true(all(names(p) == c("letter","percent", "mandates", "support",
                                "uncertainty", "pollster", "description",
                                "respondents", "datetime" )),
              info = "Testing that names are correct")

  expect_true(nrow(p) > 0,
              info = "Testing that p has more than 0 rows")

  expect_true(ncol(p) == 9,
              info = "Testing that p has 9 columns")

  the_classes <- unlist(sapply(p, class))
  expect_true(all(the_classes == c("character", "numeric", "numeric", "numeric",
                                   "numeric", "character", "character", "numeric",
                                   "POSIXct", "POSIXt")),
              info = "Testing that classes are correct")

})
