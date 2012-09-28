######### 
# Exploritory AMC Analysis with amcCountryYear dataset
# Christopher Gandrud
# Updated 28 September 2012
#########

# Load required packages
library(RCurl)
library(ggplot2)
library(Zelig)

# Load data from the GitHub site
url <- "https://raw.github.com/christophergandrud/amcData/master/MainData/amcCountryYear.csv"
MainData <- getURL(url)
MainData <- read.csv(textConnection(MainData))

M1 <- zelig(AMCDummy ~ govfrac, model = "logit.bayes", data = MainData, robust = "weave", order.by = ~year)

M2 <- zelig(AMCDummy ~ IMFDreher + govfrac + GDPperCapita, model = "logit.bayes", data = MainData, robust = "weave")

M3 <- zelig(AMCDummy ~ UDS, model = "logit.bayes", data = MainData, robust = "weave", order.by = ~year)