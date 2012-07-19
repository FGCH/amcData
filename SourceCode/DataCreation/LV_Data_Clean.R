############ 
# Clean Up Laeven & Valencia (2012) Banking Crisis Data
# Christopher Gandrud
# Updated 19 July 2012
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

cat("# Variables Lables and Variable Descriptions for Laeven & Valencia's (2012) Restructuring Data\n ### See: <http://www.imf.org/external/pubs/cat/longres.aspx?sk=26015.0>\n\n", LvVariableTable, file = "/git_repositories/amcData/MainData/VariableDescriptions/LaevenValenciaVariableDescriptions.md")

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

# Sweden reclassified as decentralised
restruct$AMCType[restruct$country == "Sweden" & restruct$year == 1991] <- "Decentralised"

## Brazil PROER classify as AMC
restruct$AMC[restruct$country == "Brazil" & restruct$year == 1994] <- 3
restruct$AMCType[restruct$country == "Brazil" & restruct$year == 1994] <- "Decentralised"

restruct$AMC[restruct$AMC > 1] <- 2

restruct$AMC <- factor(restruct$AMC, labels = c("NoAMC", "AMCCreated"))

# Add Changes to the data file and Create Notes of the changes

Notes <- c("- Brazil's PROER was added as a **AMC** and classified as 'Decentralised' in the **AMCType** variable. It was created in 1996. More details can be found the Banco Central Do Brazil's website <http://www.bcb.gov.br/?PROEREN>.", "- Sweden 1991 reclassified as having decentralised AMCs. See: <http://www.clevelandfed.org/research/PolicyDis/pdp21.pdf?WT.oss=Import+Prices&WT.oss_r=1730>")

cat("\n\n# Notes on changes made to Laeven and Valencia (2012) data\n\n", Notes, file = "/git_repositories/amcData/MainData/VariableDescriptions/LaevenValenciaVariableDescriptions.md", append = TRUE)


# Save cleaned data file
write.table(restruct, file = "/git_repositories/amcData/MainData/CleanedPartial/LvData.csv", sep = ",")







