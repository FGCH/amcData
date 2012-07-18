############ 
# Merge Cleaned Up AMC Database Data
# Christopher Gandrud
# Updated 17 July 2012
############

# Load required packages
library(reshape)

## ID variable is imfcode

setwd("/git_repositories/amcData/MainData/CleanedPartial/")

# Load data
lv <- read.csv("LvData.csv") 
uds <- read.csv("UdsData.csv")
dpi <- read.csv("DpiData.csv")

amcData <- merge(lv, uds, union("imfcode", "year"))
amcData <- merge(amcData, dpi, union("imfcode", "year"))

# Clean up merged
vars <- c("imfcode", "year", "country.x", "CrisisDate", "CrisisDateSystemic", 
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

amcData <- rename(amcData, c(country.x = "country")) 

amcData <- amcData[order(amcData$country),]

write.table(amcData, file = "/git_repositories/amcData/MainData/amcData.csv", sep = ",")