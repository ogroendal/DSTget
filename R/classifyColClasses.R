#' Check colClasses
#'
#' @name classifyColClasses
#' @title Adjust column classes
#' @description This function adjusted the colClasses argument for read.table
#' Some variable IDs misleadingly look like numerical data
#' when in fact their leading zeroes are part of the id. For example, 
#' the table FU51 contains ids in one variable such as 1000 and 01000 which
#' are distinct. It is important that these ID variables be read as character
#' in getData.
#' @param table The metadata from a DSTget call
#' @return The metadata table - but with information on the colClasses added
classifyColClasses <- function(table){
    
    ## List of the variables
    varNames <- names(table$values)

    ## Check for true numeric
    cc <- lapply(table$values, function(x) {detectTrueNumeric(x$id)}) %>% unlist

    ## Add the final one
    cc <- c(cc, "INDHOLD" = "numeric")

    ## Add the results to the metadata
    table$colClasses <- cc

    return(table)
}

## The purpose of detectTrueNumeric is check for leading zeroes, and
## similar things that R will ignore, but will be important for matching values
## OBS! - This function is only used on metadata, and therefore have no
## meaningful performance implications
detectTrueNumeric <- function(charValues){

    suppressWarnings(numValues <- as.numeric(charValues))

    ## Only if the conversion of the character values, return exactly
    ## the same values when converted back, can we safely assume the values
    ## are actually numeric.
    if(all(!is.na(numValues)) & all(charValues == as.character(numValues))){
        return("numeric")
    } else {
        return("character")
    }
}
