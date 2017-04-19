#' Get the actual data using the meta data object.
#'
#' @export
#' @name getData
#' @title getData
#' @importFrom magrittr %>%
#' @importFrom httr POST content
#' @param table This is a table object from the DSTget function, it contain metadata.
#' @param fillRemaining A boolean - if true then all values, in variables that are not
#' explicitly mentioned, will be selected (as opposed to none).
#' @param labelFactors A boolean - if true then the factor levels will be renamed to
#' their full statbank text. A 'U' value in BEC3V will become 'Ugift'.
#' @param startDate An R date - all periods before this will not be downloaded.
#' @param endDate An R date - all periods after this will not be downloaded.
#' @param splitLarge Allows you to download tablers larger than the default DST limit of 100.000 rows
#' @param ... Give all variable selections as arguments. Forexample write Tid = c("2015M01", "2015M02") and ALDER  = c(0,1,2,3)
#' @param giveRDates Include the start and end time of periods, as R dates, directly with the data - they are also available in the metadata table - so this simply saves you a join operation.
#' @examples
#' tab <- DSTget("BEV3C")
#' dat <- getData(tab, fillRemaining=T)
getData <- function(table,...,labelFactors=F, fillRemaining=F, startDate=NA, endDate=NA, splitLarge=F, giveRDates = F){

    ## The variable selections gets tranformed to a list of arguments
    ## We also mae sure that there are no encoding problems
    argList <- fixArgEncoding(list(...))

    ## Normally fillRemaining is false, but if no other args are given
    ## it is set to True, as we then expect the user to want all data.
    if(length(argList) == 0){
      fillRemaing = T
    }

    ## If getData is called by recursiveGetData
    ## Then the value spec will already be in a list called Args
    ## If it is not we will parse the argument list
    if("args" %in% names(argList)){
      args <- argList[["args"]]
    } else {
      args <- parseArgs(table, args = argList, fillRemaining, startDate, endDate)
    }

    argNames <- names(args)

    ## Check if the user has selected too many combinations of data exceeding
    ## the 100000 number limit set by DST

    nums <- lapply(args, length) %>% unlist %>% prod
    if(nums > 100000 & !splitLarge){
        stop(sprintf('You have chosen a combination of variables that will yield %s rows,
             hitting the limit by set by the DST API of 100.000 rows,
             reduce the number of chosen values or use the splitLarge argument', nums))
    } else if (nums > 100000 & splitLarge){
        ## Here we call a function that calls getData recursively to split the download process
        ## StartDate and endDate is set to NA as we dont need to process those more than ones
        recursiveGetData(table, args, labelFactors, fillRemaining = F,
                         startDate=NA, endDate = NA, splitLarge)
    }

    ## Construct the call for the data
    dataUrl <- 'http://api.statbank.dk/v1/data'
    variables <- vector('list',length(args))
    varnames <- names(args)
    for(i in seq_along(args)){
        x <- list(code = varnames[i], values = as.list(args[[i]]))
        variables[[i]] <- x
    }

    body <- list(table = table$id, format='CSV', valuePresentation='Code', delimiter='Semicolon',
                 variables = variables)

    #print(body)

    ## Get the data
    result <- POST(url=dataUrl,encode='json',body=body)

    ## Parse the data
    result_body <- content(result,'text',encoding='UTF-8')
    result_body <- sub("\uFEFF","" , result_body) ## Remove UTF-8 BOM - this seems to be nessecary on some windows installations
    x <- textConnection(result_body, encoding="bytes")

    ## Create data.frame from data, and give the correct colClasses from the metadata
    rcc <- table$colClasses[names(table$colClasses) %in% argNames]
    names(rcc) <- toupper(names(rcc))
    dat <- read.table(x,sep=";",header=T, encoding="UTF-8",
                      colClasses = rcc)

    ## Convert all numerically encoded factor variables to R factors
    if(labelFactors){
	    for(i in argNames){
		if(i == 'Tid'){i <- 'TID'}
		if(is.numeric(dat[,i])){
		    dat[,names(dat) == i] <- factor(x = dat[,i],
						    levels = table$values[[i]][,'id'],
						    labels = table$values[[i]][,'text'])
		} else if(i != 'TID' & is.character(dat[,i])){
	 	    lookup <- table$values[[i]]
		    vals <- unique(dat[,i])
		    labs <- lookup$text[match(vals, lookup$id)]
		    dat[,i] <- factor(dat[,i], levels = vals, labels = labs)
		}else if(i == 'TID'){
		     dat[,i] <- as.character(dat[,i])
		}
	    }
    }

    ## Include the R Dates
    if(giveRDates){
        dat <- merge(dat, table$timeranges, by.x="TID", by.y  = "ch")
    }

    ## Return results as a dataframe.
    return(dat)
}
