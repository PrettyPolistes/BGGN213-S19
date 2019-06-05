Lecture12 - StructBioInf - Pt2
================
ACGeffre
5/10/2019

Structural Bioinformatics - Part 2
==================================

Obtaining/preparing a protein sequence for docking analysis.
------------------------------------------------------------

### 1. Use Bio3D to draw the pdb files for HIV protease HSD1.

``` r
hivpdb <- get.pdb("1hsg")
```

    ## Warning in get.pdb("1hsg"): ./1hsg.pdb exists. Skipping download

``` r
# Next use the read.pdb()function to read this PDB file into R so we can prepare it for further analysis.
hiv <- read.pdb(hivpdb)
hiv
```

    ## 
    ##  Call:  read.pdb(file = hivpdb)
    ## 
    ##    Total Models#: 1
    ##      Total Atoms#: 1686,  XYZs#: 5058  Chains#: 2  (values: A B)
    ## 
    ##      Protein Atoms#: 1514  (residues/Calpha atoms#: 198)
    ##      Nucleic acid Atoms#: 0  (residues/phosphate atoms#: 0)
    ## 
    ##      Non-protein/nucleic Atoms#: 172  (residues: 128)
    ##      Non-protein/nucleic resid values: [ HOH (127), MK1 (1) ]
    ## 
    ##    Protein sequence:
    ##       PQITLWQRPLVTIKIGGQLKEALLDTGADDTVLEEMSLPGRWKPKMIGGIGGFIKVRQYD
    ##       QILIEICGHKAIGTVLVGPTPVNIIGRNLLTQIGCTLNFPQITLWQRPLVTIKIGGQLKE
    ##       ALLDTGADDTVLEEMSLPGRWKPKMIGGIGGFIKVRQYDQILIEICGHKAIGTVLVGPTP
    ##       VNIIGRNLLTQIGCTLNF
    ## 
    ## + attr: atom, xyz, seqres, helix, sheet,
    ##         calpha, remark, call

#### Question 1:

What is the name of the two non protein resid values in this structure? What does resid correspond to and how would you get a listing of all reside values in this structure?

-   Resid corresponds to the R groups on the moelcule
-   The two non-protein residuals are H2O, and MK1.
-   We can get a complete list of all the residuals by using the following command:

``` r
View(hiv$atom$resid)
```

### 2. Prepare the file for analysis by trimming out specific things

``` r
prot <- atom.select(hiv, "protein", value = TRUE)
prot
```

    ## 
    ##  Call:  trim.pdb(pdb = pdb, sele)
    ## 
    ##    Total Models#: 1
    ##      Total Atoms#: 1514,  XYZs#: 4542  Chains#: 2  (values: A B)
    ## 
    ##      Protein Atoms#: 1514  (residues/Calpha atoms#: 198)
    ##      Nucleic acid Atoms#: 0  (residues/phosphate atoms#: 0)
    ## 
    ##      Non-protein/nucleic Atoms#: 0  (residues: 0)
    ##      Non-protein/nucleic resid values: [ none ]
    ## 
    ##    Protein sequence:
    ##       PQITLWQRPLVTIKIGGQLKEALLDTGADDTVLEEMSLPGRWKPKMIGGIGGFIKVRQYD
    ##       QILIEICGHKAIGTVLVGPTPVNIIGRNLLTQIGCTLNFPQITLWQRPLVTIKIGGQLKE
    ##       ALLDTGADDTVLEEMSLPGRWKPKMIGGIGGFIKVRQYDQILIEICGHKAIGTVLVGPTP
    ##       VNIIGRNLLTQIGCTLNF
    ## 
    ## + attr: atom, helix, sheet, seqres, xyz,
    ##         calpha, call

``` r
lig <- atom.select(hiv, "ligand", value = T)
lig
```

    ## 
    ##  Call:  trim.pdb(pdb = pdb, sele)
    ## 
    ##    Total Models#: 1
    ##      Total Atoms#: 45,  XYZs#: 135  Chains#: 1  (values: B)
    ## 
    ##      Protein Atoms#: 0  (residues/Calpha atoms#: 0)
    ##      Nucleic acid Atoms#: 0  (residues/phosphate atoms#: 0)
    ## 
    ##      Non-protein/nucleic Atoms#: 45  (residues: 1)
    ##      Non-protein/nucleic resid values: [ MK1 (1) ]
    ## 
    ## + attr: atom, helix, sheet, seqres, xyz,
    ##         calpha, call

``` r
write.pdb(prot, file="1hsg_protein.pdb")
write.pdb(lig, file="1hsg_ligand.pdb")
```

### 3. Add charges, hydrogens, etc for ADT

(Done in ADT)

### 4. Use AutoDock Vina

``` r
res <- read.pdb("all.pdbqt", multi=TRUE)
write.pdb(res, "results.pdb")
```

### Compare structure

``` r
res <- read.pdb("all.pdbqt", multi=TRUE) 
  # multi = T because this file has 14 different configuration models
ori <- read.pdb("ligand.pdbqt")
rmsd(ori, res)
```

    ##  [1]  0.697  4.195 11.146 10.606 10.852 10.945 10.945  3.844  5.473  4.092
    ## [11] 10.404  5.574  3.448 11.396  6.126  3.848  8.237 11.196 10.981 11.950

Normal Mode Analysis in Bio3D
-----------------------------

THe above analyses predicts how a ligand fits into a protein but only describes them as static. In reality, molecules are constantly undergoing random motion. Analysis techniques that account for this, Normal mode analysis for example, allows us to predict the flexibility of proteins/molecules and model with that.

``` r
pdb <- read.pdb("1hel")
```

    ##   Note: Accessing on-line PDB file

``` r
modes <- nma( pdb )
```

    ##  Building Hessian...     Done in 0.013 seconds.
    ##  Diagonalizing Hessian...    Done in 0.09 seconds.

``` r
m7 <- mktrj(modes, mode=7, file="mode_7.pdb")
plot(modes)
```

![](Lec12_StructBioinfPt2_files/figure-markdown_github/unnamed-chunk-7-1.png)

``` r
library("bio3d.view")
view(m7, col=vec2color(rmsf(m7)))
```

    ## Potential all C-alpha atom structure(s) detected: Using calpha.connectivity()
