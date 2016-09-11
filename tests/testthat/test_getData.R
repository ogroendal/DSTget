## Check that getting data from a small table with no parameters will simply return all the data
context("getData tests")
test_that("Given no parameters then getData will return all data", {
    table <- DSTget('BEV3C')
    BEVdata <- getData(table)
    expect_that(BEVdata,is_a('data.frame'))
})

test_that("Standard selection works - with no fillRemaining",{
    table <- DSTget("FOD111")
    fodData <- getData(table, Tid = c(2014,2015), ALDER = c(610, 617), OMRÅDE = c(151,157, 101),
                       fillRemaining = F)
    expect_that(nrow(fodData), equals( 2 * 2 * 3 ))
})

test_that("Check that one can select date with numeric time values,
          And that these do not interfere with the other arguments", {
    table <- DSTget('BEV3C')
    BEVdata <- getData(table, startDate=as.Date("2015-01-01"), endDate=as.Date("2015-4-01"))
    expect_that(sum(unique(BEVdata$TID) %in% c("2015M01", "2015M02", "2015M03", "2015M04")), equals( 4))
})

test_that("Check that the user gets an error message
          if he has not given all variables that cannot be eliminated." ,{
    table <- DSTget('BEV3C')
    expect_that(BEVdata <- getData(table,Tid=c('*'), fillRemaining=F),
                throws_error('*variables as a minimum*'))
})

test_that("The user can enter special characters in variable names
          without receiving errors", {
    table <- DSTget('BEV3C')
    myData <- getData(table, BEVÆGELSEV = c(18), startDate = as.Date("2014-01-01"))
    expect_that(myData$BEVÆGELSEV[1], equals(18))
})
