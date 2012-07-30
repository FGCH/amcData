############ 
# Download and Cean Up World Bank Development Indicator data
# Christopher Gandrud
# Updated 30 July 2012
############

# Load required packages
library(WDI)
library(countrycode)
library(reshape)

# Download select indicators from the World Bank's website. Indicators include:
## GDP per capita (constant 2000 US$)
## Bank nonperforming loans to total gross loans (%)
## Current account balance (% of GDP)
wdi <- WDI(country = "all", indicator = c("NY.GDP.PCAP.KD", "FB.AST.NPER.ZS", "BN.CAB.XOKA.GD.ZS"), start = 1980, end = 2011)

# Clean up
wdi$imfcode <- countrycode(wdi$iso2c, origin = "iso2c", destination = "imf")

wdi <- rename(wdi, c(NY.GDP.PCAP.KD = "GDPperCapita", 
                     FB.AST.NPER.ZS = "NPLwdi", 
                     BN.CAB.XOKA.GD.ZS = "CurrentAccount"
                     ))

wdi <- wdi[, 3:7]

# Create variable description
ColNames <- names(wdi[, 2:4])
Description <- c("GDP per capita (constant 2000 US$)", "Bank nonperforming loans to total gross loans (%)", "Current account balance (% of GDP)")
Source <- c("World Bank Development Indicators (July 2012")

VarList <- cbind(ColNames, Description, Source)

VarList <- xtable(VarList)

DpiVariableTable <- print(VarList, type = "html")

cat("# Variable Label and Variable Description for World Bank Development Indictors\n See: http://data.worldbank.org/", DpiVariableTable, file = "/git_repositories/amcData/MainData/VariableDescriptions/WDIVariableDescription.md")

# Save file
write.table(wdi, file = "/git_repositories/amcData/MainData/CleanedPartial/WDIData.csv", sep = ",")