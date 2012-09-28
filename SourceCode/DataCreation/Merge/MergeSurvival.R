############ 
# Merge Cleaned Up AMC Database Data (Repeated Survival Time Version)
# Christopher Gandrud
# Updated 28 Septemeber 2012
############

# Load required packages
library(reshape)
library(gdata)

## ID variable is imfcode

setwd("/git_repositories/amcData/MainData/CleanedPartial/")

# Load data
lv <- read.csv("LvData.csv") 
lvAllCrises <- read.csv("LVCrisisDummyData.csv")
uds <- read.csv("UdsData.csv")
dpi <- read.csv("DpiData.csv")
amc <- read.csv("AMCFull.csv")
wdi <- read.csv("WDIData.csv")
imf <- read.csv("IMFData.csv")

# Remove missing id variables
lv <- lv[!is.na(lv$imfcode), ]
lv <- lv[!is.na(lv$imfcode), ]
uds <- uds[!is.na(uds$imfcode), ]
dpi <- dpi[!is.na(dpi$imfcode), ]
wdi <- wdi[!is.na(wdi$imfcode), ]
imf <- imf[!is.na(imf$imfcode), ]

# Create Crisis 5 year data (crisis year + 4)
for (i in 1:4){
  temp <- lv$year + i
  assign(paste("TempYear", i, sep = ""), cbind(lv, temp))
}

TempYear1 <- remove.vars(TempYear1, names = "year")
TempYear1 <- rename(TempYear1, c(temp = "year"))  
TempYear2 <- remove.vars(TempYear2, names = "year")
TempYear2 <- rename(TempYear2, c(temp = "year"))
TempYear3 <- remove.vars(TempYear3, names = "year")
TempYear3 <- rename(TempYear3, c(temp = "year"))
TempYear4 <- remove.vars(TempYear4, names = "year")
TempYear4 <- rename(TempYear4, c(temp = "year"))

lv <- rbind(lv, TempYear1, TempYear2, TempYear4)

# Tidy up workspace
rm(TempYear1, TempYear2, TempYear3, TempYear4, TempYear5, i, temp)

# Merge with UDS
amcCountryYear <- merge(lv, uds, union("imfcode", "year"), all = TRUE)
  amcCountryYear <- remove.vars(amcCountryYear, names = "country.x")
  amcCountryYear <- rename(amcCountryYear, c(country.y = "country"))

# Merge with DPI
amcCountryYear <- merge(amcCountryYear, dpi, union("imfcode", "year"), all = TRUE)
  amcCountryYear <- remove.vars(amcCountryYear, names = "country.y")
  amcCountryYear <- rename(amcCountryYear, c(country.x = "country"))

# Merge with AMCFull Data
## Remove old AMCType, AMC variabls from LV from the data set, due to inclusion of more comprehensive data from AMCFull
amcCountryYear <- remove.vars(amcCountryYear, names = c("AMCType", "AMC"))

amcCountryYear <- merge(amcCountryYear, amc, union("imfcode", "year"), all = TRUE)
  amcCountryYear <- remove.vars(amcCountryYear, names = "country.y")
  amcCountryYear <- rename(amcCountryYear, c(country.x = "country"))

# Merge with WDI Data
amcCountryYear <- merge(amcCountryYear, wdi, union("imfcode", "year"), all = TRUE)

# Merge with IMF Dreher Data
amcCountryYear <- merge(amcCountryYear, imf, union("imfcode", "year"), all = TRUE)

# Merge with LV crisis year dummies
## Remove old AMCType variable from LV
amcCountryYear <- remove.vars(amcCountryYear, names = "CurrencyCrisis")

amcCountryYear <- merge(amcCountryYear, lvAllCrises, union("imfcode", "year"), all = TRUE)

# Change missing to 0 for crisis year dummies
vars <- c("SystemicCrisis",
          "CurrencyCrisis",
          "SovereignDefault",
          "SovereignDebtRestructuring"
          )

for (i in vars){
  amcCountryYear[[i]][is.na(amcCountryYear[[i]])] <- 0
}

# Clean up merge
amcCountryYear <- amcCountryYear[amcCountryYear$year >= 1980, ]
amcCountryYear <- amcCountryYear[!is.na(amcCountryYear$year), ]

amcCountryYear <- amcCountryYear[!duplicated(amcCountryYear[, 1:2], fromLast=FALSE), ]

vars <- c("country", "imfcode", "year", "UDS", "yrcurnt", "govfrac", "execrlc", 
          "ElectionYear", "SystemicCrisis", "CurrencyCrisis", "SovereignDefault", 
          "SovereignDebtRestructuring", "GDPperCapita", "NPLwdi", "CurrentAccount", 
          "IMFDreher", "CrisisDate", "CreditBoom", "CreditorRights", "CreditorRightsIndex", 
          "DepositIns", "YearDICreated", "DICoverageLimit", "DICoverageRatio", "DepositFreeze", 
          "DateDepositFreeze", "DurationDepositFreeze", "TimeDepositsFreeze", 
          "BankHoliday", "DateBankHoliday", "DurationBankHoliday", "BankGuaranteee", 
          "DateBankGuaranteeStart", "DateBankGuaranteeEnd", "BankGuaranteeDuration", 
          "BankGuaranteeCoverage", "EmergencyLending", "DateEmergencyLending", 
          "PeakLendingSupport", "BankRestructuring", "Nationalizations", 
          "AssetPurchases", "Recap", "RecapCosts", "RecoveryDummy", 
          "RecoveryProceeds", "GovRecapCosts", "DepositorLosses", "DepositorLosesSeverity", 
          "MonetaryPolicyIndex", "AverageReserveChange", "FiscalPolicyIndex", 
          "IncreasePublicDebt", "IMFProgram", "YearIMFProgram", "PeakNPLs", 
          "NetFiscalCosts", "GrossFiscalCosts", "FiveYearRecovery", "OutputLoss", 
          "AMCType", "NumAMCOpNoNA", "NumAMCCountryNoNA", "NumAMCCountryLagNoNA",
          "F1", "F2", "F3", "F4", "F5")

amcCountryYear <- amcCountryYear[, vars]

# Order data
amcCountryYear <- amcCountryYear[order(amcCountryYear$country),]

# Tidy workspace
rm(amc, dpi, imf, lv, lvAllCrises, uds, wdi, i, vars)

# Save data
write.table(amcCountryYear, file = "/git_repositories/amcData/MainData/amcCountryYear.csv", sep = ",", row.names = FALSE)





