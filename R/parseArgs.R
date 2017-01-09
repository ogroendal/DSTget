parseArgs <- function(table,args, fillRemaining=T, startDate=NA, endDate=NA){
    # table is an object of class DSTget

    argNames = names(args)
    ## Check if the table argument is actually a table and that it has an ID and variables
    if(!(class(table) == "DSTget" & "variables" %in% names(table))){
         stop('table argument must be an object of class DSTget from the DSTget function.')
    }

    ## If no variable arguments are given populate the variable selection
    ##  with a select all for each variable

    if(length(args) == 0){
        args <- lapply(table$values, (function(x) x$id))
    } else if(fillRemaining & length(args) < length(table$variables$id)){
	# Here we take the variables that where not mentioned in the args
	# And give them a * marker for all values if fillRemain is true
        remain <- lapply(table$values, (function(x) x$id))
        remain <- remain[!(names(remain) %in% names(args))]
        args <- append(args, remain)
    }

    ## Separating the names
    argNames <- names(args)

    ## Below we check the numeric time arguments,
    ## and if they are not given we return current time, unaffected
    args[['Tid']] <- selectNumericTime(table, startDate,endDate, args)
    

    ## Preventing encoding errors
    argNames <- iconv(argNames, to = "UTF-8")
    ids <- iconv(table$variable$id, to = "UTF-8")

    ## Check if all the given arguments besides the table name is actually variable IDs
    if(!(sum(argNames %in% ids) == length(argNames))){
        stop('It appears as if you gave an argument that does not correspond
             to a variable ID or the time variable')
    }
    return(args)
}
