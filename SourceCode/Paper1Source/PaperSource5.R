################
# Stratified Cox Regression
# Christopher Gandrud
# 9 February 2013
################

library(foreign)
library(simPH) # Note need to install with the following code: devtools::install_github("simPH", "christophergandrud")
library(survival)
library(coxme)

setwd("~/Dropbox/AMCPaper1/TempData") 

Data <- read.dta("AMCMainData.dta")

Data$year1980 <- Data$year - 1980

Data$Crisis32 <- tvc(Data, b = "SystemicCrisisLag3", tvar = "year1980", tfun = "linear")

Data$IMFt <- tvc(Data, "IMFDreher", "year1980", "log")

Data$AMCStatusNA <- Data$AMCStatus
Data$AMCStatusNA[Data$AMCStatus == 0] <- NA

M1 <- coxph(Surv(year1980, AMCAnyCreated) ~ + SystemicCrisisLag3 + Crisis32 + IMFDreher +
              cluster(imfcode) + strata(AMCStatusNA), 
              data = Data)

simFitLin <- coxsimLinear(M1, b = "IMFDreher", qi = "Hazard Rate", ci = "90")
gglinear(simFitLin, qi = "Hazard Rate")

simFit1 <- coxsimtvc(M1, b = "SystemicCrisisLag3", btvc = "Crisis32", 
                    tfun = "linear", pow = 3, from = 0, to = 30, 
                    by = 1, strata = TRUE)

simFitTest <- coxsimtvc(M1, b = "SystemicCrisisLag3", btvc = "Crisis32", 
                    tfun = "linear", pow = 3, from = 0, to = 30, by = 1, 
                    qi = "Hazard Ratio", Xj = c(.5, 1), Xl = c(0, 0), 
                    strata = TRUE)

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