######### 
# Exploritory AMC Analysis
# Christopher Gandrud
# Updated 17 July 2012
#########

# Load required packages
library(RCurl)
library(ggplot2)

# Load data from the GitHub site
url <- "https://raw.github.com/christophergandrud/amcData/master/MainData/amcData.csv"
main <- getURL(url)
main <- read.csv(textConnection(main))

# Basic Boxplots

qplot(AMC, UDS, geom = "boxplot", data = main) + theme_bw()

