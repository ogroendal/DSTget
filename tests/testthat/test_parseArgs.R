context("Check parseArgs")
test_that("Parse args will return the correct arguments when selecting time numerically", {
    table <- DSTget('BEV3C')
    args <- list("BEVÆGELSEV" = c(18))
    newArgs <- parseArgs(table, args = args,
                          startDate=as.Date("2015-01-01"), endDate=as.Date("2015-4-01"))
    expect_that(sum(newArgs[['Tid']] %in% c("2015M01", "2015M02", "2015M03", "2015M04")), equals( 4))
})
