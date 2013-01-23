################
# Stratified Cox Regression
# Christopher Gandrud
# 23 January 2013
################

library(foreign)
library(simtvc) # Note need to install with the following code: devtools::install_github("simtvc", "christophergandrud")
library(survival)
library(coxme)

setwd("~/Dropbox/AMCPaper1/TempData") 

Data <- read.dta("AMCMainData.dta")

Data$year1980 <- Data$year - 1980

Data$Crisis32 <- tvc(Data, b = "SystemicCrisisLag3", tvar = "year1980", tfunc = "pow", pow = 2)

Data$UDSt <- tvc(Data, "UDS", "year1980", "log")

M1 <- coxph(Surv(year1980, AMCAnyCreated) ~ IMFDreher + SystemicCrisisLag3 + Crisis32 +
              cluster(imfcode) + strata(AMCStatus, NumAMCCountryNoNA), 
              data = Data)

M1 <- coxme(Surv(year1980, AMCAnyCreated) ~ UDS + UDSt + IMFDreher + 
              SystemicCrisisLag3 + Crisis32 +
              (1 | imfcode) + strata(AMCStatus, NumAMCCountryNoNA), 
            data = Data)

summary(M1)

print(M1)

BHm1 <- basehaz(M1)

SFm1 <- survfit(M1)

plot(SFm1)

# Create time from crisis
# TempData <- plyr::ddply(Data, ("country"), transform, GapTime = sequence(rle(SystemicCrisis)$length))

# TempData$Foil <- 0
# TempData <- plyr::ddply(TempData, ("country"), transform, FoilSeq = sequence(rle(Foil)$length))

# TempData$GapTime[TempData$GapTime == TempData$FoilSeq] <- NA

# M1 <- coxph(Surv(GapTime, AMCAnyCreated) ~ IMFDreher +
#              cluster(country) + strata(AMCStatus, NumAMCCountryNoNA), data = TempData)