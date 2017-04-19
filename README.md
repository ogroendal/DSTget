DSTget
======

## Get Statistics Denmark easily into R
DSTget makes it easy to download Statistics Denmark (DST) data
straight into R and keep them updated. Its an interface to the
flexible DST API.

## How to install?
The package is not on CRAN, but can be installed directly from
github.

```R
library(devtools)
install_github("ogroendal/DSTget")
```

## Features
DSTget has the following features:

* Easily retrieve updated versions of tables without updating your code.
* Set time periods as R dates
* Get convenient extra variables - such as all statistical periods converted
  to R dates
* Transform implicit DST datatypes into their R equivelants automatically -
  factors and dates are thus represented cleanly.
* Make it easy to learn more about the contents of a table.
* Get around download limits set in place by the standard web interface.
* Makes it faster to construct table calls
* Get more meaningful error messages

## Get started DSTget assumes you know the name of the table you want.
Refer to statistikbanken.dk for an overview of the thousands of free and
amazing tables on offer.

### Downloading a table
If you just want the whole table, simply supply the table name.
The below example is a long time series of divorces and marriages in Denmark.

The MyTableObject contains table metadata.

```R
MyTableObject <- DSTget('BEV3C')
MyDataFrame <- getData(MyTableObject)
```

### Exploring table metadata
You can check for yourself the metadata of a table

```R
MyTableObject <- DSTget('BEV3C')
summary(MyTableObject) ## gives a convenient summary of the table
```

You can see all the possible values of a variable using the metadata object.
First check the variables and then check the values

```R
MyTableObject <- DSTget('HFUDD10')
head(MyTableObject$variables)
head(MyTableObject$values$HFUDD)
```

### Specifying variables and values
If the table is large you can select only a few variables, cutting download
times and complexity.  The below example is the main population table, where we
want the data summarized only on gender, marriage status and age.  We subset
the data on the variable CIVILSTAND, seeing only married or divorced
individuals. We also specify that we want to see numbers from after the beginning
of 2017. And that only for the ages of 10, 20 and 30 year olds.

```R
MyTableObject <- DSTget('FOLK1A')
MyDataFrame <- getData(MyTableObject, CIVILSTAND = c("F", "G"),
 ALDER = c(10,20,30) ,  startDate = as.Date("2017-01-01"))
```

## Fill out all remaining variables
If want almost all variables but dont want to specify them manually, then you 
can use the `fillRemaining` argument.

```R
MyTableObject <- DSTget('FOLK1A')
MyDataFrame <- getData(MyTableObject, CIVILSTAND = c("F", "G"),
 ALDER = c(10,20,30) ,  startDate = as.Date("2017-01-01"), fillRemaining = T)
```

Now MyDataFrama also contains all the values for all variables not mentioned
in the table specification.

## Downloading large tables
Sometimes your table specification generates more than 100.000 rows. At which
point the DST api will stop you. DSTget will conveniently split your table
specification into a series of smaller downloads, and then give you one large
table. Simplify specify the `splitLarge` argument.  Be careful, downloading
250K rows or 5 million rows is totally fine for most computers and connections,
but there are tables that are many many times bigger.

```R
MyTableObject <- DSTget('FOLK1A')
MyDataFrame <- getData(MyTableObject, CIVILSTAND = c("F","G"), ALDER = 1:80,
 startDate = as.Date("2016-01-01"), fillRemaining = T, splitLarge = T)
```
