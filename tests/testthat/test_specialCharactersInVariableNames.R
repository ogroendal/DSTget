context("Test interacting with tables with special characters")
test_that("Specify a variable with a special character in the name",
          {
            tab <- DSTget("AKU120")
            dat <- getData(tab, KØN = c("M"), ALDER = "TOT", BESKSTATUS = "*", Tid = "2016K3")
            expect_true(nrow(dat) > 2)
          })

test_that("Variables names are correctly presented in the returned table", {
            tab <- DSTget("AKU120")
            dat <- getData(tab, KØN = c("M"), ALDER = "TOT", BESKSTATUS = "*", Tid = "2016K3")
            expect_true("KØN" %in% names(dat))
})

test_that("Get a table with a variable that contains special chars -
          that must be filled but only doing it implicitly",
          {
            tab <- DSTget("BEV3C")
            dat <- getData(tab, Tid = c("2015M12"), fillRemaining = T)
          })

test_that("The user can enter special characters in variable names
          without receiving errors", {
            table <- DSTget('BEV3C')
            myData <- getData(table, BEVÆGELSEV = c(18), startDate = as.Date("2014-01-01"))
            expect_that(myData$BEVÆGELSEV[1], equals(18))
          })
