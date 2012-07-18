######### 
# Exploritory AMC Analysis
# Christopher Gandrud
# Updated 17 July 2012
#########

# Load required packages
library(RCurl)
library(ggplot2)
library(Zelig)

# Load data from the GitHub site
url <- "https://raw.github.com/christophergandrud/amcData/master/MainData/amcData.csv"
main <- getURL(url)
main <- read.csv(textConnection(main))

main$SingleParty[main$govfrac > 0] <- "MultiParty"
main$SingleParty[main$govfrac == 1] <- "SingleParty"


##### Basic Boxplots ####

qplot(AMC, SingleParty, geom = "boxplot", data = main) + theme_bw()

#### Exploratory Models ####

M1 <- zelig(AMC ~ IMFProgram, model = "logit", data = main)

M2 <- zelig(AMC ~ IMFProgram + SingleParty, model = "logit", data = main)

M3 <- zelig(AMC ~ execrlc, model = "logit", data = main)

M4 <- zelig(AMC ~ PeakNPLs, model = "logit", data = main)



