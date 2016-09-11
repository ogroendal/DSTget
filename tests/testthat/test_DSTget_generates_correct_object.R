context("Check DSTget object")
test_that("Is DSTget returning a DSTget object?", {
    table <- DSTget('FOLK1A')
    expect_that(table,is_a('DSTget'))
})

## Does it throw a meaningful error when asked for a non existent table?
test_that("Are we returning a good error if the table name does not exist", {
    expect_error(DSTget('xxx'),"Your table reference could not be found by DST*")
})

## Check that the DSTget object contains all the expected components
test_that("Does DSTget objects contain the right components", {
    table <- DSTget('FOLK1A')
    expect_that(sum( c('values','variables','timeranges',
                       'id','description','updated','unit','text') %in% names(table)), equals(8))
})
