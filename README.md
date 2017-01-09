DSTget
======

## Get Statistics Denmark easily into R
DSTget makes it easy to download Statistics Denmark (DST) data
straight into R and keep them updated. Its an interface to the
flexible DST API.

## Features
DSTget has the following features:

* Easily retrieve updated versions of tables without updating your code.
* Transform implicit DST datatypes into their R equivelants automatically - factors and dates are thus represented cleanly.
* Make it easy to learn more about the contents of a table.
* Get around download limits set in place by the standard web interface.

## Get started
DSTget assumes you know the name of the table you want. Refer to statistikbanken.dk for an overview of the thousands of tables on offer.

### Downloading a table
If you just want the whole table, simply supply the table name.
The below example is a long time series of divorces and marriages in Denmark.

```R
MyTableObject <- DSTget('BEV3C')
MyDataFrame <- getData(MyTableObject)
```

### Specifying variables and values
If the table is large you can select only a few variables, cutting download times and complexity.
The below example is the main population table, where we want the data summarized only on gender, marriage status and age.
We subset the data on the variable CIVILSTAND, seeing only married or divorced individuals.

```R
MyTableObject <- DSTget('FOLK1')
MyDataFrame <- getData(MyTableObject,KØN,ALDER,CIVILSTAND = c('F','G'))
```
