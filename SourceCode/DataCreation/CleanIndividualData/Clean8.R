#############
# Fill in wholes from WDI (gathered with Clean7.R)
# Christopher Gandrud
# 15 February 2013
#############

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
setwd("/git_repositories/amcData/BaseFiles/FillForWDI/")

# Load data
EuroDebtSur <- read.csv("gov_dd_edpt1_1_Data.csv")

# Clean up variable names
EuroDebtSur <- EuroDebtSur[, c(1, 2, 6)]
EuroDebtSur <- plyr::rename(EuroDebtSur, c("TIME" = "year", 
										   "GEO" = "country",
                        "Value" = "CashSurplusDeficit"))
EuroDebtSur$CashSurplusDeficit[EuroDebtSur$CashSurplusDeficit == ":"] 
								<- NA
EuroDebtSur$CashSurplusDeficit <- as.character(
									EuroDebtSur$CashSurplusDeficit)
EuroDebtSur$CashSurplusDeficit <- as.numeric(
									EuroDebtSur$CashSurplusDeficit)

EuroDebtSur$iso2c <- countrycode::countrycode(EuroDebtSur$country,
											  "country.name", "iso2c")
EuroDebtSur <- subset(EuroDebtSur, iso2c != "RE")
EuroDebtSur <- EuroDebtSur[, c(1, 3, 4)]

EuroDT <- data.table::data.table(EuroDebtSur, key = c("iso2c", "year"))
WDIDT <- data.table::data.table(WDIData, key = c("iso2c", "year"))
OutDT <- WDIDT[EuroDT]
OutDT <-OutDT[is.na(CashSurplusDeficit), CashSurplusDeficit:=CashSurplusDeficit.1]

FillIn <- function(D1, D2, var, KeyVar = c("iso2c", "year"))
{
	# Convert data frames to data.table type objects
	D1Temp <- data.table::data.table(D1, key = KeyVar)
	D2Temp <- data.table::data.table(D2, key = KeyVar)
	
	# Merge data.tables
	OutDT <- D1Temp[D2Temp]

	# Fill in missing values from D1 with values from D2
	OutDT <- OutDT[is.na(var), var := paste0(var, ".1")]

	# Clean up and export
	OutDF <- data.frame(OutDT)
  	D1Names <- names(D1)
  	OutNames <- names(OutDF)
	NamesLoc <- match(D1Names, OutNames)
	TempFinal <- OutDT[, NamesLoc]
	TempFinal
}

Test <- FillIn(WDIData, EuroDebtSur, var = "CashSurplusDeficit")



