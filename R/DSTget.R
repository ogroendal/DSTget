#' Retrieve table metadata
#'
#' @export
#' @name DSTget
#' @title DSTget
#' @importFrom httr content POST
#' @importFrom jsonlite fromJSON
#' @param tablename A string giving the name of the table
#' @param language A string giving the language used, "en" is suggested
#' @return A table object - which is a list of all metadata
#' @examples
#' bev <- DSTget("BEV3C")
DSTget <- function(tablename,language = 'en'){
    ## tablename is a string

    ## Make POST request for table metadata
    result <- POST(url='http://api.statbank.dk/v1/tableinfo',encode='json',
                   body=list(table = tablename, format='json'))
    result_body <- content(result,'text')
    metadata <- fromJSON(result_body)

    ## Check if what was returned was a legitimate tablename
    if('message' %in% names(metadata)){
        m <- metadata$message
        if(grepl("findes ikke",m)){
            stop('Your table reference could not be found by DST')
        }
    }

    ## me is the object that will contain the metadata and get the class DSTget and be returned
    me <- metadata[c('id','text','description','unit','updated')]

    ## Parse and organize the metadata
    vars <- metadata$variables[,c('id','text','elimination','time')]
    values <- list()
    for(i in 1:nrow(vars)){
      values[[vars$id[i]]] <- metadata$variables$values[[i]]
    }

    me[['variables']] <- vars
    me[['values']] <- values

    ## Construct time var
    timeVarName <- vars[vars$time == T,]$id
    timeValues <- values[[timeVarName]]

    timeranges <- parseTime(timeValues$id)
    me[['timeranges']] <- timeranges

    ## Add classification of colClasses
    me <- classifyColClasses(me)

    ## Return the finished table object
    class(me) <- 'DSTget'
    return(me)
}

#' Describe the retrieved table metadata
#'
#' @export
#' @param table The R object holding the table information
#' @return Prints description to console
#' @examples
#' myTable <- DSTget("BEV3C")
#' summary(myTable)
summary.DSTget <- function(table){
    # table is an object of class DSTget

    msg <- paste('The table',table$id, 'contains the following variables:\n',
                 paste(paste('id :',table$variables$id,table$variables$text,sep=" "), collapse="\n"),
                 "\n",'The description of the table is :\n', table$description,'\n',
                 'The table was laste updated on : ',table$updated,'\n',
                 'You can see the available values for each variable by writing
                 tableObject$values$variableID\n')
    cat(msg)
}
