context("Test includeRDates argument")

test_that("The argument makes a normal join", {
    tab <- DSTget("BEV3C")
    dat1 <- getData(tab, giveRDates = T)
    dat2 <- getData(tab, giveRDates = F)

    expect_true( nrow(dat1) == nrow(dat2))
    expect_true( ncol(dat1) == ncol(dat2) + 2)
})
