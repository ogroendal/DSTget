#' @param args The ... arguements from getData
#' @importFrom magrittr %>%
fixArgEncoding <- function(args){

  ## Preventing encoding errorseturn
  if(length(args) > 0){
    names(args) <- names(args) %>% ifelse(Encoding(.) == 'latin1', enc2utf8(.), .)
  }

  return(args)
}
