Lecture 17 - Network Analysis
================
ACGeffre
5/29/2019

Network Analysis in R and CytoScape
===================================

For this lab section, we will be working with the data described in [Lecture 17](https://bioboot.github.io/bggn213_S19/class-material/lecture17_BGGN213_S19_new.html) of the BGGN 213 curriculum.

Setting up the R - Cytoscape Connections
----------------------------------------

To work with CytoScape in R, we need to connect the two. To do this, let's install the required packages **RCy3** and **iGraph** from CRAN/BioConductor.

#### Install RCy3 from bioConductor

``` r
# Here is the stuff we need to grab the package from BioConductor
#if (!requireNamespace("BiocManager", quietly = TRUE))
#    install.packages("BiocManager")
#BiocManager::install("RCy3")

library(RCy3)
```

    ## Registered S3 method overwritten by 'R.oo':
    ##   method        from       
    ##   throw.default R.methodsS3

#### Install iGraph from CRAN

``` r
#install.packages("igraph")
library(igraph)
```

    ## 
    ## Attaching package: 'igraph'

    ## The following objects are masked from 'package:stats':
    ## 
    ##     decompose, spectrum

    ## The following object is masked from 'package:base':
    ## 
    ##     union
