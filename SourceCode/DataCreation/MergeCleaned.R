############ 
# Merge Cleaned Up AMC Database Data
# Christopher Gandrud
# Updated 25 July 2012
############

# Load required packages
library(reshape)

## ID variable is imfcode

setwd("/git_repositories/amcData/MainData/CleanedPartial/")

# Load data
amc <- read.csv("amcStartData.csv")
lv <- read.csv("LvData.csv") 
uds <- read.csv("UdsData.csv")
dpi <- read.csv("DpiData.csv")

amcData <- merge(amc, lv, by = c("imfcode", "CrisisYear"), all = TRUE)
  # Clean up
  amcData <- amcData[, -3]
  amcData <- rename(amcData, c(country.y = "country"))

amcData <- merge(amcData, uds, union("imfcode", "year"), all = TRUE)
  amcData <- rename(amcData, c(country.x = "country"))

amcData <- merge(amcData, dpi, union("imfcode", "year"))
  amcData <- rename(amcData, c(country.x = "country"), all = TRUE)


# Clean up merged
vars <- c("imfcode", "year", "country", "CrisisYear", "CrisisDate", "CrisisDateSystemic", 
            "CurrencyCrisis", "YearCurrencyCrisis", "SovereignCrisis", "YearSovereignCrisis", 
            "CreditBoom", "CreditorRights", "CreditorRightsIndex", "DepositIns", 
            "YearDICreated", "DICoverageLimit", "DICoverageRatio", "DepositFreeze", 
            "DateDepositFreeze", "DurationDepositFreeze", "TimeDepositsFreeze", 
            "BankHoliday", "DateBankHoliday", "DurationBankHoliday", "BankGuaranteee", 
            "DateBankGuaranteeStart", "DateBankGuaranteeEnd", "BankGuaranteeDuration", 
            "BankGuaranteeCoverage", "EmergencyLending", "DateEmergencyLending", 
            "PeakLendingSupport", "BankRestructuring", "Nationalizations", 
            "AssetPurchases", "AMC", "AMCType", "Recap", "RecapCosts", "RecoveryDummy", 
            "RecoveryProceeds", "GovRecapCosts", "DepositorLosses", "DepositorLosesSeverity", 
            "MonetaryPolicyIndex", "AverageReserveChange", "FiscalPolicyIndex", 
            "IncreasePublicDebt", "IMFProgram", "YearIMFProgram", "PeakNPLs", 
            "NetFiscalCosts", "GrossFiscalCosts", "FiveYearRecovery", "OutputLoss", 
            "yrcurnt", "ElectionYear", "govfrac", "execrlc", "UDS")

amcData <- amcData[, vars]

amcData <- amcData[order(amcData$country),]

write.table(amcData, file = "/git_repositories/amcData/MainData/amcData.csv", sep = ",")