library(testthat)
library(pollsDK)

context("Testing the get_berlingske() function")

b <- get_berlingske()

test_that("b has the right structure", {

  expect_true(tibble::is_tibble(b),
              info = "Testing that b is a tibble")

  expect_true(all(names(b) == c("letter", "percent", "mandates", "support", "uncertainty", "datetime")),
              info = "Testing that names are correct")

  expect_true(nrow(b) > 0,
              info = "Testing that b has more than 0 rows")

  expect_true(ncol(b) == 6,
              info = "Testing that b has 6 columns")

  the_classes <- unlist(sapply(b, class))
  expect_true(all(the_classes == c("character", "numeric", "numeric", "numeric", "numeric", "POSIXct", "POSIXt")),
              info = "Testing that classes are correct")

})

b <- get_berlingske(2012)

test_that("b with giving year has the right structure", {

  expect_true(tibble::is_tibble(b),
              info = "Testing that b is a tibble")

  expect_true(all(names(b) == c("letter", "percent", "mandates", "support", "uncertainty", "datetime")),
              info = "Testing that names are correct")

  expect_true(nrow(b) > 0,
              info = "Testing that b has more than 0 rows")

  expect_true(ncol(b) == 6,
              info = "Testing that b has 6 columns")

  the_classes <- unlist(sapply(b, class))
  expect_true(all(the_classes == c("character", "numeric", "numeric", "numeric", "numeric", "POSIXct", "POSIXt")),
              info = "Testing that classes are correct")

})



