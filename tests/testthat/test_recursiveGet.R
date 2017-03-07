context("Test the splitLarge argument")

test_that("Recursive get works - on a small table", {
    table <- DSTget("FOLK1A")
    args <- list("ALDER" = c(0,1,2,3,4,5,6))
    myData <- recursiveGetData(table, args, labelFactors=F, fillRemaining=T,startDate = as.Date("2014-01-01"), endDate=NA, splitLarge=T)
    expect_true(nrow(myData) > 5 ) 
})

test_that("Recursive get works - on a large table called directly from getData" , {
    table <- DSTget("FOLK1A")
    myData2 <- getData(table, ALDER = c(0:4), labelFactors=F , fillRemaining=T, startDate = as.Date("2010-01-01"), splitLarge=T)
    expect_true(nrow(myData2) > 100000) 
    myData3 <- getData(table, ALDER = c(0:6), labelFactors=F , fillRemaining=T, startDate = as.Date("2010-01-01"), splitLarge=T)
    expect_true(nrow(myData3) > 100000)
})
