context("Check fillRemaining flag")
test_that("That is if you limit one variable like time, then you can choose to get all values
          for all the others. ", {
    hand2 <- DSTget('HAND02')
    hand2dat <- getData(hand2, Tid=c("2015K3"), fillRemaining=T, labelFactors=T)
    expect_that(length(hand2dat), equals(7))
})
