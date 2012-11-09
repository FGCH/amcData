#############
# AMC Data Explore Early November
# Christopher Gandrud
# 9 November 2012
#############

# Load libraries
library(RCurl)
library(ggplot2)
library(MASS)
library(reshape2)

# Load most recent data
URL <- "https://raw.github.com/christophergandrud/amcData/master/MainData/amcCountryYear.csv"
AMC <- getURL(URL)
AMC <- read.csv(textConnection(AMC))

# Load data from disk
AMC <- read.csv()
# remove NA
AMC$AMCType[AMC$AMCType == ""] <- NA
NotNaAMCType <- subset(AMC, !is.na(AMCType) | AMCType != "None")

# Basic graph of AMC types
ggplot(data = NotNaAMCType, aes(AMCType)) +
      geom_bar() +
      theme_bw()

# Created During Crisis & Not




# Create AMC Year Type
## Subset data
First <- NotNaAMCType[, c("country", "year", "F1")]
First <- 
FirstT <- table(First$year, First$F1)
FirstT <- data.frame(FirstT)
