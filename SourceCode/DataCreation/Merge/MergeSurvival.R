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
wdi <- read.csv("WDIData.csv")

# Remove missing id variables
lv <- lv[!is.na(lv$imfcode), ]
uds <- uds[!is.na(uds$imfcode), ]
dpi <- dpi[!is.na(dpi$imfcode), ]
wdi <- wdi[!is.na(wdi$imfcode), ]

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

lv <- rbind(lv, TempYear1, TempYear2, TempYear3, TempYear4)

# Merge with UDS
amcCountryYear <- merge(lv, uds, union("imfcode", "year"), all = TRUE)
  amcCountryYear <- remove.vars(amcCountryYear, names = "country.x")
  amcCountryYear <- rename(amcCountryYear, c(country.y = "country"))

# Merge with DPI
amcCountryYear <- merge(amcCountryYear, dpi, union("imfcode", "year"), all = TRUE)
  amcCountryYear <- remove.vars(amcCountryYear, names = "country.y")
  amcCountryYear <- rename(amcCountryYear, c(country.x = "country"))

# Merge with AMC Start Year
amc <- rename(amc, c(AMCStartYear = "year"))
amcCountryYear <- merge(amcCountryYear, amc, union("imfcode", "year"), all = TRUE)
  amcCountryYear <- remove.vars(amcCountryYear, names = "country.y")
  amcCountryYear <- rename(amcCountryYear, c(country.x = "country"))

# Merge with WDI Data
amcCountryYear <- merge(amcCountryYear, wdi, union("imfcode", "year"), all = TRUE)

# Clean up merge
amcCountryYear <- amcCountryYear[amcCountryYear$year >= 1980, ]
amcCountryYear <- amcCountryYear[!is.na(amcCountryYear$year), ]

amcCountryYear$AMCDummy[is.na(amcCountryYear$AMCDummy)] <- 0
amcCountryYear <- amcCountryYear[!duplicated(amcCountryYear[, 1:2], fromLast=FALSE), ]

write.table(amcCrisisYear, file = "/git_repositories/amcData/MainData/amcCountryYear.csv", sep = ",")





