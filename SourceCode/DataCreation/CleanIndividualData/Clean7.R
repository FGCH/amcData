############ 
# Download and Cean Up World Bank Development Indicator data
# Christopher Gandrud
# Updated 16 February 2013
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
wdi <- WDI(country = "all", indicator = c("NY.GDP.MKTP.CD", "NY.GDP.PCAP.KD", "FB.BNK.CAPA.ZS", "FB.AST.NPER.ZS", "IC.CRD.INFO.XQ", 
										  "FS.AST.DOMS.GD.ZS", "IC.CRD.PRVT.ZS", "BN.CAB.XOKA.GD.ZS", 
										  "DT.DOD.DIMF.CD", "BX.PEF.TOTL.CD.WD", "GC.BAL.CASH.GD.ZS", "FM.AST.CGOV.ZG.M3", 
										  "GC.DOD.TOTL.GD.ZS", "DT.DOD.DSTC.CD", "DT.DOD.DPNG.CD", "DT.DOD.DPPG.CD",
										  "DT.DOD.DECT.CD", "FI.RES.TOTL.CD"
										  ), 
			start = 1980, end = 2012)

# Clean up
wdi$imfcode <- countrycode(wdi$iso2c, origin = "iso2c", destination = "imf")

wdi <- rename(wdi, c(NY.GDP.MKTP.CD = "GDPCurrentUSD",
					 NY.GDP.PCAP.KD = "GDPperCapita",
					 FB.BNK.CAPA.ZS = "CapToAssetswdi", 
                     FB.AST.NPER.ZS = "NPLwdi", 
                     IC.CRD.INFO.XQ = "CreditInfo",
                     FS.AST.DOMS.GD.ZS = "DomesticCredit",
                     IC.CRD.PRVT.ZS = "CreditBurCoverange",
                     BN.CAB.XOKA.GD.ZS = "CurrentAccount",
                     DT.DOD.DIMF.CD = "IMFCredits",
                     BX.PEF.TOTL.CD.WD = "PortfolioEquity",
                     GC.BAL.CASH.GD.ZS = "CashSurplusDeficit",
                     FM.AST.CGOV.ZG.M3 = "ClaimsOnGov",
                     GC.DOD.TOTL.GD.ZS = "CentGovDebt",
                     DT.DOD.DSTC.CD = "ShortExternDebtAll",
                     DT.DOD.DPNG.CD = "ExternPrivateDebt",
                     DT.DOD.DPPG.CD = "ExternPublicDebt",
                     DT.DOD.DECT.CD = "ExternDebtTotal",
                     FI.RES.TOTL.CD = "TotalReserves"
                     ))

# wdi <- wdi[, 3:22]

#### Create variable description ####
ColNames <- names(wdi[, 4:21])

Description <- c("GDP (current US$)", 
				 "GDP per capita (constant 2000 US$)", 
				 "Bank capital to assets ratio (%)",
				 "Bank nonperforming loans to total gross loans (%)", 
				 "Credit depth of information index (0=low to 6=high)",
				 "Domestic credit provided by banking sector (% of GDP)",
				 "Private credit bureau coverage (% of adults)",
				 "Current account balance (% of GDP)", 
				 "Use of IMF credit (DOD, current US$)", "Portfolio equity, net inflows (BoP, current US$)", 
				 "Cash surplus/deficit (% of GDP)", "Claims on central government (annual growth as % of broad money)", 
				 "Central government debt, total (% of GDP)", "External debt stocks, short-term (DOD, current US$)", 
				 "External debt stocks, private nonguaranteed (PNG) (DOD, current US$)", 
				 "External debt stocks, public and publicly guaranteed (PPG) (DOD, current US$)", 
				 "External debt stocks, total (DOD, current US$)",
				 "Total reserves (includes gold, current US$)"
				 )

Source <- c("World Bank Development Indicators (February 2013)")

VarList <- cbind(ColNames, Description, Source)

VarList <- xtable(VarList)

WDIVariableTable <- print(VarList, type = "html")

cat("# Variable Label and Variable Description for World Bank Development Indictors\n See: http://data.worldbank.org/", WDIVariableTable, file = "/git_repositories/amcData/MainData/VariableDescriptions/WDIVariableDescription.md")

# Save file
write.table(wdi, file = "/git_repositories/amcData/MainData/CleanedPartial/WDIData.csv", sep = ",")