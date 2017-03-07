context("Test colClasses estimation")
test_that("Leading Zeroes are not lost in ID values", {

    meta <- DSTget("FU51")
    ## Check that colClasseses are correct
    expect_true(meta$colClasses["FORBRUGSART"] == "character")

    ## Check that this is reflected in data
    dat <- getData(meta, fillRemaining =T, startDate =as.Date("2014-01-01"))
    expect_true(is.character(dat$FORBRUGSART ))
})
