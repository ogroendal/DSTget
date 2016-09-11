selectNumericTime <- function(table, startDate, endDate, args){
    ## Here we take into account startTime and endTime if those are filled
    if(is.na(startDate) + is.na(endDate) < 2){
        if(!is.na(startDate) & !inherits(startDate,"Date")){
            stop("You have given a startDate argument that is not of type Date")
        }
        if(!is.na(endDate) & !inherits(endDate,"Date")){
            stop("You have given an endDate argument that is not of type Date")
        }
        startD <- max(head(table$timeranges$start,1), startDate, na.rm=T)
        endD <- min(tail(table$timeranges$end,1), endDate, na.rm=T)
        x <- table$timeranges$ch[with(table$timeranges, start >= startD & start <= endD)]
    } else {
        x <- args[['Tid']]
    }
    return(testTime(x))
}

testTime <- function(x){
    if(length(x) == 0){
        stop("There are no selected time periods. You can select time periods by
             specifying a valid numeric start or end date. You can also
             simply not mention Tid and call with fillRemaining=T, or
             you can select some specific time values")
    }else{
        return(x)
    }
}
