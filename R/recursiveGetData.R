## recursiveGetData is a function that is called by getData
## in the case that the desired rownumber exceeds the
## limit set by DST.

#' @importFrom data.table rbindlist
#' @importFrom magrittr %>%
recursiveGetData <- function(table, args, labelFactors, fillRemaining, startDate, endDate, splitLarge){

    ## Identify the variable that gets us the split closest to 100.000 row
    ## pr download. Sometimes this will result in a recursive split
    ## when it is not nessecary, but the idea is simply to avoid
    ## too small download values.
    argLengths <- lapply(args, length) %>% unlist
    totalRows <- prod(argLengths)
    downSize <- ceiling(totalRows / argLengths)
    ## It must be an argument with more than 1 remaning value
    topArg <- abs(downSize[argLengths > 1] - 100000) %>% which.min %>% names

    ## Get the levels
    topArgVals <- args[[topArg]]

    ## Modified argument list to keep each call
    mArgs <- args

    ## Make a list to contain temporary data.frames
    frames <- list()

    ## Here we loop over the levels, calling getData for each level
    for(i in seq_along(topArgVals)){
        mArgs[[topArg]] <- topArgVals[i]
        frames[[i]] <- getData(table = table, args = mArgs, labelFactors = labelFactors,
                               fillRemaining = fillRemaining,
                               startDate = startDate, endDate = endDate,
                               splitLarge = splitLarge)
    }

    return(rbindlist(frames))
}
