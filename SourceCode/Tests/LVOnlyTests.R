############ 
# Clean Up Laeven & Valencia (2012) Banking Crisis Data and Merge in Political
# Christopher Gandrud
# Updated 28 January 2014
############

# Load packages
library(DataCombine)
library(foreign)

# Load data
LV <- read.csv("/git_repositories/amcData/MainData/CleanedPartial/LvData.csv")

# Basic Clean
LV <- MoveFront(LV, c('imfcode', 'year'))


# Merge with key variables 
Others <- read.csv("/git_repositories/amcData/MainData/amcCountryYear.csv")
KeepVars <- c('imfcode', 'year', 'polity2', 'UDS', 'percent1', 'percentl', 'prtyin',
              'economic_abs', 'legal_abs', 'GDPperCapita', 'GDPCurrentUSD',
              'DomesticCredit', 'TradeOpen', 'ClaimsOnGov', 'CentGovDebt',
              'ExternDebtTotalGDP', 'IMF.AMC', 'W')

SlimOthers <- Others[, KeepVars]

Comb <- merge(LV, SlimOthers, by = c('imfcode', 'year'), all.x = TRUE)

write.dta(Comb, "~/Dropbox/AMCProject/LandV_2012_MergedData.dta")
