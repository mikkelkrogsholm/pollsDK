library(testthat)
library(pollsDK)

context("Testing the get_voter_migration() function")

vote_mig <- get_voter_migration()

test_that("vote_mig has the right structure", {

  expect_true(is.list(vote_mig),
              info = "Testing that vote_mig is a list")

  expect_true(all(names(vote_mig) == c("metadata", "nodes", "edges")),
              info = "Testing that names are correct")

  expect_true(all(sapply(vote_mig, tibble::is_tibble)),
              info = "Testing all are tibbles")

})

test_that("vote_mig$metadata has the right structure", {

  expect_true(all(names(vote_mig$metadata) == c( "collected_date", "year_past",
                                                 "year_present", "respondents",
                                                 "info")),
              info = "Testing that names are correct")

  expect_true(all(dim(vote_mig$metadata) == c(1, 5)),
              info = "Testing that dims are correct")

  the_classes <- sapply(vote_mig$metadata, class)
  expect_true(all(the_classes == c( "Date", "integer", "integer", "integer",
                                    "character")),
              info = "Testing that classes are correct")

})

test_that("vote_mig$nodes has the right structure", {

  expect_true(all(names(vote_mig$nodes) == c("name", "short", "id", "year",
                                             "totalVotes")),
              info = "Testing that names are correct")

  expect_true(all(dim(vote_mig$nodes) == c(21, 5)),
              info = "Testing that dims are correct")

  the_classes <- sapply(vote_mig$nodes, class)
  expect_true(all(the_classes == c("character", "character", "integer", "integer",
                                   "numeric")),
              info = "Testing that classes are correct")

})

test_that("vote_mig$nodes has the right structure", {

  expect_true(all(names(vote_mig$edges) == c("source", "target", "value")),
              info = "Testing that names are correct")

  expect_true(all(dim(vote_mig$edges) == c(220, 3)),
              info = "Testing that dims are correct")

  the_classes <- sapply(vote_mig$edges, class)
  expect_true(all(the_classes == c("integer", "integer", "integer")),
              info = "Testing that classes are correct")

})
