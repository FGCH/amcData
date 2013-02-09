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
wdi <- WDI(country = "all", indicator = c("NY.GDP.PCAP.KD", "FB.AST.NPER.ZS", "BN.CAB.XOKA.GD.ZS", "DT.DOD.DIMF.CD"), start = 1980)

# Clean up
wdi$imfcode <- countrycode(wdi$iso2c, origin = "iso2c", destination = "imf")

wdi <- rename(wdi, c(NY.GDP.PCAP.KD = "GDPperCapita", 
                     FB.AST.NPER.ZS = "NPLwdi", 
                     BN.CAB.XOKA.GD.ZS = "CurrentAccount",
                     DT.DOD.DIMF.CD = "IMFCredits"
                     ))

wdi <- wdi[, 3:8]

# Create variable description
ColNames <- names(wdi[, 2:5])
Description <- c("GDP per capita (constant 2000 US$)", "Bank nonperforming loans to total gross loans (%)", "Current account balance (% of GDP)", "Use of IMF credit (DOD, current US$)")
Source <- c("World Bank Development Indicators (February 2013)")

VarList <- cbind(ColNames, Description, Source)

VarList <- xtable(VarList)

DpiVariableTable <- print(VarList, type = "html")

cat("# Variable Label and Variable Description for World Bank Development Indictors\n See: http://data.worldbank.org/", DpiVariableTable, file = "/git_repositories/amcData/MainData/VariableDescriptions/WDIVariableDescription.md")

# Save file
write.table(wdi, file = "/git_repositories/amcData/MainData/CleanedPartial/WDIData.csv", sep = ",")