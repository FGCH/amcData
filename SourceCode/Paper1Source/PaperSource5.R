#############
# Initial Paper Results
# Christopher Gandrud
# 21 March 2013
#############

##### Set Up ####################################
#### Create State Variable
# Create fstatus variable from AMCType
## 0 = No AMC
## 1 = Centralised AMC
## 2 = Decentralised AMC

# Load packages
library(survival)
library(simPH) # Note need to install with the following code: devtools::install_github("simPH", "christophergandrud")
library(apsrtable)

# Set Up
setwd("~/Dropbox/AMCPaper1/TempData") 
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

##########
# Models #
##########

#### Any Created ######################################
MA1 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + 
              TotalReservesGDP +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA2 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + 
              TotalReservesGDP + UDS +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA3 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + 
              TotalReservesGDP + polity2 +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA4 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + 
              TotalReservesGDP + UDS + polariz + checks +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA5 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + 
              TotalReservesGDP + UDS + polariz*checks +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA6 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + 
              TotalReservesGDP + UDS + polariz*checks + as.factor(ElectionYear1) +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA7 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + 
              TotalReservesGDP + UDS + polariz*checks + IMFDreherLag3 +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA8 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + 
              TotalReservesGDP + UDS + polariz*checks + log(GDPperCapita) +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data) 


#### Centralised Created ##############################

MC1 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + 
              TotalReservesGDP +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC2 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + 
              UDS +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC3 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + 
              polity2 +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC4 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + 
              UDS + polariz + checks +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC5 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + 
              UDS + polariz*checks +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC6 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + 
              UDS + as.factor(ElectionYear1) +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC7 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + 
              UDS + IMFDreherLag3 +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC8 <- coxph(Surv(year1980, AMCCent) ~ SystemicCrisisLag3 + 
              UDS + log(GDPperCapita) +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data) 


#### Decentralised Created ##############################

MD1 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
              TotalReservesGDP +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD2 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
              TotalReservesGDP + UDS +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD3 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
              TotalReservesGDP + polity2 +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD4 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
              TotalReservesGDP + UDS + polariz + checks +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD5 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
              TotalReservesGDP + polariz*checks +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD6 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
              TotalReservesGDP + as.factor(ElectionYear1) +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD7 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
              TotalReservesGDP + IMFDreherLag3 +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD8 <- coxph(Surv(year1980, AMCDecent) ~ SystemicCrisisLag3 + 
              TotalReservesGDP + log(GDPperCapita) +
              cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

################
# Show Results #
################

##################### Any AMC results tables ######################
MANames <- c("A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8")
CoefNamesMA <- c("Crisis 3 yr. Lag", "Reserves/GDP", "UDS", "Polity 2", 
					"Polarise", "Checks", "Polarise*Checks", "Election Year",
					"IMF Stand-By", "Log GDP/Capita")

AnyTable <- apsrtable(MA1, MA2, MA3, MA4, MA5, MA6, MA7, MA8,
						model.names = MANames,
						coef.names = CoefNamesMA,
						stars = "default",
						Sweave = TRUE,
						col.hspace = "0.5cm",
						digits = 2)

#cat(AnyTable, file =  "~/Dropbox/AMCPaper1/table/AnyTable.tex")

##################### Centralised AMC results tables ######################
MCNames <- c("B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8")
CoefNamesMC <- c("Crisis 3 yr. Lag", "Reserves/GDP", "UDS", "Polity 2", 
					"Polarise", "Checks", "Polarise*Checks", "Election Year",
					"IMF Stand-By", "Log GDP/Capita")

CentTable <- apsrtable(MC1, MC2, MC3, MC4, MC5, MC6, MC7, MC8,
						model.names = MCNames,
						coef.names = CoefNamesMC,
						stars = "default",
						Sweave = TRUE,
						col.hspace = "0.5cm",
						digits = 2)

#cat(CentTable, file =  "~/Dropbox/AMCPaper1/table/CentTable.tex")

##################### DeCentralised AMC results tables ######################
MDNames <- c("C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8")
CoefNamesMD <- c("Crisis 3 yr. Lag", "Reserves/GDP", "UDS", "Polity 2", 
					"Polarise", "Checks", "Polarise*Checks", "Election Year",
					"IMF Stand-By", "Log GDP/Capita")

DeCentTable <- apsrtable(MD1, MD2, MD3, MD4, MD5, MD6, MD7, MD8,
						model.names = MCNames,
						coef.names = CoefNamesMC,
						stars = "default",
						Sweave = TRUE,
						col.hspace = "0.5cm",
						digits = 2)

#cat(DeCentTable, file =  "~/Dropbox/AMCPaper1/table/DeCentTable.tex")

##################### Reserves Hazard Ratios Effect #########
Sim1 <- coxsimLinear(MA5, b = "TotalReservesGDP", qi = "Hazard Ratio",
						Xj = seq(0, 94, 2))

pdf(file = "~/Dropbox/AMCPaper1/figure/ReservesCentHazardRatio.pdf")
gglinear(Sim1, qi = "Hazard Ratio", smoother = "loess",
            xlab = "\n Reserves/GDP (%)")
dev.off()

##################### UDS Hazard Ratios Effect #########
Sim2 <- coxsimLinear(MC8, b = "UDS", qi = "Hazard Ratio",
						Xj = seq(-2, 2, 0.1))

pdf(file = "~/Dropbox/AMCPaper1/figure/UDSHazardRatio.pdf")
gglinear(Sim2, qi = "Hazard Ratio", smoother = "loess",
         xlab = "\n Unified Democracy Score")
dev.off()

##################### Polarization/Checks Marginal Effect #########

# Simulate Marginal Effects
Sim2 <- coxsimInteract(MA5, b1 = "polariz", b2 = "checks", qi = "Marginal Effect", X2 = c(1:7))

# Plot and save
pdf(file = "~/Dropbox/AMCPaper1/figure/PolChecksMarg.pdf")
gginteract(Sim2, qi = "Marginal Effect", smoother ="loess",
           ylab = "Marginal Effect of Polarization\n",
           xlab = "\nChecks")
dev.off()