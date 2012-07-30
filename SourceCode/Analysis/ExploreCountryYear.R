######### 
# Exploritory AMC Analysis with amcCountryYear dataset
# Christopher Gandrud
# Updated 30 July 2012
#########

# Load required packages
library(RCurl)
library(ggplot2)
library(Zelig)

# Load data from the GitHub site
url <- "https://raw.github.com/christophergandrud/amcData/master/MainData/amcCountryYear.csv"
mainCountry <- getURL(url)
mainCountry <- read.csv(textConnection(mainCountry))

M1 <- zelig(AMCDummy ~ govfrac, model = "logit.bayes", data = mainCountry, robust = "weave", order.by = ~year)

M2 <- zelig(AMCDummy ~ IMFProgram, model = "logit.bayes", data = mainCountry, robust = "weave", order.by = ~year)

M3 <- zelig(AMCDummy ~ UDS, model = "logit.bayes", data = mainCountry, robust = "weave", order.by = ~year)