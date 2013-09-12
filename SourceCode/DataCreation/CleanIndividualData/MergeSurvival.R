############ 
# Merge Cleaned Up AMC Database Data (Repeated Survival Time Version)
# Christopher Gandrud
# Updated 12 September 2013
############

# Load required packages
require(reshape)
require(gdata)
require(countrycode)
require(DataCombine)

## ID variable is imfcode

setwd("/git_repositories/amcData/MainData/CleanedPartial/")

# Load data
lv <- read.csv("LvData.csv") 
lvAllCrises <- read.csv("LVCrisisDummyData.csv")
uds <- read.csv("UdsData.csv")
dpi <- read.csv("DpiData.csv")
amc <- read.csv("AMCFull.csv")
wdi <- read.csv("WDIDataProcessed.csv")
imf <- read.csv("IMFData.csv")
own <- read.csv("CvHBankOwners.csv")
inqual <- read.csv("InsQualKuncic.csv")
mona <- read.csv("IMF_MONA.csv")

# Remove missing id variables
lv <- lv[!is.na(lv$imfcode), ]
lv <- lv[!is.na(lv$imfcode), ]
uds <- uds[!is.na(uds$imfcode), ]
dpi <- dpi[!is.na(dpi$imfcode), ]
wdi <- wdi[!is.na(wdi$imfcode), ]
imf <- imf[!is.na(imf$imfcode), ]
own <- own[!is.na(own$imfcode), ]
inqual <- inqual[!is.na(inqual$imfcode), ]

# Create Crisis 5 year data (crisis year + 4), LV Constricted Crises
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
rm(TempYear1, TempYear2, TempYear3, TempYear4, i, temp)

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

# Merge CvH Bank Ownership Data
amcCountryYear <- merge(amcCountryYear, own, union("imfcode", "year"), all = TRUE)

# Merge Kuncic Institutional Quality Data
amcCountryYear <- merge(amcCountryYear, inqual, union("imfcode", "year"), all = TRUE)

# Merge with LV crisis year dummies
## Remove old AMCType variable from LV
amcCountryYear <- remove.vars(amcCountryYear, names = "CurrencyCrisis")

amcCountryYear <- merge(amcCountryYear, lvAllCrises, union("imfcode", "year"), all = TRUE)
amcCountryYear <- remove.vars(amcCountryYear, names = "country.y")
amcCountryYear <- rename(amcCountryYear, c(country.x = "country"))

# Change missing to 0 for crisis year dummies
vars <- c("SystemicCrisis",
          "CurrencyCrisis",
          "SovereignDefault",
          "SovereignDebtRestructuring"
          )

for (i in vars){
  amcCountryYear[[i]][is.na(amcCountryYear[[i]])] <- 0
}

# Merge MONA Data
amcCountryYear <- merge(amcCountryYear, mona, union("imfcode", "year"), all = TRUE)
amcCountryYear$IMF.AMC[is.na(amcCountryYear$IMF.AMC) & amcCountryYear$year >= 1993] <- 0 # data only available from 1993

# Create two year lag variable for IMF.AMC
amcCountryYear <- slide(amcCountryYear, Var = "IMF.AMC", GroupVar = "imfcode", slideBy = 1)
amcCountryYear <- slide(amcCountryYear, Var = "IMF.AMC", GroupVar = "imfcode", slideBy = 2)
amcCountryYear$IMF.AMC <- amcCountryYear$IMF.AMC + amcCountryYear$IMF.AMC1 + amcCountryYear$IMF.AMC2
amcCountryYear$IMF.AMC1 <- NULL
amcCountryYear$IMF.AMC2 <- NULL

# Clean up merge
amcCountryYear <- amcCountryYear[amcCountryYear$year >= 1980, ]
amcCountryYear <- amcCountryYear[!is.na(amcCountryYear$year), ]

amcCountryYear <- amcCountryYear[!duplicated(amcCountryYear[, 1:2], fromLast=FALSE), ]

# Remove old country name (missing for some data sets)
amcCountryYear <- remove.vars(amcCountryYear, names = "country")

# Add iso-2 codes & Country Name
amcCountryYear$ISOCode <- countrycode(amcCountryYear$imfcode, origin = "imf", destination = "iso2c")
amcCountryYear$country <- countrycode(amcCountryYear$imfcode, origin = "imf", destination = "country.name")

vars <- c("country", "ISOCode", "imfcode", "year", "UDS", "polity2", "yrcurnt", "govfrac", "execrlc", "checks", "polariz",
          "ElectionYear", "SystemicCrisis", "CurrencyCrisis", "SovereignDefault", 
          "SovereignDebtRestructuring", "CvHOwnPerc", "legal_abs", "political_abs", "economic_abs", "GDPCurrentUSD", "GDPperCapita", "CapToAssetswdi", "NPLwdi", "CreditInfo",
          "DomesticCredit", "CreditBurCoverange", "CurrentAccount", "IMFCreditsGDP", "PortfolioEquityGDP", 
          "CashSurplusDeficit", "ClaimsOnGov", "CentGovDebt", "ShortExternDebtAllGDP", "ExternPrivateDebtGDP", "ExternPublicDebtGDP", 
          "ExternDebtTotalGDP", "TotalReservesGDP",
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
          "IncreasePublicDebt", "IMFProgram", "YearIMFProgram", "IMF.AMC", "PeakNPLs", 
          "NetFiscalCosts", "GrossFiscalCosts", "FiveYearRecovery", "OutputLoss", 
          "AMCType", "AMCAnyCreated", "NumAMCOpNoNA", "NumAMCCountryNoNA", 
          "NumAMCCountryLagNoNA", "F1", "F2", "F3", "F4", "F5")

amcCountryYear <- amcCountryYear[, vars]

amcCountryYear<- amcCountryYear[!is.na(amcCountryYear$imfcode),]

# Order data
amcCountryYear <- amcCountryYear[order(amcCountryYear$country),]

# Tidy workspace
rmExcept("amcCountryYear")

# Save data
write.table(amcCountryYear, file = "/git_repositories/amcData/MainData/amcCountryYear.csv", sep = ",", row.names = FALSE)





