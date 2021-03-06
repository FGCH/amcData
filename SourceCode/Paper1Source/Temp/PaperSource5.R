################
# Stratified Cox Regression
# Christopher Gandrud
# 16 February 2013
################

#### Create State Variable
# Create fstatus variable from AMCType
## 0 = No AMC
## 1 = Centralised AMC
## 2 = Decentralised AMC

library(simPH) # Note need to install with the following code: devtools::install_github("simPH", "christophergandrud")
library(survival)
library(coxme)

setwd("~/Dropbox/AMCPaper1/TempData") 

load("AMCMainData.RData")

Data <- AMCLag

# Set 1980 to 0
Data$year1980 <- Data$year - 1980

# Time Interactions
Data$CrisisLag3T <- tvc(Data, b = "SystemicCrisisLag3", 
                        tvar = "year1980", tfun = "power", pow = 3)
Data$CrisisLag5T <- tvc(Data, b = "SystemicCrisisLag5", tvar = "year1980", tfun = "linear")
Data$IMFt <- tvc(Data, "IMFDreher", "year1980", "linear")
Data$IMFCreditsT <- tvc(Data, "IMFCreditsDummy", "year1980", "log")

# Fail variable clean up
Data$AMCStatusNA <- Data$AMCStatus
Data$AMCStatusNA[Data$AMCStatus == 0] <- NA

# Centralised AMC Creation variable
Data$AMCCent <- 0
Data$AMCCent[Data$AMCStatusNA == 1 & Data$AMCAnyCreated == 1] <- 1

# Decentralised AMC Creation variable
Data$AMCDecent <- 0
Data$AMCDecent[Data$AMCStatusNA == 2 & Data$AMCAnyCreated == 1] <- 1

M1 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 +
              UDS + polariz*checks +
              cluster(ISOCode) + strata(NumAMCCountryNoNA), data = Data)

M2 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 +
              CashSurplusDeficit +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

M2 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + pspline(GDPCurrentUSD) + polariz*checks +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

M1 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + polariz*checks +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

M1 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + polariz*checks + pspline(UDS) + pspline(GDPperCapita) + cluster(imfcode), data = Data)

M1 <- coxph(Surv(year1980, AMCCent) ~ pspline(UDS) + cluster(imfcode), data = Data)

summary(M1)
cox.zph(M1)

# coxsimInteract test
Sim1 <- coxsimInteract(M1, b1 = "polariz", b2 = "checks", qi = "Marginal Effect", X2 = c(1:5), ci = "90")
gginteract(Sim1, qi = "Marginal Effect", smoother = "lm")

# Plot govfrac spline
termplot(M1, term = 3, ylabs = "Log Hazard", se = TRUE, rug = TRUE)

M2 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + 
              factor(execrlc) + pspline(govfrac) + 
              cluster(imfcode) + strata(AMCStatusNA), 
            data = Data)

summary(M2)
cox.zph(M2)

# Plot govfrac spline
termplot(M2, term = 3, ylabs = "Log Hazard", se = TRUE, rug = TRUE)

simFitLin <- coxsimLinear(M1, b = "IMFCreditsDummy", qi = "Hazard Rate", ci = "95")
gglinear(simFitLin, qi = "Hazard Rate")

simFit1 <- coxsimtvc(M1, b = "SystemicCrisisLag3", btvc = "Crisis32", 
                    tfun = "linear", pow = 3, from = 0, to = 30, 
                    by = 1, strata = TRUE)

simFit2 <-cox

# simFitTest$strata <- revalue(simFitTest$strata, c("AMCStatusNA=1" = "Centr,", "AMCStatusNA=2" = "Decentr."))

ggtvc(simFit, qi = "Relative Hazard", strata = TRUE, ylab = "Relative Hazard\n", psize = 2.5)

# ggtvc(simFitTest, qi = "Hazard Ratio", strata = TRUE, ylab = "Hazard Ratio\n", psize = 2.5)

##########

M2 <- coxme(Surv(year1980, AMCAnyCreated) ~ UDS + UDSt + IMFDreher + 
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