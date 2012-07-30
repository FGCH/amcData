############ 
# Merge Cleaned Up AMC Database Data (Crisis Only Version)
# Christopher Gandrud
# Updated 30 July 2012
############

# Load required packages
library(reshape)

## ID variable is imfcode

setwd("/git_repositories/amcData/MainData/CleanedPartial/")

# Load data
lv <- read.csv("LvData.csv") 
uds <- read.csv("UdsData.csv")
dpi <- read.csv("DpiData.csv")
wdi <- read.csv("WDIData.csv")

# Remove missing id variables
lv <- lv[!is.na(lv$imfcode), ]
uds <- uds[!is.na(uds$imfcode), ]
dpi <- dpi[!is.na(dpi$imfcode), ]
wdi <- wdi[!is.na(wdi$imfcode), ]


amcCrisisYear <- merge(lv, uds, union("imfcode", "year"))

amcCrisisYear <- merge(amcCrisisYear, dpi, union("imfcode", "year"))

amcCrisisYear <- merge(amcCrisisYear, wdi, union("imfcode", "year"))

amcCrisisYear <- rename(amcCrisisYear, c(country.x = "country"))
amcCrisisYear <- rename(amcCrisisYear, c(year = "CrisisYear"))

# Clean up merged
vars <- c("imfcode", "CrisisYear", "country", "CrisisDate", "CrisisDateSystemic", 
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
            "yrcurnt", "ElectionYear", "govfrac", "execrlc", "UDS", "GDPperCapita", "NPLwdi", "CurrentAccount")

amcCrisisYear <- amcCrisisYear[, vars]

amcCrisisYear <- amcCrisisYear[order(amcCrisisYear$country),]

write.table(amcCrisisYear, file = "/git_repositories/amcData/MainData/amcCrisisYear.csv", sep = ",")