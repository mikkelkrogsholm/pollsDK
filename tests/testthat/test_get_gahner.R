library(testthat)
library(pollsDK)

context("Testing the get_gahner() function")

g <- get_gahner()

test_that("g has the right structure", {

  expect_true(tibble::is_tibble(g),
              info = "Testing that g is a tibble")

  my_colnames <- c("id", "pollingfirm", "year", "month", "day", "party_a",
                   "party_b", "party_c", "party_d", "party_f", "party_i",
                   "party_k", "party_o", "party_v", "party_oe", "party_aa",
                   "n", "source")

  expect_true(all(names(g) == my_colnames),
              info = "Testing that names are correct")

  expect_true(nrow(g) > 0,
              info = "Testing that g has more than 0 rows")

  expect_true(ncol(g) == 18,
              info = "Testing that g has 18 columns")

  the_classes <- unlist(sapply(g, class))
  my_classes <- c("integer", "character", "integer", "integer", "integer", "numeric",
                  "numeric", "numeric", "numeric", "numeric", "numeric",
                  "numeric", "numeric", "numeric", "numeric", "numeric", "integer",
                  "character")
  expect_true(all(the_classes == my_classes),
              info = "Testing that classes are correct")

})
