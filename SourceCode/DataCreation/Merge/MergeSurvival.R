############ 
# Merge Cleaned Up AMC Database Data (Repeated Survival Time Version)
# Christopher Gandrud
# Updated 26 July 2012
############

# Load required packages
library(reshape)
library(gdata)

## ID variable is imfcode

setwd("/git_repositories/amcData/MainData/CleanedPartial/")

# Load data
lv <- read.csv("LvData.csv") 
uds <- read.csv("UdsData.csv")
dpi <- read.csv("DpiData.csv")
amc <- read.csv("amcStartData.csv")

# Create Crisis 5 year data (crisis year + 4)
for (i in 1:4){
  temp <- lv$year + i
  assign(paste("TempYear", i, sep = ""), cbind(lv, temp))
}

TempYear1 <- remove.vars(TempYear1, names = "year")
TempYear1 <- rename(TempYear1, c(temp = "year"))  
TempYear2 <- remove.vars(TempYear2, names = "year")
TempYear2 <- rename(TempYear2, c(temp = "year"))
TempYear3 <- remove.vars(TempYear3, names = "year")
TempYear3 <- rename(TempYear3, c(temp = "year"))
TempYear4 <- remove.vars(TempYear4, names = "year")
TempYear4 <- rename(TempYear4, c(temp = "year"))

lv <- rbind(lv, TempYear1, TempYear3, TempYear3, TempYear4)


# Merge with DPI
amcCountryYear <- merge(lv, uds, union("imfcode", "year"), all = TRUE)
for (i in 1:4){
  lv <- remove.vars(lv, names = "year")
  year <- lv[[paste("year", i, sep = "")]]
  lv <- cbind(lv, year)
  amcCountryYear <- merge(lv, amcCountryYear, union("imfcode", "year"), all = TRUE, suffixes = paste("year", i, sep = ""))
  amcCountryYear <- rename(amcCountryYear, c(country.x = "country"))
}







