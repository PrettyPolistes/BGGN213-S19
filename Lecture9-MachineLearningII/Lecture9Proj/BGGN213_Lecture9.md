BGGN213\_Lecture9
================
ACGeffre
May 1st 2019

PCA continued (in Lecture 9)
============================

Scaling - a PCA issue
---------------------

We can use 'prcomp(x, scale=TRUE)' to scale data in PCAs. WHy scale our data?

Variables may be in very different units (e.g. for the mtcars dataset, we have variables mpg (distance), and cylinders (absolute count) - these are both very different variables)

Hands-on Lab excersize
======================

Reading in the data
-------------------

We are using a data set of women from Wisconsin, who had breat biopsies to assay for cancer.Thsi dataset includes the patient ID, diagnosis (b or m) and 31 continuous variables describing physical properties fo the biopsy.

We will call this dataset will be called "wisc"

``` r
wisc <- read.csv("WisconsinCancer.csv")
head(wisc) # Describes the data
```

    ##         id diagnosis radius_mean texture_mean perimeter_mean area_mean
    ## 1   842302         M       17.99        10.38         122.80    1001.0
    ## 2   842517         M       20.57        17.77         132.90    1326.0
    ## 3 84300903         M       19.69        21.25         130.00    1203.0
    ## 4 84348301         M       11.42        20.38          77.58     386.1
    ## 5 84358402         M       20.29        14.34         135.10    1297.0
    ## 6   843786         M       12.45        15.70          82.57     477.1
    ##   smoothness_mean compactness_mean concavity_mean concave.points_mean
    ## 1         0.11840          0.27760         0.3001             0.14710
    ## 2         0.08474          0.07864         0.0869             0.07017
    ## 3         0.10960          0.15990         0.1974             0.12790
    ## 4         0.14250          0.28390         0.2414             0.10520
    ## 5         0.10030          0.13280         0.1980             0.10430
    ## 6         0.12780          0.17000         0.1578             0.08089
    ##   symmetry_mean fractal_dimension_mean radius_se texture_se perimeter_se
    ## 1        0.2419                0.07871    1.0950     0.9053        8.589
    ## 2        0.1812                0.05667    0.5435     0.7339        3.398
    ## 3        0.2069                0.05999    0.7456     0.7869        4.585
    ## 4        0.2597                0.09744    0.4956     1.1560        3.445
    ## 5        0.1809                0.05883    0.7572     0.7813        5.438
    ## 6        0.2087                0.07613    0.3345     0.8902        2.217
    ##   area_se smoothness_se compactness_se concavity_se concave.points_se
    ## 1  153.40      0.006399        0.04904      0.05373           0.01587
    ## 2   74.08      0.005225        0.01308      0.01860           0.01340
    ## 3   94.03      0.006150        0.04006      0.03832           0.02058
    ## 4   27.23      0.009110        0.07458      0.05661           0.01867
    ## 5   94.44      0.011490        0.02461      0.05688           0.01885
    ## 6   27.19      0.007510        0.03345      0.03672           0.01137
    ##   symmetry_se fractal_dimension_se radius_worst texture_worst
    ## 1     0.03003             0.006193        25.38         17.33
    ## 2     0.01389             0.003532        24.99         23.41
    ## 3     0.02250             0.004571        23.57         25.53
    ## 4     0.05963             0.009208        14.91         26.50
    ## 5     0.01756             0.005115        22.54         16.67
    ## 6     0.02165             0.005082        15.47         23.75
    ##   perimeter_worst area_worst smoothness_worst compactness_worst
    ## 1          184.60     2019.0           0.1622            0.6656
    ## 2          158.80     1956.0           0.1238            0.1866
    ## 3          152.50     1709.0           0.1444            0.4245
    ## 4           98.87      567.7           0.2098            0.8663
    ## 5          152.20     1575.0           0.1374            0.2050
    ## 6          103.40      741.6           0.1791            0.5249
    ##   concavity_worst concave.points_worst symmetry_worst
    ## 1          0.7119               0.2654         0.4601
    ## 2          0.2416               0.1860         0.2750
    ## 3          0.4504               0.2430         0.3613
    ## 4          0.6869               0.2575         0.6638
    ## 5          0.4000               0.1625         0.2364
    ## 6          0.5355               0.1741         0.3985
    ##   fractal_dimension_worst  X
    ## 1                 0.11890 NA
    ## 2                 0.08902 NA
    ## 3                 0.08758 NA
    ## 4                 0.17300 NA
    ## 5                 0.07678 NA
    ## 6                 0.12440 NA

``` r
length(wisc$id)  # how many patients?
```

    ## [1] 569

``` r
table(wisc$diagnosis) # How many benign (b) and malignant (m) disgnoses?
```

    ## 
    ##   B   M 
    ## 357 212

``` r
length(grep("_mean", colnames(wisc))) # how many columns have the phrase "_mean" in them?
```

    ## [1] 10

Prepare the data for PCA
------------------------

To ready out dataframe for PCA, we need to convert it to a matrix, and also make sure only numeric data exists therein. (e.g. pop off non-numeric columns, like ID and diagnosis, and the empty x column full of NAs at the end).

``` r
# make a matrix from all the rows, but only columns 3-32 of the datafram wisc
wiscdat <- as.matrix(wisc[,3:32]) 
```

Now we will import the patient IDs onto the rownames of the matrix. This prevents the need to have columns with strings in them.

``` r
row.names(wiscdat) <- wisc$id # Pop the names from original set to the new matrix
head(wiscdat)  # Now the matrix has row names that correspond to the patient IDs
```

    ##          radius_mean texture_mean perimeter_mean area_mean smoothness_mean
    ## 842302         17.99        10.38         122.80    1001.0         0.11840
    ## 842517         20.57        17.77         132.90    1326.0         0.08474
    ## 84300903       19.69        21.25         130.00    1203.0         0.10960
    ## 84348301       11.42        20.38          77.58     386.1         0.14250
    ## 84358402       20.29        14.34         135.10    1297.0         0.10030
    ## 843786         12.45        15.70          82.57     477.1         0.12780
    ##          compactness_mean concavity_mean concave.points_mean symmetry_mean
    ## 842302            0.27760         0.3001             0.14710        0.2419
    ## 842517            0.07864         0.0869             0.07017        0.1812
    ## 84300903          0.15990         0.1974             0.12790        0.2069
    ## 84348301          0.28390         0.2414             0.10520        0.2597
    ## 84358402          0.13280         0.1980             0.10430        0.1809
    ## 843786            0.17000         0.1578             0.08089        0.2087
    ##          fractal_dimension_mean radius_se texture_se perimeter_se area_se
    ## 842302                  0.07871    1.0950     0.9053        8.589  153.40
    ## 842517                  0.05667    0.5435     0.7339        3.398   74.08
    ## 84300903                0.05999    0.7456     0.7869        4.585   94.03
    ## 84348301                0.09744    0.4956     1.1560        3.445   27.23
    ## 84358402                0.05883    0.7572     0.7813        5.438   94.44
    ## 843786                  0.07613    0.3345     0.8902        2.217   27.19
    ##          smoothness_se compactness_se concavity_se concave.points_se
    ## 842302        0.006399        0.04904      0.05373           0.01587
    ## 842517        0.005225        0.01308      0.01860           0.01340
    ## 84300903      0.006150        0.04006      0.03832           0.02058
    ## 84348301      0.009110        0.07458      0.05661           0.01867
    ## 84358402      0.011490        0.02461      0.05688           0.01885
    ## 843786        0.007510        0.03345      0.03672           0.01137
    ##          symmetry_se fractal_dimension_se radius_worst texture_worst
    ## 842302       0.03003             0.006193        25.38         17.33
    ## 842517       0.01389             0.003532        24.99         23.41
    ## 84300903     0.02250             0.004571        23.57         25.53
    ## 84348301     0.05963             0.009208        14.91         26.50
    ## 84358402     0.01756             0.005115        22.54         16.67
    ## 843786       0.02165             0.005082        15.47         23.75
    ##          perimeter_worst area_worst smoothness_worst compactness_worst
    ## 842302            184.60     2019.0           0.1622            0.6656
    ## 842517            158.80     1956.0           0.1238            0.1866
    ## 84300903          152.50     1709.0           0.1444            0.4245
    ## 84348301           98.87      567.7           0.2098            0.8663
    ## 84358402          152.20     1575.0           0.1374            0.2050
    ## 843786            103.40      741.6           0.1791            0.5249
    ##          concavity_worst concave.points_worst symmetry_worst
    ## 842302            0.7119               0.2654         0.4601
    ## 842517            0.2416               0.1860         0.2750
    ## 84300903          0.4504               0.2430         0.3613
    ## 84348301          0.6869               0.2575         0.6638
    ## 84358402          0.4000               0.1625         0.2364
    ## 843786            0.5355               0.1741         0.3985
    ##          fractal_dimension_worst
    ## 842302                   0.11890
    ## 842517                   0.08902
    ## 84300903                 0.08758
    ## 84348301                 0.17300
    ## 84358402                 0.07678
    ## 843786                   0.12440

For visualizing cluster patterns later, we are going to store diagnosis as a vecotr to be overlayed onto our PCA plots later.

``` r
diagnosis <- wisc$diagnosis
# This stores the diagnosis for each patient in a vector we can use with PCA later
```

Run the PCA
-----------

Firstly, we discussed that data variables with very different units/variances can be difficult to collapse in PCA. Let's check our data for this issue:

### Check the data

``` r
colMeans(wiscdat) # find the means for each column
```

    ##             radius_mean            texture_mean          perimeter_mean 
    ##            1.412729e+01            1.928965e+01            9.196903e+01 
    ##               area_mean         smoothness_mean        compactness_mean 
    ##            6.548891e+02            9.636028e-02            1.043410e-01 
    ##          concavity_mean     concave.points_mean           symmetry_mean 
    ##            8.879932e-02            4.891915e-02            1.811619e-01 
    ##  fractal_dimension_mean               radius_se              texture_se 
    ##            6.279761e-02            4.051721e-01            1.216853e+00 
    ##            perimeter_se                 area_se           smoothness_se 
    ##            2.866059e+00            4.033708e+01            7.040979e-03 
    ##          compactness_se            concavity_se       concave.points_se 
    ##            2.547814e-02            3.189372e-02            1.179614e-02 
    ##             symmetry_se    fractal_dimension_se            radius_worst 
    ##            2.054230e-02            3.794904e-03            1.626919e+01 
    ##           texture_worst         perimeter_worst              area_worst 
    ##            2.567722e+01            1.072612e+02            8.805831e+02 
    ##        smoothness_worst       compactness_worst         concavity_worst 
    ##            1.323686e-01            2.542650e-01            2.721885e-01 
    ##    concave.points_worst          symmetry_worst fractal_dimension_worst 
    ##            1.146062e-01            2.900756e-01            8.394582e-02

``` r
hist(colMeans(wiscdat), breaks = 20)
```

![](BGGN213_Lecture9_files/figure-markdown_github/unnamed-chunk-5-1.png)

There are some means that are very different from the others - suggests we might want to scale.

``` r
wiscsd <- apply(wiscdat,2,sd) # apply the sd() function over all columns
hist(wiscsd, breaks = 20)
```

![](BGGN213_Lecture9_files/figure-markdown_github/unnamed-chunk-6-1.png)

Ditto the std. deviation of the data - also suggests we might want to scale.

We can scale before hand, using scale(), or feed this argument into prcomp (see below).

### PCA the data

``` r
wiscpr <- prcomp(wiscdat, scale. = TRUE) # scale them shits
wiscpr
```

    ## Standard deviations (1, .., p=30):
    ##  [1] 3.64439401 2.38565601 1.67867477 1.40735229 1.28402903 1.09879780
    ##  [7] 0.82171778 0.69037464 0.64567392 0.59219377 0.54213992 0.51103950
    ## [13] 0.49128148 0.39624453 0.30681422 0.28260007 0.24371918 0.22938785
    ## [19] 0.22243559 0.17652026 0.17312681 0.16564843 0.15601550 0.13436892
    ## [25] 0.12442376 0.09043030 0.08306903 0.03986650 0.02736427 0.01153451
    ## 
    ## Rotation (n x k) = (30 x 30):
    ##                                 PC1          PC2          PC3          PC4
    ## radius_mean             -0.21890244  0.233857132 -0.008531243  0.041408962
    ## texture_mean            -0.10372458  0.059706088  0.064549903 -0.603050001
    ## perimeter_mean          -0.22753729  0.215181361 -0.009314220  0.041983099
    ## area_mean               -0.22099499  0.231076711  0.028699526  0.053433795
    ## smoothness_mean         -0.14258969 -0.186113023 -0.104291904  0.159382765
    ## compactness_mean        -0.23928535 -0.151891610 -0.074091571  0.031794581
    ## concavity_mean          -0.25840048 -0.060165363  0.002733838  0.019122753
    ## concave.points_mean     -0.26085376  0.034767500 -0.025563541  0.065335944
    ## symmetry_mean           -0.13816696 -0.190348770 -0.040239936  0.067124984
    ## fractal_dimension_mean  -0.06436335 -0.366575471 -0.022574090  0.048586765
    ## radius_se               -0.20597878  0.105552152  0.268481387  0.097941242
    ## texture_se              -0.01742803 -0.089979682  0.374633665 -0.359855528
    ## perimeter_se            -0.21132592  0.089457234  0.266645367  0.088992415
    ## area_se                 -0.20286964  0.152292628  0.216006528  0.108205039
    ## smoothness_se           -0.01453145 -0.204430453  0.308838979  0.044664180
    ## compactness_se          -0.17039345 -0.232715896  0.154779718 -0.027469363
    ## concavity_se            -0.15358979 -0.197207283  0.176463743  0.001316880
    ## concave.points_se       -0.18341740 -0.130321560  0.224657567  0.074067335
    ## symmetry_se             -0.04249842 -0.183848000  0.288584292  0.044073351
    ## fractal_dimension_se    -0.10256832 -0.280092027  0.211503764  0.015304750
    ## radius_worst            -0.22799663  0.219866379 -0.047506990  0.015417240
    ## texture_worst           -0.10446933  0.045467298 -0.042297823 -0.632807885
    ## perimeter_worst         -0.23663968  0.199878428 -0.048546508  0.013802794
    ## area_worst              -0.22487053  0.219351858 -0.011902318  0.025894749
    ## smoothness_worst        -0.12795256 -0.172304352 -0.259797613  0.017652216
    ## compactness_worst       -0.21009588 -0.143593173 -0.236075625 -0.091328415
    ## concavity_worst         -0.22876753 -0.097964114 -0.173057335 -0.073951180
    ## concave.points_worst    -0.25088597  0.008257235 -0.170344076  0.006006996
    ## symmetry_worst          -0.12290456 -0.141883349 -0.271312642 -0.036250695
    ## fractal_dimension_worst -0.13178394 -0.275339469 -0.232791313 -0.077053470
    ##                                  PC5           PC6           PC7
    ## radius_mean             -0.037786354  0.0187407904 -0.1240883403
    ## texture_mean             0.049468850 -0.0321788366  0.0113995382
    ## perimeter_mean          -0.037374663  0.0173084449 -0.1144770573
    ## area_mean               -0.010331251 -0.0018877480 -0.0516534275
    ## smoothness_mean          0.365088528 -0.2863744966 -0.1406689928
    ## compactness_mean        -0.011703971 -0.0141309489  0.0309184960
    ## concavity_mean          -0.086375412 -0.0093441809 -0.1075204434
    ## concave.points_mean      0.043861025 -0.0520499505 -0.1504822142
    ## symmetry_mean            0.305941428  0.3564584607 -0.0938911345
    ## fractal_dimension_mean   0.044424360 -0.1194306679  0.2957600240
    ## radius_se                0.154456496 -0.0256032561  0.3124900373
    ## texture_se               0.191650506 -0.0287473145 -0.0907553556
    ## perimeter_se             0.120990220  0.0018107150  0.3146403902
    ## area_se                  0.127574432 -0.0428639079  0.3466790028
    ## smoothness_se            0.232065676 -0.3429173935 -0.2440240556
    ## compactness_se          -0.279968156  0.0691975186  0.0234635340
    ## concavity_se            -0.353982091  0.0563432386 -0.2088237897
    ## concave.points_se       -0.195548089 -0.0312244482 -0.3696459369
    ## symmetry_se              0.252868765  0.4902456426 -0.0803822539
    ## fractal_dimension_se    -0.263297438 -0.0531952674  0.1913949726
    ## radius_worst             0.004406592 -0.0002906849 -0.0097099360
    ## texture_worst            0.092883400 -0.0500080613  0.0098707439
    ## perimeter_worst         -0.007454151  0.0085009872 -0.0004457267
    ## area_worst               0.027390903 -0.0251643821  0.0678316595
    ## smoothness_worst         0.324435445 -0.3692553703 -0.1088308865
    ## compactness_worst       -0.121804107  0.0477057929  0.1404729381
    ## concavity_worst         -0.188518727  0.0283792555 -0.0604880561
    ## concave.points_worst    -0.043332069 -0.0308734498 -0.1679666187
    ## symmetry_worst           0.244558663  0.4989267845 -0.0184906298
    ## fractal_dimension_worst -0.094423351 -0.0802235245  0.3746576261
    ##                                  PC8          PC9         PC10        PC11
    ## radius_mean              0.007452296 -0.223109764  0.095486443 -0.04147149
    ## texture_mean            -0.130674825  0.112699390  0.240934066  0.30224340
    ## perimeter_mean           0.018687258 -0.223739213  0.086385615 -0.01678264
    ## area_mean               -0.034673604 -0.195586014  0.074956489 -0.11016964
    ## smoothness_mean          0.288974575  0.006424722 -0.069292681  0.13702184
    ## compactness_mean         0.151396350 -0.167841425  0.012936200  0.30800963
    ## concavity_mean           0.072827285  0.040591006 -0.135602298 -0.12419024
    ## concave.points_mean      0.152322414 -0.111971106  0.008054528  0.07244603
    ## symmetry_mean            0.231530989  0.256040084  0.572069479 -0.16305408
    ## fractal_dimension_mean   0.177121441 -0.123740789  0.081103207  0.03804827
    ## radius_se               -0.022539967  0.249985002 -0.049547594  0.02535702
    ## texture_se               0.475413139 -0.246645397 -0.289142742 -0.34494446
    ## perimeter_se             0.011896690  0.227154024 -0.114508236  0.16731877
    ## area_se                 -0.085805135  0.229160015 -0.091927889 -0.05161946
    ## smoothness_se           -0.573410232 -0.141924890  0.160884609 -0.08420621
    ## compactness_se          -0.117460157 -0.145322810  0.043504866  0.20688568
    ## concavity_se            -0.060566501  0.358107079 -0.141276243 -0.34951794
    ## concave.points_se        0.108319309  0.272519886  0.086240847  0.34237591
    ## symmetry_se             -0.220149279 -0.304077200 -0.316529830  0.18784404
    ## fractal_dimension_se    -0.011168188 -0.213722716  0.367541918 -0.25062479
    ## radius_worst            -0.042619416 -0.112141463  0.077361643 -0.10506733
    ## texture_worst           -0.036251636  0.103341204  0.029550941 -0.01315727
    ## perimeter_worst         -0.030558534 -0.109614364  0.050508334 -0.05107628
    ## area_worst              -0.079394246 -0.080732461  0.069921152 -0.18459894
    ## smoothness_worst        -0.205852191  0.112315904 -0.128304659 -0.14389035
    ## compactness_worst       -0.084019659 -0.100677822 -0.172133632  0.19742047
    ## concavity_worst         -0.072467871  0.161908621 -0.311638520 -0.18501676
    ## concave.points_worst     0.036170795  0.060488462 -0.076648291  0.11777205
    ## symmetry_worst          -0.228225053  0.064637806 -0.029563075 -0.15756025
    ## fractal_dimension_worst -0.048360667 -0.134174175  0.012609579 -0.11828355
    ##                                 PC12        PC13         PC14         PC15
    ## radius_mean              0.051067457  0.01196721  0.059506135 -0.051118775
    ## texture_mean             0.254896423  0.20346133 -0.021560100 -0.107922421
    ## perimeter_mean           0.038926106  0.04410950  0.048513812 -0.039902936
    ## area_mean                0.065437508  0.06737574  0.010830829  0.013966907
    ## smoothness_mean          0.316727211  0.04557360  0.445064860 -0.118143364
    ## compactness_mean        -0.104017044  0.22928130  0.008101057  0.230899962
    ## concavity_mean           0.065653480  0.38709081 -0.189358699 -0.128283732
    ## concave.points_mean      0.042589267  0.13213810 -0.244794768 -0.217099194
    ## symmetry_mean           -0.288865504  0.18993367  0.030738856 -0.073961707
    ## fractal_dimension_mean   0.236358988  0.10623908 -0.377078865  0.517975705
    ## radius_se               -0.016687915 -0.06819523  0.010347413 -0.110050711
    ## texture_se              -0.306160423 -0.16822238 -0.010849347  0.032752721
    ## perimeter_se            -0.101446828 -0.03784399 -0.045523718 -0.008268089
    ## area_se                 -0.017679218  0.05606493  0.083570718 -0.046024366
    ## smoothness_se           -0.294710053  0.15044143 -0.201152530  0.018559465
    ## compactness_se          -0.263456509  0.01004017  0.491755932  0.168209315
    ## concavity_se             0.251146975  0.15878319  0.134586924  0.250471408
    ## concave.points_se       -0.006458751 -0.49402674 -0.199666719  0.062079344
    ## symmetry_se              0.320571348  0.01033274 -0.046864383 -0.113383199
    ## fractal_dimension_se     0.276165974 -0.24045832  0.145652466 -0.353232211
    ## radius_worst             0.039679665 -0.13789053  0.023101281  0.166567074
    ## texture_worst            0.079797450 -0.08014543  0.053430792  0.101115399
    ## perimeter_worst         -0.008987738 -0.09696571  0.012219382  0.182755198
    ## area_worst               0.048088657 -0.10116061 -0.006685465  0.314993600
    ## smoothness_worst         0.056514866 -0.20513034  0.162235443  0.046125866
    ## compactness_worst       -0.371662503  0.01227931  0.166470250 -0.049956014
    ## concavity_worst         -0.087034532  0.21798433 -0.066798931 -0.204835886
    ## concave.points_worst    -0.068125354 -0.25438749 -0.276418891 -0.169499607
    ## symmetry_worst           0.044033503 -0.25653491  0.005355574  0.139888394
    ## fractal_dimension_worst -0.034731693 -0.17281424 -0.212104110 -0.256173195
    ##                                PC16         PC17          PC18        PC19
    ## radius_mean             -0.15058388  0.202924255  0.1467123385  0.22538466
    ## texture_mean            -0.15784196 -0.038706119 -0.0411029851  0.02978864
    ## perimeter_mean          -0.11445396  0.194821310  0.1583174548  0.23959528
    ## area_mean               -0.13244803  0.255705763  0.2661681046 -0.02732219
    ## smoothness_mean         -0.20461325  0.167929914 -0.3522268017 -0.16456584
    ## compactness_mean         0.17017837 -0.020307708  0.0077941384  0.28422236
    ## concavity_mean           0.26947021 -0.001598353 -0.0269681105  0.00226636
    ## concave.points_mean      0.38046410  0.034509509 -0.0828277367 -0.15497236
    ## symmetry_mean           -0.16466159 -0.191737848  0.1733977905 -0.05881116
    ## fractal_dimension_mean  -0.04079279  0.050225246  0.0878673570 -0.05815705
    ## radius_se                0.05890572 -0.139396866 -0.2362165319  0.17588331
    ## texture_se              -0.03450040  0.043963016 -0.0098586620  0.03600985
    ## perimeter_se             0.02651665 -0.024635639 -0.0259288003  0.36570154
    ## area_se                  0.04115323  0.334418173  0.3049069032 -0.41657231
    ## smoothness_se           -0.05803906  0.139595006 -0.2312599432 -0.01326009
    ## compactness_se           0.18983090 -0.008246477  0.1004742346 -0.24244818
    ## concavity_se            -0.12542065  0.084616716 -0.0001954852  0.12638102
    ## concave.points_se       -0.19881035  0.108132263  0.0460549116 -0.01216430
    ## symmetry_se             -0.15771150 -0.274059129  0.1870147640 -0.08903929
    ## fractal_dimension_se     0.26855388 -0.122733398 -0.0598230982  0.08660084
    ## radius_worst            -0.08156057 -0.240049982 -0.2161013526  0.01366130
    ## texture_worst            0.18555785  0.069365185  0.0583984505 -0.07586693
    ## perimeter_worst         -0.05485705 -0.234164147 -0.1885435919  0.09081325
    ## area_worst              -0.09065339 -0.273399584 -0.1420648558 -0.41004720
    ## smoothness_worst         0.14555166 -0.278030197  0.5015516751  0.23451384
    ## compactness_worst       -0.15373486 -0.004037123 -0.0735745143  0.02020070
    ## concavity_worst         -0.21502195 -0.191313419 -0.1039079796 -0.04578612
    ## concave.points_worst     0.17814174 -0.075485316  0.0758138963 -0.26022962
    ## symmetry_worst           0.25789401  0.430658116 -0.2787138431  0.11725053
    ## fractal_dimension_worst -0.40555649  0.159394300  0.0235647497 -0.01149448
    ##                                 PC20          PC21        PC22
    ## radius_mean             -0.049698664 -0.0685700057 -0.07292890
    ## texture_mean            -0.244134993  0.4483694667 -0.09480063
    ## perimeter_mean          -0.017665012 -0.0697690429 -0.07516048
    ## area_mean               -0.090143762 -0.0184432785 -0.09756578
    ## smoothness_mean          0.017100960 -0.1194917473 -0.06382295
    ## compactness_mean         0.488686329  0.1926213963  0.09807756
    ## concavity_mean          -0.033387086  0.0055717533  0.18521200
    ## concave.points_mean     -0.235407606 -0.0094238187  0.31185243
    ## symmetry_mean            0.026069156 -0.0869384844  0.01840673
    ## fractal_dimension_mean  -0.175637222 -0.0762718362 -0.28786888
    ## radius_se               -0.090800503  0.0863867747  0.15027468
    ## texture_se              -0.071659988  0.2170719674 -0.04845693
    ## perimeter_se            -0.177250625 -0.3049501584 -0.15935280
    ## area_se                  0.274201148  0.1925877857 -0.06423262
    ## smoothness_se            0.090061477 -0.0720987261 -0.05054490
    ## compactness_se          -0.461098220 -0.1403865724  0.04528769
    ## concavity_se             0.066946174  0.0630479298  0.20521269
    ## concave.points_se        0.068868294  0.0343753236  0.07254538
    ## symmetry_se              0.107385289 -0.0976995265  0.08465443
    ## fractal_dimension_se     0.222345297  0.0628432814 -0.24470508
    ## radius_worst            -0.005626909  0.0072938995  0.09629821
    ## texture_worst            0.300599798 -0.5944401434  0.11111202
    ## perimeter_worst          0.011003858 -0.0920235990 -0.01722163
    ## area_worst               0.060047387  0.1467901315  0.09695982
    ## smoothness_worst        -0.129723903  0.1648492374  0.06825409
    ## compactness_worst        0.229280589  0.1813748671 -0.02967641
    ## concavity_worst         -0.046482792 -0.1321005945 -0.46042619
    ## concave.points_worst     0.033022340  0.0008860815 -0.29984056
    ## symmetry_worst          -0.116759236  0.1627085487 -0.09714484
    ## fractal_dimension_worst -0.104991974 -0.0923439434  0.46947115
    ##                                  PC23        PC24        PC25         PC26
    ## radius_mean             -0.0985526942 -0.18257944 -0.01922650 -0.129476396
    ## texture_mean            -0.0005549975  0.09878679  0.08474593 -0.024556664
    ## perimeter_mean          -0.0402447050 -0.11664888  0.02701541 -0.125255946
    ## area_mean                0.0077772734  0.06984834 -0.21004078  0.362727403
    ## smoothness_mean         -0.0206657211  0.06869742  0.02895489 -0.037003686
    ## compactness_mean         0.0523603957 -0.10413552  0.39662323  0.262808474
    ## concavity_mean           0.3248703785  0.04474106 -0.09697732 -0.548876170
    ## concave.points_mean     -0.0514087968  0.08402770 -0.18645160  0.387643377
    ## symmetry_mean           -0.0512005770  0.01933947 -0.02458369 -0.016044038
    ## fractal_dimension_mean  -0.0846898562 -0.13326055 -0.20722186 -0.097404839
    ## radius_se               -0.2641253170 -0.55870157 -0.17493043  0.049977080
    ## texture_se              -0.0008738805  0.02426730  0.05698648 -0.011237242
    ## perimeter_se             0.0900742110  0.51675039  0.07292764  0.103653282
    ## area_se                  0.0982150746 -0.02246072  0.13185041 -0.155304589
    ## smoothness_se           -0.0598177179  0.01563119  0.03121070 -0.007717557
    ## compactness_se           0.0091038710 -0.12177779  0.17316455 -0.049727632
    ## concavity_se            -0.3875423290  0.18820504  0.01593998  0.091454968
    ## concave.points_se        0.3517550738 -0.10966898 -0.12954655 -0.017941919
    ## symmetry_se             -0.0423628949  0.00322620 -0.01951493 -0.017267849
    ## fractal_dimension_se     0.0857810992  0.07519442 -0.08417120  0.035488974
    ## radius_worst            -0.0556767923 -0.15683037  0.07070972 -0.197054744
    ## texture_worst           -0.0089228997 -0.11848460 -0.11818972  0.036469433
    ## perimeter_worst          0.0633448296  0.23711317  0.11803403 -0.244103670
    ## area_worst               0.1908896250  0.14406303 -0.03828995  0.231359525
    ## smoothness_worst         0.0936901494 -0.01099014 -0.04796476  0.012602464
    ## compactness_worst       -0.1479209247  0.18674995 -0.62438494 -0.100463424
    ## concavity_worst          0.2864331353 -0.28885257  0.11577034  0.266853781
    ## concave.points_worst    -0.5675277966  0.10734024  0.26319634 -0.133574507
    ## symmetry_worst           0.1213434508 -0.01438181  0.04529962  0.028184296
    ## fractal_dimension_worst  0.0076253382  0.03782545  0.28013348  0.004520482
    ##                                 PC27          PC28          PC29
    ## radius_mean             -0.131526670  2.111940e-01  2.114605e-01
    ## texture_mean            -0.017357309 -6.581146e-05 -1.053393e-02
    ## perimeter_mean          -0.115415423  8.433827e-02  3.838261e-01
    ## area_mean                0.466612477 -2.725083e-01 -4.227949e-01
    ## smoothness_mean          0.069689923  1.479269e-03 -3.434667e-03
    ## compactness_mean         0.097748705 -5.462767e-03 -4.101677e-02
    ## concavity_mean           0.364808397  4.553864e-02 -1.001479e-02
    ## concave.points_mean     -0.454699351 -8.883097e-03 -4.206949e-03
    ## symmetry_mean           -0.015164835  1.433026e-03 -7.569862e-03
    ## fractal_dimension_mean  -0.101244946 -6.311687e-03  7.301433e-03
    ## radius_se                0.212982901 -1.922239e-01  1.184421e-01
    ## texture_se              -0.010092889 -5.622611e-03 -8.776279e-03
    ## perimeter_se             0.041691553  2.631919e-01 -6.100219e-03
    ## area_se                 -0.313358657 -4.206811e-02 -8.592591e-02
    ## smoothness_se           -0.009052154  9.792963e-03  1.776386e-03
    ## compactness_se           0.046536088 -1.539555e-02  3.158134e-03
    ## concavity_se            -0.084224797  5.820978e-03  1.607852e-02
    ## concave.points_se       -0.011165509 -2.900930e-02 -2.393779e-02
    ## symmetry_se             -0.019975983 -7.636526e-03 -5.223292e-03
    ## fractal_dimension_se    -0.012036564  1.975646e-02 -8.341912e-03
    ## radius_worst            -0.178666740  4.126396e-01 -6.357249e-01
    ## texture_worst            0.021410694 -3.902509e-04  1.723549e-02
    ## perimeter_worst         -0.241031046 -7.286809e-01  2.292180e-02
    ## area_worst               0.237162466  2.389603e-01  4.449359e-01
    ## smoothness_worst        -0.040853568 -1.535248e-03  7.385492e-03
    ## compactness_worst       -0.070505414  4.869182e-02  3.566904e-06
    ## concavity_worst         -0.142905801 -1.764090e-02 -1.267572e-02
    ## concave.points_worst     0.230901389  2.247567e-02  3.524045e-02
    ## symmetry_worst           0.022790444  4.920481e-03  1.340423e-02
    ## fractal_dimension_worst  0.059985998 -2.356214e-02  1.147766e-02
    ##                                  PC30
    ## radius_mean              0.7024140910
    ## texture_mean             0.0002736610
    ## perimeter_mean          -0.6898969685
    ## area_mean               -0.0329473482
    ## smoothness_mean         -0.0048474577
    ## compactness_mean         0.0446741863
    ## concavity_mean           0.0251386661
    ## concave.points_mean     -0.0010772653
    ## symmetry_mean           -0.0012803794
    ## fractal_dimension_mean  -0.0047556848
    ## radius_se               -0.0087110937
    ## texture_se              -0.0010710392
    ## perimeter_se             0.0137293906
    ## area_se                  0.0011053260
    ## smoothness_se           -0.0016082109
    ## compactness_se           0.0019156224
    ## concavity_se            -0.0089265265
    ## concave.points_se       -0.0021601973
    ## symmetry_se              0.0003293898
    ## fractal_dimension_se     0.0017989568
    ## radius_worst            -0.1356430561
    ## texture_worst            0.0010205360
    ## perimeter_worst          0.0797438536
    ## area_worst               0.0397422838
    ## smoothness_worst         0.0045832773
    ## compactness_worst       -0.0128415624
    ## concavity_worst          0.0004021392
    ## concave.points_worst    -0.0022884418
    ## symmetry_worst           0.0003954435
    ## fractal_dimension_worst  0.0018942925

``` r
summary(wiscpr)  # summarize them shits
```

    ## Importance of components:
    ##                           PC1    PC2     PC3     PC4     PC5     PC6
    ## Standard deviation     3.6444 2.3857 1.67867 1.40735 1.28403 1.09880
    ## Proportion of Variance 0.4427 0.1897 0.09393 0.06602 0.05496 0.04025
    ## Cumulative Proportion  0.4427 0.6324 0.72636 0.79239 0.84734 0.88759
    ##                            PC7     PC8    PC9    PC10   PC11    PC12
    ## Standard deviation     0.82172 0.69037 0.6457 0.59219 0.5421 0.51104
    ## Proportion of Variance 0.02251 0.01589 0.0139 0.01169 0.0098 0.00871
    ## Cumulative Proportion  0.91010 0.92598 0.9399 0.95157 0.9614 0.97007
    ##                           PC13    PC14    PC15    PC16    PC17    PC18
    ## Standard deviation     0.49128 0.39624 0.30681 0.28260 0.24372 0.22939
    ## Proportion of Variance 0.00805 0.00523 0.00314 0.00266 0.00198 0.00175
    ## Cumulative Proportion  0.97812 0.98335 0.98649 0.98915 0.99113 0.99288
    ##                           PC19    PC20   PC21    PC22    PC23   PC24
    ## Standard deviation     0.22244 0.17652 0.1731 0.16565 0.15602 0.1344
    ## Proportion of Variance 0.00165 0.00104 0.0010 0.00091 0.00081 0.0006
    ## Cumulative Proportion  0.99453 0.99557 0.9966 0.99749 0.99830 0.9989
    ##                           PC25    PC26    PC27    PC28    PC29    PC30
    ## Standard deviation     0.12442 0.09043 0.08307 0.03987 0.02736 0.01153
    ## Proportion of Variance 0.00052 0.00027 0.00023 0.00005 0.00002 0.00000
    ## Cumulative Proportion  0.99942 0.99969 0.99992 0.99997 1.00000 1.00000

Plot the data
-------------

### Biplot

Very information intense! Hard to interpret!

``` r
biplot(wiscpr)
```

![](BGGN213_Lecture9_files/figure-markdown_github/unnamed-chunk-8-1.png)

### Base R

This is similar to what we used before.

``` r
plot(wiscpr$x[,1], wiscpr$x[,2], col = diagnosis, pch=16,
     xlab=paste0("PC1 (", ((wiscpr$sdev^2)*100)[1]/sum((wiscpr$sdev)^2), "%)"),
     ylab=paste0("PC2 (",((wiscpr$sdev^2)*100)[2]/sum((wiscpr$sdev)^2), "%)"))
```

![](BGGN213_Lecture9_files/figure-markdown_github/unnamed-chunk-9-1.png)

``` r
# Note that we use the "diagnosis" vector we created earlier
# Also note that we pull out the varience explained by the following:
# ((wiscpr$sdev^2)*100)[1]/sum((wiscpr$sdev)^2, where the [1] indicates teh first PC
```

What about the other PCs? PC3 explained similar varience as PC2.

``` r
plot(wiscpr$x[,1], wiscpr$x[,3], col = diagnosis, pch=16,
     xlab=paste0("PC1 (", ((wiscpr$sdev^2)*100)[1]/sum((wiscpr$sdev)^2), "%)"),
     ylab=paste0("PC2 (",((wiscpr$sdev^2)*100)[3]/sum((wiscpr$sdev)^2), "%)"))
```

![](BGGN213_Lecture9_files/figure-markdown_github/unnamed-chunk-10-1.png)

These look a bit same-y, but the cut between the two groups isn;t as clean - it's better to use the PC1 and PC2 model, to predict if new data would indicate benign or malignant tissue biopsies.

Thinking about Varience (Scree Plots)
-------------------------------------

Let's look at how much varience each of our PCs explain graphically (with scree plots!)

``` r
# Makes a varience vector
prvar <- ((wiscpr$sdev^2)*100)
```

``` r
# Makes a percent varience explained vector
pve <- (prvar/sum((wiscpr$sdev)^2))
```

### Base R

Let's make one with our big garrish calc.

``` r
hist(((wiscpr$sdev^2)*100)/sum((wiscpr$sdev)^2), breaks = 100)
```

![](BGGN213_Lecture9_files/figure-markdown_github/unnamed-chunk-13-1.png)

### Also Base R

Now let's try with our pretty vectors.

``` r
plot(pve, xlab = "Principal Component", # Uses our PVE vector generated above
     ylab = "Proportion of Variance Explained (%)", 
     ylim = c(0, 100), type = "o") # Makes a dot and line chart with type = "o"
```

![](BGGN213_Lecture9_files/figure-markdown_github/unnamed-chunk-14-1.png)

### More streamlined base R

``` r
# Alternative scree plot of the same data, note data driven y-axis
barplot(pve, ylab = "Precent of Variance Explained",
     names.arg=paste0("PC",1:length(pve)), las=2, axes = FALSE)
axis(2, at=pve, labels=round(pve,2)*100 )
```

![](BGGN213_Lecture9_files/figure-markdown_github/unnamed-chunk-15-1.png)

### GGplot using factoextra!

``` r
# ggplot based graph
#install.packages("factoextra") # comment out install.packages() after we install them
library(factoextra)
```

    ## Loading required package: ggplot2

    ## Registered S3 methods overwritten by 'ggplot2':
    ##   method         from 
    ##   [.quosures     rlang
    ##   c.quosures     rlang
    ##   print.quosures rlang

    ## Welcome! Related Books: `Practical Guide To Cluster Analysis in R` at https://goo.gl/13EFCZ

``` r
fviz_eig(wiscpr, addlabels = TRUE)
```

![](BGGN213_Lecture9_files/figure-markdown_github/unnamed-chunk-16-1.png)

Slick, AF, my friends - slick AF. factoextra is kind of a beast when it comes to scree plots.

Check out the laoding factors of PCs
------------------------------------

We can tell the contribution of a given variable by determining how much it contributes to the PC - we do this by check the loading factor.

``` r
# rotatiom is the loading factor, 1 is the PC id
wiscpr$rotation["radius_mean",1] 
```

    ## [1] -0.2189024

``` r
wiscpr$rotation["smoothness_se",1]
```

    ## [1] -0.01453145

How can we look for the loading factor that contributes the MOST to PC1? Recall larger loading factor means a greater contribution!

For example, this would translate to:ß PC1 score = (variable 1 value X loading factor of variable 1(PC1)) + (variable 2 value X loading factor of variable 2(PC1)) + ... + (variable n value \* loading factor of variable n(PC1))

``` r
sort(   # sorts the data
  abs(  # give the absolute value 
    wiscpr$rotation[,1]))  # for the first PC in wiscpr
```

    ##           smoothness_se              texture_se             symmetry_se 
    ##              0.01453145              0.01742803              0.04249842 
    ##  fractal_dimension_mean    fractal_dimension_se            texture_mean 
    ##              0.06436335              0.10256832              0.10372458 
    ##           texture_worst          symmetry_worst        smoothness_worst 
    ##              0.10446933              0.12290456              0.12795256 
    ## fractal_dimension_worst           symmetry_mean         smoothness_mean 
    ##              0.13178394              0.13816696              0.14258969 
    ##            concavity_se          compactness_se       concave.points_se 
    ##              0.15358979              0.17039345              0.18341740 
    ##                 area_se               radius_se       compactness_worst 
    ##              0.20286964              0.20597878              0.21009588 
    ##            perimeter_se             radius_mean               area_mean 
    ##              0.21132592              0.21890244              0.22099499 
    ##              area_worst          perimeter_mean            radius_worst 
    ##              0.22487053              0.22753729              0.22799663 
    ##         concavity_worst         perimeter_worst        compactness_mean 
    ##              0.22876753              0.23663968              0.23928535 
    ##    concave.points_worst          concavity_mean     concave.points_mean 
    ##              0.25088597              0.25840048              0.26085376

Hierarchical Clustering
=======================

Data preparation
----------------

As we did with the prcomp function, we need to construct a scaled data set. We can use scale(), which scales and centers matrix \[and matrix-like\] objects.

``` r
datascaled <- scale(wiscdat) # scale our matrix data
```

Next, we will calculate the Euclidean distance between our data poits

``` r
distdata <- dist(datascaled, method = "euclidean") 
```

Aside: Let's try again with factorextra's dist() function

``` r
fviz_dist(distdata, order = TRUE, show_labels = TRUE, lab_size = NULL,
  gradient = list(low = "red", mid = "white", high = "blue"))
```

![](BGGN213_Lecture9_files/figure-markdown_github/unnamed-chunk-21-1.png)

``` r
#oly Geeze this is computationally itensive, comparatively!
```

### Do cluster analysis using "complete" linkage

``` r
wisc.hclust <- hclust(distdata, method = "complete")
```

``` r
plot(wisc.hclust)
abline(h=19, col = "red")
```

![](BGGN213_Lecture9_files/figure-markdown_github/unnamed-chunk-23-1.png)

CLuster our data into four groups using cutree:

``` r
wisc.hclust.clusters <- cutree(wisc.hclust, k = 4)
table(wisc.hclust.clusters, diagnosis)
```

    ##                     diagnosis
    ## wisc.hclust.clusters   B   M
    ##                    1  12 165
    ##                    2   2   5
    ##                    3 343  40
    ##                    4   0   2

Combine clustering with PCA
---------------------------

``` r
wisc.pr.hclust <- hclust(dist(wiscpr$x[,1:7]), method = "ward.D2")  
# ook more into the methods - I;m not sure why to use Ward D2 here.
# Here, we'll use PCs 1 through 7 because they explain ~ 90% of varience; this isn't always the right option, though.
plot(wisc.pr.hclust)
```

![](BGGN213_Lecture9_files/figure-markdown_github/unnamed-chunk-25-1.png)

``` r
grps <- cutree(wisc.pr.hclust, k=2)
table(grps)
```

    ## grps
    ##   1   2 
    ## 216 353

``` r
table(grps, diagnosis)
```

    ##     diagnosis
    ## grps   B   M
    ##    1  28 188
    ##    2 329  24

``` r
plot(wiscpr$x[,1:2], col=grps)
```

![](BGGN213_Lecture9_files/figure-markdown_github/unnamed-chunk-27-1.png)

THe col= input changes the ordering of the coloration, but the groups derived from the PCA seem to distinguish the B and M patients well (see below as reference).

``` r
plot(wiscpr$x[,1:2], col=diagnosis)
```

![](BGGN213_Lecture9_files/figure-markdown_github/unnamed-chunk-28-1.png)

### Pretty 3D PCA plot for fun

Here is the code, although I can't load it because my R version is too new.

``` r
#install.packages("rgl")
#install.packages("XQuartz")
#library(rgl)
#plot3d(wisc.pr$x[,1:3], xlab="PC 1", ylab="PC 2", zlab="PC 3", cex=1.5, size=1, type="s", col=grps)
```

Predicting diagnosis with PCA
-----------------------------

We can use our PCA model to predict the diagnosis of new samples. Let's try with new sample input:

``` r
#url <- "new_samples.csv"
url <- "https://tinyurl.com/new-samples-CSV"
new <- read.csv(url)
npc <- predict(wiscpr, newdata=new)
npc
```

    ##            PC1       PC2        PC3        PC4       PC5        PC6
    ## [1,]  2.576616 -3.135913  1.3990492 -0.7631950  2.781648 -0.8150185
    ## [2,] -4.754928 -3.009033 -0.1660946 -0.6052952 -1.140698 -1.2189945
    ##             PC7        PC8       PC9       PC10      PC11      PC12
    ## [1,] -0.3959098 -0.2307350 0.1029569 -0.9272861 0.3411457  0.375921
    ## [2,]  0.8193031 -0.3307423 0.5281896 -0.4855301 0.7173233 -1.185917
    ##           PC13     PC14      PC15       PC16        PC17        PC18
    ## [1,] 0.1610764 1.187882 0.3216974 -0.1743616 -0.07875393 -0.11207028
    ## [2,] 0.5893856 0.303029 0.1299153  0.1448061 -0.40509706  0.06565549
    ##             PC19       PC20       PC21       PC22       PC23       PC24
    ## [1,] -0.08802955 -0.2495216  0.1228233 0.09358453 0.08347651  0.1223396
    ## [2,]  0.25591230 -0.4289500 -0.1224776 0.01732146 0.06316631 -0.2338618
    ##             PC25         PC26         PC27        PC28         PC29
    ## [1,]  0.02124121  0.078884581  0.220199544 -0.02946023 -0.015620933
    ## [2,] -0.20755948 -0.009833238 -0.001134152  0.09638361  0.002795349
    ##              PC30
    ## [1,]  0.005269029
    ## [2,] -0.019015820

``` r
plot(wiscpr$x[,1:2], col=diagnosis)
points(npc[,1], npc[,2], col="blue", pch=16, cex=3) # Plot our two new patients 
text(npc[,1], npc[,2], c(1,2), col="white")
```

![](BGGN213_Lecture9_files/figure-markdown_github/unnamed-chunk-31-1.png) From this, we can see that patient 2 appears to have a biopsy indicating malignancy! She should be considered for treatment!

Thanks PCA!!

Session Deets
=============

``` r
sessionInfo()
```

    ## R version 3.6.0 (2019-04-26)
    ## Platform: x86_64-apple-darwin15.6.0 (64-bit)
    ## Running under: macOS Mojave 10.14.5
    ## 
    ## Matrix products: default
    ## BLAS:   /Library/Frameworks/R.framework/Versions/3.6/Resources/lib/libRblas.0.dylib
    ## LAPACK: /Library/Frameworks/R.framework/Versions/3.6/Resources/lib/libRlapack.dylib
    ## 
    ## locale:
    ## [1] en_US.UTF-8/en_US.UTF-8/en_US.UTF-8/C/en_US.UTF-8/en_US.UTF-8
    ## 
    ## attached base packages:
    ## [1] stats     graphics  grDevices utils     datasets  methods   base     
    ## 
    ## other attached packages:
    ## [1] factoextra_1.0.5 ggplot2_3.1.1   
    ## 
    ## loaded via a namespace (and not attached):
    ##  [1] Rcpp_1.0.1       ggpubr_0.2       knitr_1.22       magrittr_1.5    
    ##  [5] tidyselect_0.2.5 munsell_0.5.0    colorspace_1.4-1 R6_2.4.0        
    ##  [9] rlang_0.3.4      stringr_1.4.0    plyr_1.8.4       dplyr_0.8.1     
    ## [13] tools_3.6.0      grid_3.6.0       gtable_0.3.0     xfun_0.6        
    ## [17] withr_2.1.2      htmltools_0.3.6  assertthat_0.2.1 yaml_2.2.0      
    ## [21] lazyeval_0.2.2   digest_0.6.18    tibble_2.1.1     crayon_1.3.4    
    ## [25] reshape2_1.4.3   purrr_0.3.2      ggrepel_0.8.1    glue_1.3.1      
    ## [29] evaluate_0.13    rmarkdown_1.12   labeling_0.3     stringi_1.4.3   
    ## [33] compiler_3.6.0   pillar_1.3.1     scales_1.0.0     pkgconfig_2.0.2
