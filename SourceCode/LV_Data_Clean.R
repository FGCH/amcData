############ 
# Clean Up Laeven & Valencia (2012) Banking Crisis Data
# Christopher Gandrud
# Updated 17 July 2012
############

## Laeven & Valencia (2012) data can be found at: http://www.imf.org/external/pubs/cat/longres.aspx?sk=26015.0
## The data set 'SYSTEMIC BANKING CRISES DATABASE.xlsx' was downloaded. 
## The 'Additional Details' sheet was saved as a .csv file called  'LaeValPolicies.csv' in a folder called LavVal2012.
## I hand deleted the heading rows.

# Load required packages
library(stringr)
library(xtable)
library(countrycode)

# Set working directory and load the data.
setwd("/git_repositories/amcData/BaseFiles/LaeVal2012")

# Input data and transform it into long format
restruct <- read.csv("LavValPolicies.csv")

# Take the matrix transpose to reshape the data from wide to long format. 
restruct <- t(restruct)

# Remove phantom column
restruct <- restruct[, -26]

# Create list of variables and descriptions
Description <- restruct[1, ]

c <- c("Country")

Description <- append(c, values = Description)

Description <- str_trim(Description)

ColNames <- c("country", "CrisisDate", "CrisisDateSystemic", "CurrencyCrisis", "YearCurrencyCrisis", "SovereignCrisis", "YearSovereignCrisis", "CreditBoom", "CreditorRights", "CreditorRightsIndex", "DepositIns", "YearDICreated", "DICoverageLimit", "DICoverageRatio", "DepositFreeze", "DateDepositFreeze", "DurationDepositFreeze", "TimeDepositsFreeze", "BankHoliday", "DateBankHoliday", "DurationBankHoliday", "BankGuaranteee", "DateBankGuaranteeStart", "DateBankGuaranteeEnd", "BankGuaranteeDuration", "BankGuaranteeCoverage", "EmergencyLending", "DateEmergencyLending", "PeakLendingSupport", "BankRestructuring", "Nationalizations", "AssetPurchases", "AMC", "Recap", "RecapCosts", "RecoveryDummy", "RecoveryProceeds", "GovRecapCosts", "DepositorLosses", "DepositorLosesSeverity", "MonetaryPolicyIndex", "AverageReserveChange", "FiscalPolicyIndex", "IncreasePublicDebt", "IMFProgram", "YearIMFProgram", "PeakNPLs", "NetFiscalCosts", "GrossFiscalCosts", "FiveYearRecovery", "OutputLoss")

# Create table and markdown file of variable descriptions.
VarList <- cbind(ColNames, Description)

VarList <- xtable(VarList)

LvVariableTable <- print(VarList, type = "html")

cat("# Variables Lables and Variable Descriptions for Laeven & Valencia's (2012) Restructuring Data\n\n", LvVariableTable, file = "/git_repositories/amcData/MainData/LaevenValenciaVariableDescriptions.md")

# Write new table. I did this to get around a problem correctly naming the reshaped variables.
write.table(restruct, file = "restruct.csv", sep = ",")

# Remove % sign
RestructPercent <- readLines("restruct.csv")
RestructPercent <- gsub("%", "", RestructPercent)
write(RestructPercent, file = "restruct.csv")

restruct <- read.csv("restruct.csv", row.names = NULL, col.names = ColNames)

unlink("restruct.csv")

restruct <- restruct[-1, ]

# Clean up country names and create IMF code indexing
restruct$country <- gsub(".[0-9]", "", restruct$country)
restruct$country <- gsub("\\.", " ", restruct$country)

restruct$imfcode <- countrycode(restruct$country, origin = "country.name", destination = "imf")

# Clean up dates
restruct$CrisisDate[restruct$country == "Sri Lanka"] <- 1989
restruct$CrisisDate <- gsub("1988", "Jan-88", restruct$CrisisDate)
restruct$CrisisDate <- gsub("1989", "Jan-89", restruct$CrisisDate)
restruct$CrisisDate <- paste(restruct$CrisisDate, "-01", sep = "")
restruct$CrisisDate <- as.Date(restruct$CrisisDate, "%b-%y-%d")

restruct$year <- as.numeric(str_extract(restruct$CrisisDate, "[0-9][0-9][0-9][0-9]"))

# Clean up DICoverageLimit variable values
restruct$DICoverageLimit <- gsub(",", "", restruct$DICoverageLimit)
restruct$DICoverageLimit <- gsub("-", "", restruct$DICoverageLimit)
restruct$DICoverageLimit <- gsub("Unlimited", "Full", restruct$DICoverageLimit)

# Recode AMC variable 
restruct$AMC <- as.numeric(restruct$AMC)

restruct$AMCType[restruct$AMC == 1] <- "None"
restruct$AMCType[restruct$AMC == 2] <- "Centralised"
restruct$AMCType[restruct$AMC == 3] <- "Decentralised"

restruct$AMC[restruct$AMC == 1] <- 0
restruct$AMC[restruct$AMC > 0] <- 1

# Add Changes to the data file and Create Notes of the changes

## Brazil PROER classify as AMC
restruct$AMC[restruct$country == "Brazil" & restruct$year == 1994] <- 1
restruct$AMCType[restruct$country == "Brazil" & restruct$year == 1994] <- "Decentralised"

BrazilAMC <- c("- Brazil's PROER was added as a **AMC** and classified as 'Decentralised' in the **AMCType** variable. It was created in 1996")

cat("# Notes on changes made to Laeven and Valencia (2012) data\n\n", BrazilAMC, file = "/git_repositories/amcData/MainData/LaevenValenciaVariableChanges.md")


# Save cleaned data file
write.table(restruct, file = "/git_repositories/amcData/MainData/amcData.csv", sep = ",")







