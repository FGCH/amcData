#############
# Fill in wholes from WDI (gathered with Clean7.R)
# Christopher Gandrud
# 16 February 2013
#############

# Load packages
library(countrycode)

# Load FillIn function
devtools::source_gist("4959237")

# Load data created from Clean7.R
WDIData <- read.csv("/git_repositories/amcData/MainData/CleanedPartial/WDIData.csv")

#### Transform variables as percentage of GDP ####
# Percent GDP creation function
PerGDP <- function(x){
	(x/WDIData$GDPCurrentUSD) * 100
}

# Assume IMFCredits variable is complete, i.e. NAs are actually 0
WDIData$IMFCredits[is.na(WDIData$IMFCredits)] <- 0

WDIData$IMFCreditsGDP <- PerGDP(WDIData$IMFCredits)
WDIData$PortfolioEquityGDP <- PerGDP(WDIData$PortfolioEquity)
WDIData$ShortExternDebtAllGDP <- PerGDP(WDIData$ShortExternDebtAll)
WDIData$ExternPrivateDebtGDP <- PerGDP(WDIData$ExternPrivateDebt)
WDIData$ExternPublicDebtGDP <- PerGDP(WDIData$ExternPublicDebt)
WDIData$ExternDebtTotalGDP <- PerGDP(WDIData$ExternDebtTotal)
WDIData$TotalReservesGDP <- PerGDP(WDIData$TotalReserves)

#### Merge with Eurostat Data for Government Debt/Surplus ####
# Data downloaded from: http://epp.eurostat.ec.europa.eu/portal/page/portal/statistics/search_database
# Variable Name: Government Debt/Surplus
setwd("/git_repositories/amcData/BaseFiles/FillForWDI/")

# Load data
EuroDebtSur <- read.csv("gov_dd_edpt1_1_Data.csv")

# Clean up variable names
EuroDebtSur <- EuroDebtSur[, c(1, 2, 6)]
EuroDebtSur <- plyr::rename(EuroDebtSur, c("TIME" = "year", 
										   "GEO" = "country",
                        "Value" = "CashSurplusDeficit"))
EuroDebtSur$CashSurplusDeficit[EuroDebtSur$CashSurplusDeficit == ":"] <- NA
EuroDebtSur$CashSurplusDeficit <- as.character(EuroDebtSur$CashSurplusDeficit)
EuroDebtSur$CashSurplusDeficit <- as.numeric(EuroDebtSur$CashSurplusDeficit)

EuroDebtSur$iso2c <- countrycode(EuroDebtSur$country, "country.name", "iso2c")
EuroDebtSur <- subset(EuroDebtSur, iso2c != "RE")
EuroDebtSur <- EuroDebtSur[, c(1, 3, 4)]

# Use EuroDebtSur to fill in WDI CashSurplusDeficit
WDIComb <- FillIn(WDIData, EuroDebtSur, Var1 = "CashSurplusDeficit")

#### Merge with Latin American data gathered by Mark Hallerberg
# Originally the data was from the IMF
LADebtSur <- read.csv("HallerbergLA.csv")

# Clean up
LADebtSur$iso2c <- countrycode(LADebtSur$country, "country.name", "iso2c")
LADebtSur <- LADebtSur[, c("iso2c", "year", "cashsurdefimf")]

# Use LADebtSur to fill in WDI CashSurplusDeficit
WDIComb <- FillIn(WDIComb, LADebtSur, Var1 = "CashSurplusDeficit", 
				  Var2 = "cashsurdefimf")


#### Save File ####
# write.table(wdi, file = "/git_repositories/amcData/MainData/CleanedPartial/WDIDataProcessed.csv", sep = ",")

