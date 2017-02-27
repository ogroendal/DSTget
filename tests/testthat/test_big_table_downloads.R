context("Check data split functionality")
test_that("Check that getting data from a big table,
          with no parameters will throw an error preemptively", {
    table <- DSTget('FOLK1A')
    expect_error(fdat <- getData(table),"*100.000 rows*")
})


