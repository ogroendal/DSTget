context("Check selectNumericTime")
test_that("Selecting on numeric dates gives a correct interval", {
    table <- DSTget('BEV3C')
    perioder <- selectNumericTime(table, startDate=as.Date("2015-01-01"), endDate=as.Date("2015-4-01"))
    expect_that(sum(unique(perioder) %in% c("2015M01", "2015M02", "2015M03", "2015M04")), equals( 4))
})
