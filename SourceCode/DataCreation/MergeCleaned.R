############ 
# Merge Cleaned Up AMC Database Data
# Christopher Gandrud
# Updated 17 July 2012
############

## ID variable is imfcode

setwd("/git_repositories/amcData/MainData/CleanedPartial/")

# Load data
lv <- read.csv("LvData.csv") 
dpi <- read.csv("DpiData.csv")

amcData <- merge(lv, dpi, union("imfcode", "year"))

write.table(amcData, file = "/git_repositories/amcData/MainData/amcData.csv", sep = ",")