#############
# Paper Results
# Christopher Gandrud
# 3 January 2014
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

# Set Up
setwd("~/Dropbox/AMCProject/TempData") 
load("AMCMainData.RData")
Data <- AMCLag

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

# Change the scale of economic_abs to ease interpretation 
Data$economic_abs <- Data$economic_abs *100

##########
# Models #
##########

#### Any Created ######################################
MA1 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDP + 
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA2 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDP + CvHOwnPerc +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA3 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDP + CvHOwnPerc + economic_abs +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA4 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDP + UDS +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA5 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDP + CvHOwnPerc + economic_abs + UDS + 
               polariz + checks +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA6 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDP + CvHOwnPerc + economic_abs + UDS + 
               polariz*checks +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA7 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDP + CvHOwnPerc + economic_abs + UDS + 
               polariz*checks + as.factor(ElectionYear1) +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA8 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 +
               TotalReservesGDP + CvHOwnPerc + economic_abs + UDS + 
               polariz*checks + IMFDreherLag3 +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA9 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDP + CvHOwnPerc + economic_abs + UDS + 
               polariz*checks + log(GDPperCapita) +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data) 

MA10 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDP + CvHOwnPerc + economic_abs + UDS + 
               polariz*checks + log(GDPCurrentUSD) + IMF.AMC +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data) 


#### Centralised Created ##############################

MC1 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDP + 
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC2 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDP + CvHOwnPerc +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC3 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDP + economic_abs +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC4 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDP + UDS +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC5 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDP + economic_abs + UDS + 
               polariz + checks +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC6 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDP + economic_abs + UDS + 
               polariz*checks +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC7 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDP + economic_abs + UDS + 
               as.factor(ElectionYear1) +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC8 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + 
               TotalReservesGDP + economic_abs + UDS + 
               IMFDreherLag3 +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC9 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDP + economic_abs + UDS + 
               log(GDPperCapita) +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data) 

MC10 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDP + economic_abs + UDS + 
               log(GDPCurrentUSD) +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)  


#### Decentralised Created ##############################

MD1 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
               TotalReservesGDP +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD2 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
               TotalReservesGDP + CvHOwnPerc +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD3 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
               TotalReservesGDP + CvHOwnPerc + economic_abs +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD4 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
               TotalReservesGDP + UDS +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD5 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
               TotalReservesGDP + economic_abs + UDS + 
               polariz + checks +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD6 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
               TotalReservesGDP + economic_abs + UDS + 
               polariz*checks +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD7 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
               TotalReservesGDP + economic_abs + UDS + 
               as.factor(ElectionYear1) +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD8 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
               TotalReservesGDP + economic_abs + UDS + 
               IMFDreherLag3 +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD9 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
               TotalReservesGDP + economic_abs + UDS + 
               GDPperCapita +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data) 

MD10 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
               TotalReservesGDP + economic_abs + UDS + 
               log(GDPCurrentUSD) + 
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)  

MD11 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
                TotalReservesGDP + economic_abs*UDS + 
                cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data) 

MD11Plot <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
                TotalReservesGDP + UDS*economic_abs + 
                cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data) 

################
# Show Results #
################

##################### Any AMC results tables ######################
MANames <- c("A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9", "A10")
CoefNamesMA <- c("Crisis 3 yr. Lag", "MONA IMF Condition", "Reserves/GDP", "Foreign Ownership", 
                 "Economic Inst.", "UDS",
                 "Polarise", "Checks", "Polarise*Checks", "Executive Election",
                 "IMF Stand-By", "Log GDP/Capita", "Log Total GDP")

texreg(list(MA1, MA2, MA3, MA4, MA5, MA6, MA7, MA8, MA9, MA10),
      custom.model.names = MANames,
      custom.coef.names = CoefNamesMA,
      custom.note = "Robust standard errors in parentheses. {***}$p<0.001$, {**}$p<0.01$, {*}$p<0.05$",
      caption.above = TRUE,
      table = FALSE,
      use.packages = FALSE,
      file = "~/Dropbox/AMCProject/table/AnyTable.tex"
      )

##################### Centralised AMC results tables ######################
MCNames <- c("B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9", "B10")
CoefNamesMC <- c("Crisis 3 yr. Lag", "MONA IMF Condition", "Reserves/GDP", "Foreign Ownership", 
                 "Economic Inst.", "UDS",
                 "Polarise", "Checks", "Polarise*Checks", "Executive Election",
                 "IMF Stand-By", "Log GDP/Capita", "Log Total GDP")

texreg(list(MC1, MC2, MC3, MC4, MC5, MC6, MC7, MC8, MC9, MC10),
       custom.model.names = MCNames,
       custom.coef.names = CoefNamesMC,
       custom.note = "Robust standard errors in parentheses. {***}$p<0.001$, {**}$p<0.01$, {*}$p<0.05$",
        caption.above = TRUE,
        table = FALSE,
        use.packages = FALSE,
        file =  "~/Dropbox/AMCProject/table/CentTable.tex"         
        )


##################### DeCentralised AMC results tables ######################
MDNames <- c("C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10", "C11")
CoefNamesMD <- c("Crisis 3 yr. Lag", "Reserves/GDP", "Foreign Ownership", 
                 "Economic Inst.", "UDS",
                 "Polarise", "Checks", "Polarise*Checks", "Executive Election",
                 "IMF Stand-By", "GDP/Capita", "Log Total GDP", "Econ. Inst.*UDS")

texreg(list(MD1, MD2, MD3, MD4, MD5, MD6, MD7, MD8, MD9, MD10, MD11),
       custom.model.names = MDNames,
       custom.coef.names = CoefNamesMD,
       stars = c(0.001, 0.01, 0.05, 0.1),
       custom.note = "Log GDP/Capita not used because it violates the PHA. Robust standard errors in parentheses. {***}$p<0.001$, {**}$p<0.01$, {*}$p<0.05$, {$^.$}$p<0.1$",
        caption.above = TRUE,
        table = FALSE,
        use.packages = FALSE,
        file =  "~/Dropbox/AMCProject/table/DeCentTable.tex"         
        )

##################### Foreign Ownership Hazard Ratios Effect #########
Sim1 <- coxsimLinear(MA10, b = "CvHOwnPerc", qi = "Hazard Ratio",
                       Xj = seq(0, 100, 1), ci = 0.95)

pdf(file = "~/Dropbox/AMCProject/figure/ForeignOwnersHazRatio.pdf")
simGG(Sim1, ribbons = TRUE, alpha = 0.3, xlab = "\nForeign Bank Ownership (%)")
dev.off()

##################### Economic Institutions Hazard Ratios Effect #########
Sim2 <- coxsimLinear(MA10, b = "economic_abs", qi = "Hazard Ratio",
                       Xj = seq(0, 90, 1), ci = 0.95)

pdf(file = "~/Dropbox/AMCProject/figure/EconomicInstHazRatio.pdf")
simGG(Sim2, ribbons = TRUE, alpha = 0.3,
      xlab = "\nEconomic Institutional Quality")
dev.off()

##################### UDS Hazard Ratios Effect #########
## Split up to give a better look at different ranges of fitted values.

Sim3.1 <- coxsimLinear(MD10, b = "UDS", qi = "Hazard Ratio",
                     Xj = seq(-2, 0, 0.05), ci = 0.9)

Sim3.2 <- coxsimLinear(MD10, b = "UDS", qi = "Hazard Ratio",
                       Xj = seq(0, 1, 0.05), ci = 0.9)

Sim3.3 <- coxsimLinear(MD10, b = "UDS", qi = "Hazard Ratio",
                       Xj = seq(1, 2, 0.05), ci = 0.9)

######## Maybe remove if econ qual/democracy interaction stays
UDS.1 <- simGG(Sim3.1, alpha = 0.3,
               xlab = "\n Unified Democracy Score", ribbons = TRUE) +
               scale_x_continuous(breaks = c(-2, -1, 0))

UDS.2 <- simGG(Sim3.2, alpha = 0.3,
               xlab = "", ylab = "", ribbons = TRUE) + 
               scale_x_continuous(breaks = c(0, 0.5, 1))

UDS.3 <- simGG(Sim3.3, alpha = 0.3,
               xlab = "", ylab = "", ribbons = TRUE) + 
               scale_x_continuous(breaks = c(1, 1.5, 2))

pdf(file = "~/Dropbox/AMCProject/figure/UDSHazardRatio.pdf", width = 12, paper = "a4r")
  grid.arrange(UDS.1, UDS.2, UDS.3, ncol = 3)
dev.off()

##################### Polarization/Checks Marginal Effect #########

# Simulate Marginal Effects
Sim4 <- coxsimInteract(MA10, b1 = "polariz", b2 = "checks", 
                       qi = "Marginal Effect", X2 = c(1:7), ci = 0.95)

# Plot and save
pdf(file = "~/Dropbox/AMCProject/figure/PolChecksMarg.pdf")
simGG(Sim4, ylab = "Marginal Effect of Polarization\n",
           xlab = "\nChecks", smooth = "loess")
dev.off()

##################### Econ Inst. Quality/Democarcy Marginal Effect #########

# Simulate Marginal Effects
Sim5 <- coxsimInteract(MD11Plot, b1 = 'UDS', b2 = 'economic_abs', 
                       qi = 'Marginal Effect', X2 = seq(0, 90, 1), ci = 0.95)

# Plot and save
pdf(file = "~/Dropbox/AMCProject/figure/QualDemMarg.pdf")
simGG(Sim5, ylab = "Marginal Effect of Unified Democracy Score\n",
      xlab = "\nEconomic Institutional Quality", ribbon = TRUE, alpha = 0.3)
dev.off()


