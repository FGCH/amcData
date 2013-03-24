#############
# Fill in holes from WDI (gathered with Clean7.R)
# Christopher Gandrud
# 24 March 2013
#############

# Load packages
library(countrycode)
library(xtable)
library(DataCombine) # Install using: devtools::install_github("DataCombine", "christophergandrud")

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

#### Merge with data from the Asian Development Bank ####
# Data downloaded from: https://sdbs.adb.org
# Variable Name: Overall budgetary surplus/deficit, as % of GDP
ADBDebtSur <- read.csv("ADBCashSurDef.csv")

# Clean up
ADBDebtSur <- ADBDebtSur[, c(-1, -2, -4, -5)]
ADBDebtSur <- reshape2::melt(ADBDebtSur, id.vars = c("country"))
names(ADBDebtSur) <- c("country", "year", "ADBOveralDeficit")
ADBDebtSur$year <- as.numeric(gsub("X", "", ADBDebtSur$year))
ADBDebtSur$ADBOveralDeficit[ADBDebtSur$ADBOveralDeficit == "... "] <- NA
ADBDebtSur$ADBOveralDeficit <- as.numeric(ADBDebtSur$ADBOveralDeficit)
ADBDebtSur <- ADBDebtSur[order(ADBDebtSur$country, ADBDebtSur$year), ]
ADBDebtSur$iso2c <- countrycode(ADBDebtSur$country, "country.name", "iso2c")
ADBDebtSur <- ADBDebtSur[, c("iso2c", "year", "ADBOveralDeficit")]
ADBDebtSur <- ADBDebtSur[!duplicated(ADBDebtSur[, c("iso2c", "year")]), ]

# Use ADBDebtSur to fill in WDI CashSurplusDeficit
WDIComb <- FillIn(WDIComb, ADBDebtSur, Var1 = "CashSurplusDeficit",
				  Var2 = "ADBOveralDeficit")

#### Merge CentGovDebt with data from the OCED ####
# Data downloaded from: http://stats.oecd.org/
# Variable Name: Total central government debt (% GDP)
OECDDebt <- read.csv("OECDCentGovDebt.csv")

# Clean up
OECDDebt <- reshape2::melt(OECDDebt, id.vars = c("country"))
names(OECDDebt) <- c("country", "year", "CentDebt")
OECDDebt$year <- as.numeric(gsub("X", "", OECDDebt$year))
OECDDebt$CentDebt[OECDDebt$CentDebt == ".."] <- NA
OECDDebt$CentDebt <- as.numeric(OECDDebt$CentDebt)
OECDDebt <- OECDDebt[order(OECDDebt$country, OECDDebt$year), ]
OECDDebt$iso2c <- countrycode(OECDDebt$country, "country.name", "iso2c")
OECDDebt <- OECDDebt[, c("iso2c", "year", "CentDebt")]

# Use CentDebt to fill in WDI CentGovDebt
WDIComb <- FillIn(WDIComb, OECDDebt, Var1 = "CentGovDebt", Var2 = "CentDebt")

#### Create Variable descriptions ####

ColNames <- c("CashSurplusDeficit", "CentGovDebt",  "IMFCreditsGDP", "PortfolioEquityGDP", "ShortExternDebtAllGDP", "ExternPrivateDebtGDP", "ExternPublicDebtGDP", "ExternDebtTotalGDP", "TotalReservesGDP")

Description <- c("WDI variable updated with data from Eurostat, Hallerberg LA, and Asian Development Bank.", 
	"WDI variable updated with data from the OECD",
	"Transformed as percent GDP using WDI GDPCurrentUSD",
	"Transformed as percent GDP using WDI GDPCurrentUSD",
	"Transformed as percent GDP using WDI GDPCurrentUSD",
	"Transformed as percent GDP using WDI GDPCurrentUSD",
	"Transformed as percent GDP using WDI GDPCurrentUSD",
	"Transformed as percent GDP using WDI GDPCurrentUSD",
	"Transformed as percent GDP using WDI GDPCurrentUSD")

Varlist <- cbind(ColNames, Description)
Varlist <- xtable(Varlist)
WDIFillTable <- print(Varlist, type = "html")

cat("# World Bankd Development Indicator variable changes.",
	WDIFillTable, file = "/git_repositories/amcData/MainData/VariableDescriptions/WDIVariableTransformations.md")


#### Save File ####
write.table(WDIComb, file = "/git_repositories/amcData/MainData/CleanedPartial/WDIDataProcessed.csv", sep = ",")

