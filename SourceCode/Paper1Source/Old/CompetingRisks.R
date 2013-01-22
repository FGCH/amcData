#################
# Clustered competing risks regression
# Christopher Gandrud
# 21 January 2013
#################


library(cmprsk)
library(crrSC)

# Depends on: 
# devtools::source_url("https://raw.github.com/christophergandrud/amcData/master/SourceCode/Paper1Source/LoadRPackages.R")
# devtools::source_url("https://raw.github.com/christophergandrud/amcData/master/SourceCode/Paper1Source/PaperDataLoadClean.R")


# Create fstatus variable from AMCType
## 1 = No AMC
## 2 = Centralised AMC
## 3 = Decentralised AMC

AMCLag$AMCStatus <- 1
AMCLag$AMCStatus[AMCLag$AMCType == "Centralised"] <-2
AMCLag$AMCStatus[AMCLag$AMCType == "Decentralised"] <-3
AMCLag$AMCStatus[AMCLag$year == 2012 & AMCLag$NumAMCCountryNoNA == 0] <- 4

AMCShort1 <- subset(AMCLag, AMCAnyCreated == 1)

AMCShort2 <- subset(AMCLag, AMCStatus == 4)

AMCShort <- rbind(AMCShort1, AMCShort2)

# Stratified competing risks model
attach(AMCShort)
M1 <- crrc(ftime = year - 1980,
           fstatus = AMCStatus,
           cov1 = cbind(govfrac, SystemicCrisisLag3, UDS),
           failcode = 3,
           cencode = 4,
           cluster = country)
detach(AMCShort)
print(M1)
      
attach(AMCLag)
M2 <- cuminc(ftime = (year - 1979),
             fstatus = AMCStatus,
             strata = country)
      
detach(AMCLag)
print(M2)


############## Try to figure out how to similuate using normal dist. Main issue: CIF for Strata #######


M1Predict <- predict(M1, c(-5, 0, 5, 10))
plot.cuminc(M1)