context("Check factor conversion")
test_that("Check that all numerically encoded variables
          other than time and value are correctly formed factors", {
    table <- DSTget('BEV3C')
    dat <- getData(table, labelFactors=T)
    expect_that(dat$BEVÆGELSEV, is_a('factor'))
    expect_that(dat$TID, is_a('character'))
})

test_that("Check that non-numerically encoded variables are correctly formed factor", {
    hand2 <- DSTget('HAND02')
    hand2dat <- getData(hand2, Tid=c("2015K3"), fillRemaining=T, labelFactors=T)
    expect_that(hand2dat$UDDANNELSE, is_a('factor'))
    expect_that(sum(grepl('',levels(hand2dat$UDDANNELSE))) > 0, equals(T)) 
})
