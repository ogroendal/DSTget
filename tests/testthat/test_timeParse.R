context("Check timeParse")
## Do we parse the different time types correctly?
test_that("parseTime accurately parses danish quarters", {
    dat <- parseTime(c("2015K1", "2016K2"))
    expect_that( dat$start, equals(as.Date(c("2015-01-01", "2016-04-01"))))
    expect_that( dat$end, equals(as.Date(c("2015-03-31", "2016-06-30"))))
})

test_that("parseTime accurately parses years", {
    dat <- parseTime(c("2001:2002", "2003:2005"))
    expect_that( dat$start, equals(as.Date(c("2001-01-01", "2003-01-01"))))
    expect_that( dat$end, equals(as.Date(c("2002-12-31", "2005-12-31"))))
})

test_that("parseTime parses danish months", {
    dat <- parseTime(c("2015M01", "2016M02"))
    expect_that( dat$start, equals(as.Date(c("2015-01-01", "2016-02-01"))))
    expect_that( dat$end, equals(as.Date(c("2015-01-31", "2016-02-29")))) ## 2016 er skudår
})
