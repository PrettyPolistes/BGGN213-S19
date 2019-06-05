Lect7Stuff
================

More on Function writing
------------------------

Revist function fro previous class (which I missed ;\_;)

``` r
source("http://tinyurl.com/rescale-R") # loads a suite of functions associated with "Rescale", from the internets
```

Let's test the **rescale()** function

``` r
rescale(1:10) # relevels the numebers from 1 to 10 to fit betweeb 0 and 1. 
```

    ##  [1] 0.0000000 0.1111111 0.2222222 0.3333333 0.4444444 0.5555556 0.6666667
    ##  [8] 0.7777778 0.8888889 1.0000000

When writing functions we can include warning messages and/or stop the function from working in the instance of weird input.

E.G. we can use warning(), to give a warning but continue the function, or the stop() function to cease the function before finishing.

**For example: baseline rescale()** function(x, na.rm=TRUE, plot=FALSE, ...) { \# Our rescale function from the end of lecture 9

if(na.rm) { rng &lt;-range(x, na.rm=TRUE) } else { rng &lt;-range(x) }

answer &lt;- (x - rng\[1\]) / (rng\[2\] - rng\[1\]) if(plot) { plot(answer, ...) }

return(answer) }

**Rescale with warnings:** function(x, na.rm=TRUE, plot=FALSE, ...) { \# Our rescale function from lecture 10

if( !is.numeric(x) ) { stop("Input x should be numeric", call.=FALSE) }

rng &lt;-range(x, na.rm=TRUE)

answer &lt;- (x - rng\[1\]) / (rng\[2\] - rng\[1\]) if(plot) { plot(answer, ...) }

return(answer) }

Good function writing • Understandable (remember that functions are for humans and computers) • Correct + Understandable = Obviously correct • Use sensible names throughout. What does this code do? • Good names make code understandable with minimal context. You should strive for self-explanatory names

``` r
# Write a function for us
# Create dataset for testing
x <- c( 1, 2, NA, 3, NA) 
y <- c(NA, 3, NA, 3, 4)
```

``` r
is.na(x) & is.na(y) # looks for when both data sets are cuncidentally
```

    ## [1] FALSE FALSE  TRUE FALSE FALSE

``` r
sum(is.na(x) & is.na(y) )
```

    ## [1] 1

``` r
# These results indicate that there is only onespot for in th enew DNA where thei;r seuquences are the same.
```

``` r
both_na <- function(x,y) {
  sum(is.na(x) & is.na(y))
}
```

``` r
both_na(c(NA, NA, NA), c(NA, NA, 1))
```

    ## [1] 2

``` r
# the end  ouput is a rsult which desxfibes the two datas at which your views on both platforms are the same. 
```

``` r
both_na2 <- function(x, y) {
 if(length(x) != length(y)) {
 stop("Input x and y should be the same length")
 }
 sum( is.na(x) & is.na(y) )
}
```

``` r
both_na3 <- function(x, y) {
 if(length(x) != length(y)) {
 stop("Input x and y should be vectors of the same length")
 }

 na.in.both <- ( is.na(x) & is.na(y) )
 na.number <- sum(na.in.both)
 na.which <- which(na.in.both)  # where "which: finds positions that are true to this statement.
 message("Found ", na.number, " NA's at position(s):",
 paste(na.which, collapse=", ") )

 return( list(number=na.number, which=na.which) )
}
```

Write a grading function (as in lab handout for this week)

``` r
# We need to select remove the lowest scores from each student's assignments
# After that we can calculate a mean score for each student and determine if they have passed. 

# Create "Student 1" and "Student 2" vectors to test our function with
st1 <- c(100, 100, 100, 100, 100, 100, 100, 90)
st2 <- c(100, NA, 90, 90, 90, 90, 97, 80)

grade <- function(x) {
  (sum(x, na.rm = T) - min(x, na.rm = T))/(length(x)-1)
  }

grade(st1)
```

    ## [1] 100

``` r
grade(st2)
```

    ## [1] 79.57143

Let's apply this to a dataframe.

``` r
hwk <- read.csv("student_homework.csv", row.names = 1)

grade(hwk[1,])
```

    ## [1] 91.75

``` r
apply(hwk, 1, grade) # use margin = 1 to apply across rows!
```

    ##  student-1  student-2  student-3  student-4  student-5  student-6 
    ##      91.75      82.50      84.25      66.00      88.25      89.00 
    ##  student-7  student-8  student-9 student-10 student-11 student-12 
    ##      94.00      93.75      87.75      61.00      86.00      91.75 
    ## student-13 student-14 student-15 student-16 student-17 student-18 
    ##      92.25      87.75      62.50      89.50      88.00      72.75 
    ## student-19 student-20 
    ##      82.75      82.75

``` r
# apply(df, MARGIN = "", FUNCTION) is the basic format for apply
```

``` r
# Sort by top performers in class
ans <- apply(hwk, 1, grade)
sort(ans, decreasing = T ) # sorts our vector by value in decreasing order
```

    ##  student-7  student-8 student-13  student-1 student-12 student-16 
    ##      94.00      93.75      92.25      91.75      91.75      89.50 
    ##  student-6  student-5 student-17  student-9 student-14 student-11 
    ##      89.00      88.25      88.00      87.75      87.75      86.00 
    ##  student-3 student-19 student-20  student-2 student-18  student-4 
    ##      84.25      82.75      82.75      82.50      72.75      66.00 
    ## student-15 student-10 
    ##      62.50      61.00

More examples of functions
--------------------------

``` r
source("https://tinyurl.com/rescale-R")
df1 <- data.frame(IDs=c("gene1", "gene2", "gene3"),
    exp=c(2,1,1),
    stringsAsFactors=FALSE)

df2 <- data.frame(IDs=c("gene2", "gene4", "gene3", "gene5"),
    exp=c(-2, NA, 1, 2),
    stringsAsFactors=FALSE)

# Make single vectors
x <- df1$IDs
y <- df2$IDs

intersect(x,y) # find gene ids that match between data sets
```

    ## [1] "gene2" "gene3"

``` r
x %in% y # Finds all items in x, that are contained in y
```

    ## [1] FALSE  TRUE  TRUE

``` r
x[x %in% y] # Lists the overlapping IDs
```

    ## [1] "gene2" "gene3"

``` r
y %in% x # Finds all items in y, that are contained in y
```

    ## [1]  TRUE FALSE  TRUE FALSE

``` r
y[y %in% x]
```

    ## [1] "gene2" "gene3"

``` r
cbind(x[x %in% y], y[y %in% x])
```

    ##      [,1]    [,2]   
    ## [1,] "gene2" "gene2"
    ## [2,] "gene3" "gene3"

``` r
# Make that shit a function
gene_intersect <- function(x, y) {
 cbind( x[ x %in% y ], y[ y %in% x ] )
}

gene_intersect(x,y)
```

    ##      [,1]    [,2]   
    ## [1,] "gene2" "gene2"
    ## [2,] "gene3" "gene3"

``` r
# Makes a cute little table for this.
```

``` r
# PRevious function doesn't work with dataframes, though.
gene_intersect2 <- function(df1, df2) {
 cbind( df1[ df1$IDs %in% df2$IDs, ], #assumes my df have an "ID" column
 df2[ df2$IDs %in% df1$IDs, "exp"] )
}
gene_intersect2(df1, df2)
```

    ##     IDs exp df2[df2$IDs %in% df1$IDs, "exp"]
    ## 2 gene2   1                               -2
    ## 3 gene3   1                                1

``` r
# 
```

``` r
gene_intersect3 <- function(df1, df2, gene.colname="IDs") {  
  # allows user to specify ID names through gene.colname input
 cbind( df1[ df1[,gene.colname] %in%
 df2[,gene.colname], ],
 exp2=df2[ df2[,gene.colname] %in%
 df1[,gene.colname], "exp"] )
}
```
