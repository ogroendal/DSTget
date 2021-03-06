% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getData.R
\name{getData}
\alias{getData}
\title{getData}
\usage{
getData(table, ..., labelFactors = F, fillRemaining = F, startDate = NA,
  endDate = NA, splitLarge = F, giveRDates = F)
}
\arguments{
\item{table}{This is a table object from the DSTget function, it contain metadata.}

\item{...}{Give all variable selections as arguments. Forexample write Tid = c("2015M01", "2015M02") and ALDER  = c(0,1,2,3)}

\item{labelFactors}{A boolean - if true then the factor levels will be renamed to
their full statbank text. A 'U' value in BEC3V will become 'Ugift'.}

\item{fillRemaining}{A boolean - if true then all values, in variables that are not
explicitly mentioned, will be selected (as opposed to none).}

\item{startDate}{An R date - all periods before this will not be downloaded.}

\item{endDate}{An R date - all periods after this will not be downloaded.}

\item{splitLarge}{Allows you to download tablers larger than the default DST limit of 100.000 rows}

\item{giveRDates}{Include the periods as R dates directly on the data - they are also available in the metadata table - so this simply saves you a join operation.}
}
\description{
Get the actual data using the meta data object.
}
\examples{
tab <- DSTget("BEV3C")
dat <- getData(tab, fillRemaining=T)
}

