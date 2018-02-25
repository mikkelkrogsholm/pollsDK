library(testthat)
library(pollsDK)

context("Testing the partycolors data set is correct")

test_that("partycolors has the right structure", {

  expect_true(length(partycolors) == 11,
              info = "Testing that partycolors is the correct length")

  expect_true(all(names(partycolors) == c("A", "B", "C", "D", "F", "I", "K", "O",
                                          "V", "Ø", "Å")),
              info = "Testing that partycolors has the correct names")

  expect_true(all(partycolors == c("#E32F3B", "#E52B91", "#0F854B", "#00505c",
                                   "#9C1D2A", "#EF8535", "#F0AC55", "#005078",
                                   "#0F84BB", "#731525", "#5AFF5A")),
              info = "Testing that partycolors has the correct values")

})



