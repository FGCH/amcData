#############
# Paper Results
# Christopher Gandrud
# 9 January 2014
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

##########
# Models #
##########

#### Any Created ######################################
MA1 <- coxph(Surv(year1990, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDPLog + 
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA2 <- coxph(Surv(year1990, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDPLog + CvHOwnPerc +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA3 <- coxph(Surv(year1990, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDPLog + CvHOwnPerc + EconReScale +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA4 <- coxph(Surv(year1990, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDPLog +CvHOwnPerc +  polity2 +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA5 <- coxph(Surv(year1990, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDPLog + EconReScale + polity2 + 
               polariz + checks +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA6 <- coxph(Surv(year1990, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDPLog + EconReScale + polity2 + 
               polariz*checks +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MA7 <- coxph(Surv(year1990, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDPLog + EconReScale + 
               polariz*checks + as.factor(ElectionYear1) +
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


#### Centralised Created ##############################

MC1 <- coxph(Surv(year1990, AMCCent) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDPLog +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC2 <- coxph(Surv(year1990, AMCCent) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDPLog + CvHOwnPerc +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC3 <- coxph(Surv(year1990, AMCCent) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDPLog + EconReScale +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC4 <- coxph(Surv(year1990, AMCCent) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDPLog + polity2 +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC5 <- coxph(Surv(year1990, AMCCent) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDPLog + EconReScale + polity2 + 
               polariz + checks +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC6 <- coxph(Surv(year1990, AMCCent) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDPLog + EconReScale + polity2 + 
               polariz*checks +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC7 <- coxph(Surv(year1990, AMCCent) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDPLog + EconReScale +  
               as.factor(ElectionYear1) +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC8 <- coxph(Surv(year1990, AMCCent) ~ SystemicCrisisLag3 + 
               TotalReservesGDPLog + EconReScale + polity2 + 
               IMFDreherLag3 +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MC9 <- coxph(Surv(year1990, AMCCent) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDPLog + EconReScale + polity2 + 
               GDPperCapitaLog +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data) 

MC10 <- coxph(Surv(year1990, AMCCent) ~ SystemicCrisisLag3 + IMF.AMC +
               TotalReservesGDPLog + EconReScale + polity2 + 
               GDPCurrentUSDLog +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)  


#### Decentralised Created ##############################

MD1 <- coxph(Surv(year1990, AMCDecent) ~ SystemicCrisisLag3 + 
               TotalReservesGDPLog + 
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD2 <- coxph(Surv(year1990, AMCDecent) ~ SystemicCrisisLag3 + 
               TotalReservesGDPLog + CvHOwnPerc +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD3 <- coxph(Surv(year1990, AMCDecent) ~ SystemicCrisisLag3 + 
               TotalReservesGDPLog + CvHOwnPerc + EconReScale +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD4 <- coxph(Surv(year1990, AMCDecent) ~ SystemicCrisisLag3 + 
               TotalReservesGDPLog + EconReScale + polity2 + 
               polariz + checks +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD5 <- coxph(Surv(year1990, AMCDecent) ~ SystemicCrisisLag3 + 
               TotalReservesGDPLog + EconReScale + polity2 + 
               polariz*checks +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD6 <- coxph(Surv(year1990, AMCDecent) ~ SystemicCrisisLag3 + 
               TotalReservesGDPLog + EconReScale +
               as.factor(ElectionYear1) +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

# IMFDreherLag3 violates cox PHA with no clear non-linear or time-varying interpretation
## Possibly related to a dramatic constriction of the number of events
#MD7 <- coxph(Surv(year1990, AMCDecent) ~ SystemicCrisisLag3 + 
#               TotalReservesGDPLog + EconReScale + polity2 + 
#               IMFDreherLag3 +
#               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)

MD8 <- coxph(Surv(year1990, AMCDecent) ~ SystemicCrisisLag3 + 
               TotalReservesGDPLog + EconReScale + polity2 + 
               GDPperCapitaLog +
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data) 

MD9 <- coxph(Surv(year1990, AMCDecent) ~ SystemicCrisisLag3 + 
               TotalReservesGDPLog + EconReScale + polity2 + 
               GDPCurrentUSDLog + 
               cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data)  

MD10 <- coxph(Surv(year1990, AMCDecent) ~ SystemicCrisisLag3 + 
                TotalReservesGDPLog + EconReScale*polity2 + 
                cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data) 

MD10Plot <- coxph(Surv(year1990, AMCDecent) ~ SystemicCrisisLag3 + 
                TotalReservesGDPLog + polity2*EconReScale + 
                cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data) 

################
# Show Results #
################

##################### Any AMC results tables ######################
MANames <- c("A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9", "A10")
CoefNamesMA <- c("Crisis 3 yr. Lag", "MONA IMF Condition", "Log Reserves/GDP", "Foreign Ownership", 
                 "Economic Inst.", "Polity",
                 "Polarize", "Checks", "Polarize*Checks", "Executive Election",
                 "IMF Stand-By", "Log GDP/Capita", "Log Total GDP")

texreg(list(MA1, MA2, MA3, MA4, MA5, MA6, MA7, MA8, MA9, MA10),
      custom.model.names = MANames,
      custom.coef.names = CoefNamesMA,
      stars = c(0.001, 0.01, 0.05, 0.1),
      custom.note = "Robust standard errors in parentheses. {***}$p<0.001$, {**}$p<0.01$, {*}$p<0.05$, {$^.$}$p<0.1$",
      caption.above = TRUE,
      table = FALSE,
      use.packages = FALSE,
      file = "~/Dropbox/AMCProject/table/AnyTable.tex"
      )

##################### Centralised AMC results tables ######################
MCNames <- c("B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9", "B10")
CoefNamesMC <- c("Crisis 3 yr. Lag", "MONA IMF Condition", "Log Reserves/GDP", "Foreign Ownership", 
                 "Economic Inst.", "Polity",
                 "Polarize", "Checks", "Polarize*Checks", "Executive Election",
                 "IMF Stand-By", "Log GDP/Capita", "Log Total GDP")

texreg(list(MC1, MC2, MC3, MC4, MC5, MC6, MC7, MC8, MC9, MC10),
       custom.model.names = MCNames,
       custom.coef.names = CoefNamesMC,
       stars = c(0.001, 0.01, 0.05, 0.1),
       custom.note = "Robust standard errors in parentheses. {***}$p<0.001$, {**}$p<0.01$, {*}$p<0.05$, {$^.$}$p<0.1$",
        caption.above = TRUE,
        table = FALSE,
        use.packages = FALSE,
        file =  "~/Dropbox/AMCProject/table/CentTable.tex"         
        )


##################### DeCentralised AMC results tables ######################
MDNames <- c("C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9")
CoefNamesMD <- c("Crisis 3 yr. Lag", "Log Reserves/GDP", "Foreign Ownership", 
                 "Economic Inst.", "Polity",
                 "Polarize", "Checks", "Polarize*Checks", "Executive Election",
                 "Log GDP/Capita", "Log Total GDP", "Econ. Inst.*Polity")

texreg(list(MD1, MD2, MD3, MD4, MD5, MD6, MD8, MD9, MD10),
       custom.model.names = MDNames,
       custom.coef.names = CoefNamesMD,
       stars = c(0.001, 0.01, 0.05, 0.1),
       # custom.note = # added in the main text
        caption.above = TRUE,
        table = FALSE,
        use.packages = FALSE,
        file =  "~/Dropbox/AMCProject/table/DeCentTable.tex"         
        )

##################### Foreign Ownership Hazard Ratios Effect #########
Sim1 <- coxsimLinear(MA4, b = "CvHOwnPerc", qi = "Hazard Ratio",
                       Xj = seq(0, 100, 1), ci = 0.95)

pdf(file = "~/Dropbox/AMCProject/figure/ForeignOwnersHazRatio.pdf")
simGG(Sim1, ribbons = TRUE, alpha = 0.3, xlab = "\nForeign Bank Ownership (%)")
dev.off()

##################### Economic Institutions Hazard Ratios Effect #########
Sim2.1 <- coxsimLinear(MA10, b = "EconReScale", qi = "Hazard Ratio",
                       Xj = seq(-30, 40, 1), ci = 0.95, spin = TRUE)

pdf(file = "~/Dropbox/AMCProject/figure/EconomicInstHazRatio.pdf")

simGG(Sim2.1, ribbons = TRUE, alpha = 0.3, xlab = "\nEconomic Institutional Quality")

dev.off()

##################### Polity Hazard Ratios Effect #########
## Split up to give a better look at different ranges of fitted values.

Sim3.1 <- coxsimLinear(MD4, b = "polity2", qi = "Hazard Ratio",
                     Xj = seq(-10, 0, 0.05), ci = 0.95)

Sim3.2 <- coxsimLinear(MD4, b = "polity2", qi = "Hazard Ratio",
                       Xj = seq(0, 10, 0.05), ci = 0.95)


######## Maybe remove if econ qual/democracy interaction stays
polity2.1 <- simGG(Sim3.1, alpha = 0.3,
               xlab = "\n Polity Score", ribbons = TRUE)

polity2.2 <- simGG(Sim3.2, alpha = 0.3,
               xlab = "", ylab = "", ribbons = TRUE)

pdf(file = "~/Dropbox/AMCProject/figure/polity2HazardRatio.pdf", width = 12, paper = "a4r")
  grid.arrange(polity2.1, polity2.2, ncol = 2)
dev.off()

##################### Polarization/Checks Marginal Effect #########

# Simulate Marginal Effects
Sim4 <- coxsimInteract(MA10, b1 = "polariz", b2 = "checks", 
                       qi = "Marginal Effect", X2 = c(1:7), ci = 0.95)

Data$ChecksRe <- Data$checks - 3
MA10Plot <- coxph(Surv(year1990, AMCAnyCreated) ~ SystemicCrisisLag3 + IMF.AMC +
                TotalReservesGDPLog + CvHOwnPerc + EconReScale + UDS + 
                ChecksRe*polariz + GDPCurrentUSDLog + IMF.AMC +
                cluster(imfcode) + strata(NumAMCCountryNoNA), data = Data) 

Sim4.1 <- coxsimInteract(MA10Plot, b1 = 'ChecksRe', b2 = 'polariz', qi = 'Hazard Ratio', 
                         X1 = seq(-1, 4, 1), X2 = c(2), spin = TRUE, ci = .9)
simGG(Sim4.1, ribbons = TRUE)

# Plot and save
pdf(file = "~/Dropbox/AMCProject/figure/PolChecksMarg.pdf")
simGG(Sim4, ylab = "Marginal Effect of Polarization\n",
           xlab = "\nChecks", smooth = "loess")
dev.off()

##################### Econ Inst. Quality/Democarcy Marginal Effect #########

Sim6 <- coxsimInteract(MD10Plot, b1 = 'polity2', b2 = 'EconReScale', 
                       qi = 'Marginal Effect', X2 = seq(-30, 40, 1), ci = 0.95)

# Plot and save
pdf(file = "~/Dropbox/AMCProject/figure/QualDemMarg.pdf")

  simGG(Sim6, ylab = "Marginal Effect of Polity\n",
      xlab = "\nEconomic Institutional Quality", ribbon = TRUE, alpha = 0.3)

  # grid.arrange(UEInter1, UEInter2, ncol = 2)
dev.off()

##################### Hazard Ratio #########
Sim7 <- coxsimInteract(MD10, b1 = 'EconReScale', b2 = 'polity2', 
                       qi = 'Hazard Ratio', X1 = seq(16, 40, by = 0.5), 
                       X2 = c(-5, 10), ci = 0.95, spin = FALSE)

Sim7$X2 <- as.character(Sim7$X2)
Sim7$X2[Sim7$X2 == '-5'] <- 'Lower (-5)'
Sim7$X2[Sim7$X2 == '10'] <- 'High (10)'

pdf(file = "~/Dropbox/AMCProject/figure/EconPolityHR.pdf")
  simGG(Sim7, xlab = "\nEconomic Institutional Quality", ribbons = TRUE,
        leg.name = "Democracy (Polity)") + 
        scale_x_continuous(limits = c(16, 40), breaks = c(16, 25, 35, 40))
dev.off()

############## Plot Matrix

pdf(file = "~/Dropbox/AMCProject/figure/PlotMatrix.pdf")
  Vars <- c('SystemicCrisis', 'SystemicCrisisLag3', 'IMF.AMC', 
            'TotalReservesGDPLog', 'CvHOwnPerc', 'EconReScale',
            'polity2', 'polariz', 'checks', 'GDPperCapitaLog', 'GDPCurrentUSDLog')
  corrgram(Data[, Vars], upper.panel=panel.pts, diag.panel=panel.minmax)
dev.off()
