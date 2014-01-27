#############
# Paper Results
# Christopher Gandrud
# 14 January 2014
#############

##### Set Up ####################################
#### Create State Variable
# Create fstatus variable from AMCType
## 0 = No AMC
## 1 = Centralised AMC
## 2 = Decentralised AMC

# Load packages
library(survival)
library(simPH)
library(texreg)
library(ggplot2)
library(gridExtra)
library(corrgram)

# Set Up
setwd("~/Dropbox/AMCProject/TempData") 
load("AMCMainData.RData")
Data <- AMCLag

# Fail variable clean up
Data$AMCStatusNA <- Data$AMCStatus
Data$AMCStatusNA[Data$AMCStatus == 0] <- NA

# Centralised AMC Centralization Creation variable
Data$AMCCent <- 0
Data$AMCCent[Data$AMCStatus == 1 & Data$AMCAnyCreated == 1] <- 1

# Centralised AMC Decent Creation variable
Data$AMCDecent <- 0
Data$AMCDecent[Data$AMCStatus == 2 & Data$AMCAnyCreated == 1] <- 1

# Change the scale of economic_abs to ease interpretation 
Data$economic_abs <- Data$economic_abs *100

# Put total reserves on a log scale
Data$GDPperCapitaLog <- log(Data$GDPperCapita)
Data$GDPCurrentUSDLog <- log(Data$GDPCurrentUSD)

## Added 1 to avoid infinity values
Data$TotalReservesGDPLog <- log(Data$TotalReservesGDP + 1)

# Rescale at the mean to ease hazard ratio interpretation
Data$EconReScale <- Data$economic_abs - 50

# Constrict sample to between 1990 and 2010
## This is done because of high missingness rates outside of [1990, 2010]
Data <- subset(Data, year >= 1990)
Data <- subset(Data, year <= 2010)

# Set 1990 to 0
Data$year1990 <- Data$year - 1990

# Drop Claims Outliers
Data$ClaimsNoOut <- Data$ClaimsOnGov
Data$ClaimsNoOut[Data$ClaimsOnGov > 200] <- NA
Data$ClaimsNoOut[Data$ClaimsOnGov < -200] <- NA

##########
# Models #
##########

#### Any Created ######################################
#### Any Created ######################################
MA1 <- coxph(Surv(year1990, AMCAnyCreated) ~ SystemicCrisisLag3 + EconReScale + 
               polity2 + GDPperCapitaLog +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA2 <- coxph(Surv(year1990, AMCAnyCreated) ~ SystemicCrisisLag3 + EconReScale + 
               polity2 + GDPperCapitaLog + CvHOwnPerc +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA3 <- coxph(Surv(year1990, AMCAnyCreated) ~ SystemicCrisisLag3 + EconReScale + 
               polity2 + GDPperCapitaLog + CentGovDebt +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA4 <- coxph(Surv(year1990, AMCAnyCreated) ~ SystemicCrisisLag3 + EconReScale + 
               polity2 + GDPperCapitaLog + CashSurplusDeficit +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA5 <- coxph(Surv(year1990, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC + EconReScale + 
               polity2 + GDPperCapitaLog + DebtChange + 
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA5 <- coxph(Surv(year1990, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC + 
               pspline(ClaimsNoOut) + EconReScale + 
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

CrisesData <- subset(Data, SystemicCrisisLag3 == 1)
Data <- slide(Data, Var = 'ClaimsNoOut', GroupVar = 'imfcode', slideBy = 1, NewVar = 'ClaimsSlideUp')


MA6 <- coxph(Surv(year1990, AMCDecent) ~ SystemicCrisisLag3 + polity2*EconReScale + 
               GDPperCapitaLog + 
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)



MA7 <- coxph(Surv(year1990, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDPLog + EconReScale + 
               as.factor(ElectionYear1) +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA8 <- coxph(Surv(year1990, AMCAnyCreated) ~ SystemicCrisisLag3 +
               TotalReservesGDPLog + EconReScale + polity2 + 
               polariz*checks + IMFDreherLag3 +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA9 <- coxph(Surv(year1990, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDPLog + EconReScale + polity2 + 
               polariz*checks + GDPperCapitaLog +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data) 

MA10 <- coxph(Surv(year1990, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDPLog + EconReScale + polity2 +
               polariz*checks + GDPCurrentUSDLog +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data) 



