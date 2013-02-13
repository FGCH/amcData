############ 
# Download and Cean Up World Bank Development Indicator data
# Christopher Gandrud
# Updated 9 February 2013
############

# Load required packages
library(WDI)
library(countrycode)
library(reshape)
library(xtable)

# Download select indicators from the World Bank's website. Indicators include:
## GDP per capita (constant 2000 US$)
## Bank nonperforming loans to total gross loans (%)
## Current account balance (% of GDP)
wdi <- WDI(country = "all", indicator = c("NY.GDP.MKTP.CD", "NY.GDP.PCAP.KD", "FB.AST.NPER.ZS", "BN.CAB.XOKA.GD.ZS", "DT.DOD.DIMF.CD", "BX.PEF.TOTL.CD.WD", "GC.BAL.CASH.GD.ZS", "FM.AST.CGOV.ZG.M3"), start = 1980)

# Clean up
wdi$imfcode <- countrycode(wdi$iso2c, origin = "iso2c", destination = "imf")

wdi <- rename(wdi, c(NY.GDP.MKTP.CD = "GDPCurrentUSD",
					 NY.GDP.PCAP.KD = "GDPperCapita", 
                     FB.AST.NPER.ZS = "NPLwdi", 
                     BN.CAB.XOKA.GD.ZS = "CurrentAccount",
                     DT.DOD.DIMF.CD = "IMFCredits",
                     BX.PEF.TOTL.CD.WD = "PortfolioEquity",
                     GC.BAL.CASH.GD.ZS = "CashSurplusDeficit",
                     FM.AST.CGOV.ZG.M3 = "ClaimsOnGov"
                     ))

wdi <- wdi[, 3:12]

# Create variable description
ColNames <- names(wdi[, 2:9])
Description <- c("GDP (current US$)", "GDP per capita (constant 2000 US$)", "Bank nonperforming loans to total gross loans (%)", "Current account balance (% of GDP)", "Use of IMF credit (DOD, current US$)", "Portfolio equity, net inflows (BoP, current US$)", "Cash surplus/deficit (% of GDP)", "Claims on central government (annual growth as % of broad money)")
Source <- c("World Bank Development Indicators (February 2013)")

VarList <- cbind(ColNames, Description, Source)

VarList <- xtable(VarList)

DpiVariableTable <- print(VarList, type = "html")

cat("# Variable Label and Variable Description for World Bank Development Indictors\n See: http://data.worldbank.org/", DpiVariableTable, file = "/git_repositories/amcData/MainData/VariableDescriptions/WDIVariableDescription.md")

# Save file
write.table(wdi, file = "/git_repositories/amcData/MainData/CleanedPartial/WDIData.csv", sep = ",")