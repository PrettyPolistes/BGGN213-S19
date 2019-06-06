rm(list = ls()) # Clear dataspace before I begin

cute <- read.csv("Testdata.csv")
colnames(cute) <- tolower(colnames(cute))
summary(cute)

hist(cute$size_g, xlab="Animal Type", ylab = "Size (g)")
plot(cute$animal, cute$cuteness, 
      xlab="Animal Type", 
     ylab="Cuteness Metric", 
     col=c("blue", "green", "yellow", "orange"))
parrotplus <- data.frame(animal = c("Parrot", "Parrot", "Parrot"), 
                         size_g = c(1247, 1301,1200), 
                         cuteness= c(8, 9, 10),
                         feedreq = c("Much", "Much","Much"))
                    
cute2 <- rbind(cute,parrotplus)
plot(cute2$animal, cute2$cuteness, 
     xlab="Animal Type", 
     ylab="Cuteness Metric", 
     col=c("blue", "green", "yellow", "orange", "red"))

library(ggplot2)
ggplot(cute2, aes(animal, cuteness, feedreq, label = animal)) +
         geom_bar(aes(fill=animal), color="blue", position=position_dodge2(), stat = "identity") +
         scale_fill_manual(name = "Animal Type", 
                           labels= c("Cat", "Fish", "Lizard", "Tarantula", "Parrot"),
                           values=c("palegreen", "lightskyblue", "mediumpurple", "pink", "orange")) +
         facet_wrap(~feedreq) +
        theme_classic()
       
rm(list = ls()) # Clear dataspace after I'm finished

### Lecture 5
# Visualization

set.seed(53)
x <- rnorm(1000, mean = 33.5, sd = 2.5)
y <- rnorm(1000, mean = 5.2, sd = 0.2)
plot(x,y)

# How rnorm works
length(y)  # equals 1000
mean(y) # Equals 5.2
sd(y) # equals 0.2

summary(x)
hist(x)
rug(x) # Shows sample density along X axis
rm(list = ls()) 


################################
### Graphics with Dr. Grant
# load the txt zip from BGGN213 GIT, lecture 5
# check WD with getwd()
weight <- read.table("weight_chart.txt", header = T)
# With text files, it assumes no header; make sure to tell R you have one.


# Let's plot silly stuff!
plot(weight$Age ~ weight$Weight, 
     type = "o", xlab="Age (months)", 
     ylab="Weight (kg)", 
     main="Baby Weight") 

# With triangle dot points (using pch=)
plot(weight$Age ~ weight$Weight, type = "o", 
     xlab="Age (months)", 
     ylab="Weight (kg)",
     main="Baby Weight", 
     pch = 2) 

# With dots 5x normal size
plot(weight$Age ~ weight$Weight,  
     type = "o",  xlab="Age (months)", 
     ylab="Weight (kg)", 
     main="Baby Weight",
     cex = 5) 

# Make line double thickness
plot(weight$Age ~ weight$Weigh,  
     type = "o", 
     xlab="Age (months)", 
     ylab="Weight (kg)", 
     main="Baby Weight",
     lwd = 2) 

# With y range between 2 and 10kg
plot(weight$Age ~ weight$Weight, 
     type = "o", 
     xlab="Age (months)", 
     ylab="Weight (kg)", 
     main="Baby Weight",
     ylim=c(2,10)) 

# Everything
plot(weight$Age ~ weight$Weight, 
     type = "o", 
     xlab="Age (months)", 
     ylab="Weight (kg)", 
     main="Baby Weight",
     pch = 2,
     lwd = 2,
     cex = 5,
     ylim=c(0,10)) 
plot(weight, 
     type = "o", 
     xlab="Age (months)", 
     ylab="Weight (kg)", 
     main="Baby Weight",
     pch = 17,
     lwd = 2,
     cex = 5,
     ylim=c(2,10)) 


########################
## Bar plots
# Use feature_counts.txt 
# Edit .txt file to be readable (or just never put freaking spaces in variable names)
feat <- read.table("feature_counts.txt", header = T, sep = "\t") # use "\t" for tab-separated
names(feat) <- tolower(names(feat))
summary(feat)

barplot(feat$count, names.arg = feat$feature, las=2, cex.names = 0.8)
par(mar=c(7, 10, 5, 5))  # Affects margins of figure - Bottom, left, top, right
# par() is super useful to make graphial arguments in base R
barplot(feat$count, 
        horiz = T, 
        xlim=c(0,80000),
        xlab = "Gene Count", 
        main = "Number of features", 
        names.arg = feat$feature, 
        las=2, 
        cex.names = 0.8)

#########################
## Histograms with random distributions
# Use rnorm() to define a random normally distributed draw of numbers
set.seed(53)
var <- c(rnorm(10000), rnorm(10000)+4)
hist(var)
# breaks = within hist() set the numebr of bins desired for viualization
hist(var, breaks = 10) # Some
hist(var, breaks = 100) # Many
hist(var, breaks = 1000) # MANY MANY


##########################
# Use rainbow()
mf <- read.table("male_female_counts.txt", header=T, sep = "\t")
barplot(mf$Count, col = (rainbow(10)))
par(mar=c(7, 5, 5, 5))
# Plot with rainbow colors
barplot(mf$Count, col = (rainbow(10)), 
        names.arg = mf$Sample, 
        las = 2,
        ylim = c(0,20),
        ylab = "Count")
# Plot with topographic colors
barplot(mf$Count, col = (topo.colors(10)), 
        names.arg = mf$Sample, 
        las = 2,
        ylim = c(0,20),
        ylab = "Count")


############################
# Plot by weight

genes <- read.table("up_down_expression.txt", header=T, sep="\t")
names(genes) <- tolower(names(genes))
table(genes$state)
plot(genes$condition1, genes$condition2, col=genes$state, xlab = "Condition 1", ylab="Condition 2")

palette(c("gold", "chartreuse2", "deepskyblue"))
plot(genes$condition1, genes$condition2, col=genes$state, xlab = "Condition 1", ylab="Condition 2")
# Check out all the R colors on the internets

############################
# Plot by density

exm <- read.table("expression_methylation.txt", header=T, sep="\t")

plot(exm$gene.meth, exm$expression, 
     col = densCols(exm$gene.meth, exm$expression), # Plot by density
     pch=20)
# Subset into data where expression is greater than 0
exm0 <- exm$expression > 0 
plot(exm$gene.meth[exm0], exm$expression[exm0], 
     col = densCols(exm$gene.meth[exm0], exm$expression[exm0]), # Plot by density
     pch=20)


dcols.custom <- densCols(exm$gene.meth[exm0], exm$expression[exm0],
                         colramp = colorRampPalette(c("darkolivegreen4",
                                                      "yellowgreen",
                                                      "yellow",
                                                      "gold")) )
plot(exm$gene.meth[exm0], exm$expression[exm0], 
     col = dcols.custom, # Plot by density
     pch=20)
