#############
# AMC Paper: Data Load and Clean
# Christopher Gandrud
# 22 January 2013
#############

library(devtools)
library(plyr)
library(foreign)
library(RCurl)

# Load most recent data
URL <- "https://raw.github.com/christophergandrud/amcData/master/MainData/amcCountryYear.csv"
AMC <- getURL(URL)
AMC <- read.csv(textConnection(AMC))

#### Create lagged crisis variable (Crisis onset year -3) ####
# Create individual year lags
AMCLag <- ddply(AMC, .(country), transform, SCL1 = c(NA, SystemicCrisis[-length(SystemicCrisis)]))
AMCLag <- ddply(AMCLag, .(country), transform, SCL2 = c(NA, SCL1[-length(SCL1)]))

# Create combined lagged variable
attach(AMCLag)
AMCLag$SystemicCrisisLag3 <- SystemicCrisis + SCL1 + SCL2
detach(AMCLag)

# Remove old lag variables
AMCLag$SCL1 <- AMCLag$SCL2 <- NULL

#### Create Election Year +1 lag ####
lg <- function(x)c(x[2:(length(x))], NA)
AMCLag <- ddply(AMCLag, .(country), transform, ElectionYear1 = lg(ElectionYear))
AMCLag$ElectionYear1[AMCLag$ElectionYear1 == 2] <- "NoElection"
AMCLag$ElectionYear1[AMCLag$ElectionYear1 == 1] <- "Election"

#### Remove (De)centralised category
AMCLag$AMCType[AMCLag$AMCType == "(De)centralised"] <- "Decentralised"

#### Remove NA in AMC Type & Capture only an AMC's first year ####
AMCLag$AMCType[AMCLag$AMCType == ""] <- NA
NotNaAMCType <- subset(AMCLag, !is.na(AMCType) | AMCType != "None")

NotNaAMCType <- ddply(NotNaAMCType, .(country), transform, NotFirstYear = duplicated(NumAMCOpNoNA))
FirstYearNotNa <- subset(NotNaAMCType, NumAMCOpNoNA != 0 & NotFirstYear == FALSE)

## Save to csv ##
save(FirstYearNotNa, file = "~/Dropbox/AMCPaper1/TempData/FirstYearNotNa.RData")

#### Create State Variable
# Create fstatus variable from AMCType
## 1 = No AMC
## 2 = Centralised AMC
## 3 = Decentralised AMC

AMCLag$AMCStatus <- 1
AMCLag$AMCStatus[AMCLag$AMCType == "Centralised"] <-2
AMCLag$AMCStatus[AMCLag$AMCType == "Decentralised"] <-3

#### Save to Stata dta format ####
write.dta(AMCLag, file = "~/Dropbox/AMCPaper1/TempData/AMCMainData.dta")
