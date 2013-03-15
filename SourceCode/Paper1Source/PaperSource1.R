#############
# AMC Paper: Data Load and Clean
# Christopher Gandrud
# 16 February 2013
#############

library(repmis)
library(plyr)
library(foreign)
library(RCurl)

# Load most recent data
AMC <- source_GitHubData("https://raw.github.com/christophergandrud/amcData/master/MainData/amcCountryYear.csv")


#### Create lagged crisis variable (Crisis onset year +2) ####
# Create individual year lags
AMCLag <- ddply(AMC, .(country), transform, SCL1 = c(NA, SystemicCrisis[-length(SystemicCrisis)]))
AMCLag <- ddply(AMCLag, .(country), transform, SCL2 = c(NA, SCL1[-length(SCL1)]))

# Create combined lagged variable
AMCLag$SystemicCrisisLag3 <- AMCLag$SystemicCrisis + AMCLag$SCL1 + AMCLag$SCL2


# Remove old lag variables
AMCLag$SCL1 <- AMCLag$SCL2 <- NULL

#### Create lagged crisis variable (Crisis onset year +5) ####
# Create individual year lags
AMCLag <- ddply(AMCLag, .(country), transform, SCL1 = c(NA, SystemicCrisis[-length(SystemicCrisis)]))
AMCLag <- ddply(AMCLag, .(country), transform, SCL2 = c(NA, SCL1[-length(SCL1)]))
AMCLag <- ddply(AMCLag, .(country), transform, SCL3 = c(NA, SCL1[-length(SCL2)]))
AMCLag <- ddply(AMCLag, .(country), transform, SCL4 = c(NA, SCL1[-length(SCL3)]))

# Create combined lagged variable
AMCLag$SystemicCrisisLag5 <- AMCLag$SystemicCrisis + AMCLag$SCL1 + AMCLag$SCL2 + AMCLag$SCL3 + AMCLag$SCL4

# Recode 1 
AMCLag$SystemicCrisisLag5[AMCLag$SystemicCrisisLag5 >= 1] <- 1

# Remove old lag variables
AMCLag$SCL1 <- AMCLag$SCL2 <- AMCLag$SCL3 <- AMCLag$SCL4 <- AMCLag$SCL5 <- NULL

#### Create lagged IMF StandBy variable (IMF onset year +2) ####
# Create individual year lags
AMCLag <- ddply(AMCLag, .(country), transform, IMFL1 = c(NA, IMFDreher[-length(IMFDreher)]))
AMCLag <- ddply(AMCLag, .(country), transform, IMFL2 = c(NA, IMFL1[-length(IMFL1)]))

# Create combined lagged variable
attach(AMCLag)
AMCLag$IMFDreherLag3 <- IMFDreher + IMFL1 + IMFL2
detach(AMCLag)

# Recode 1
AMCLag$IMFDreherLag3[AMCLag$IMFDreherLag3 >= 1] <- 1

# Remove old lag variables
AMCLag$IMFL1 <- AMCLag$IMFL2 <- NULL

#### Create lagged IMF Credits Variable (Simmons et al. 2006) ####
# Create dummy variable assume missing is 0 (assumes sample is exhaustive through 2011)
AMCLag$IMFCreditsDummy <- 0
AMCLag$IMFCreditsDummy[AMCLag$year >= 2012] <- NA
AMCLag$IMFCreditsDummy[AMCLag$IMFCredits >= 1] <- 1

# Create individual year lags
AMCLag <- ddply(AMCLag, .(country), transform, IMFCL1 = c(NA, IMFCreditsDummy[-length(IMFCreditsDummy)]))
AMCLag <- ddply(AMCLag, .(country), transform, IMFCL2 = c(NA, IMFCL1[-length(IMFCL1)]))

# Create combined lagged variable
attach(AMCLag)
AMCLag$IMFCreditsDummyLag3 <- IMFCreditsDummy + IMFCL1 + IMFCL2
detach(AMCLag)

# Recode
AMCLag$IMFCreditsDummyLag3[AMCLag$IMFCreditsDummyLag3 >= 1] <- 1

# Remove old lag variables
AMCLag$IMFCL1 <- AMCLag$IMFCL2 <- NULL

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

## Save to .RData ##
save(FirstYearNotNa, file = "~/Dropbox/AMCPaper1/TempData/FirstYearNotNa.RData")

#### Create State Variable
# Create fstatus variable from AMCType
## 0 = No AMC
## 1 = Centralised AMC
## 2 = Decentralised AMC

AMCLag$AMCStatus <- 0
AMCLag$AMCStatus[AMCLag$AMCType == "Centralised"] <- 1
AMCLag$AMCStatus[AMCLag$AMCType == "Decentralised"] <- 2

#### Save ####
save(AMCLag, file = "~/Dropbox/AMCPaper1/TempData/AMCMainData.RData")
