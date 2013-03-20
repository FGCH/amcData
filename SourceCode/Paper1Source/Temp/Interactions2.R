################
# Stratified Cox Regression with Interactions
# Christopher Gandrud
# 20 March 2013
################

#### Create State Variable
# Create fstatus variable from AMCType
## 0 = No AMC
## 1 = Centralised AMC
## 2 = Decentralised AMC

# Load packages
library(survival)
library(simPH) # Note need to install with the following code: devtools::install_github("simPH", "christophergandrud")

# Set Up
setwd("~/Dropbox/AMCPaper1/TempData") 
load("AMCMainData.RData")
Data <- AMCLag

# Set 1980 to 0
Data$year1980 <- Data$year - 1980

# Set 1980 to 0
Data$year1980 <- Data$year - 1980

# Fail variable clean up
Data$AMCStatusNA <- Data$AMCStatus
Data$AMCStatusNA[Data$AMCStatus == 0] <- NA

# Centralised AMC Centralization Creation variable
Data$AMCCent <- 0
Data$AMCCent[Data$AMCStatus == 1 & Data$AMCAnyCreated == 1] <- 1

# Centralised AMC Decent Creation variable
Data$AMCDecent <- 0
Data$AMCDecent[Data$AMCStatus == 2 & Data$AMCAnyCreated == 1] <- 1

# Models
M1 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + pspline(checks) +
              cluster(imfcode), data = Data)


M2 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + CurrentAccount + 
              polariz*checks +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)


# Marginal Effects Graphs
## Centralised
Sim1 <- coxsimInteract(M2, b1 = "polariz", b2 = "checks", qi = "Marginal Effect", X2 = c(1:7))
gginteract(Sim1, qi = "Marginal Effect", smoother = "lm",
           ylab = "Marginal Effect of Polarization\n",
           xlab = "\nChecks")