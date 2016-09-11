
parseTime <- function(ch){
    cv <- function(str, start, end){ as.numeric(substr(str, start, end))}
    d <- function(yr, mon, day){ as.Date(ISOdate(yr, mon, day))}

    char <- substr(ch[1], 5,5) ## Kan være M, K, Q, : eller "" for år.
    # Below is a lookup list that will supply the regular expressions needed to parse the different time periods
    if(char == ""){
        start <- d(cv(ch,1,4), 1, 1)
        end <- d(cv(ch,1,4), 12,31)
    } else if (char == ":"){
        start <- d(cv(ch,1,4), 1,1)
        end <- d(cv(ch,6,9), 12, 31)
    } else if (char == "M") {
        y <- cv(ch,1,4)
        m <- cv(ch,6,7) 
        start <- d( y , m , 1)
        end <- d( ifelse(m == 12, y + 1, y) , ifelse(m == 12, 1, m + 1) , 1) - 1
    } else if (char %in% c("K", "Q")) {
        qs <- c(1,4,7,10) 
        q <- cv(ch,6,6)
        q2dates <- c(31,30, 30, 31)
        start <- d(cv(ch, 1, 4), qs[q] , 1)
        end <- d(cv(ch, 1, 4), qs[q] + 2, q2dates[q])
    }
    return(data.frame( ch = ch, start = start, end = end))
}
