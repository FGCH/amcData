############ 
# Clean Up Laeven & Valencia (2012) Banking Crisis Years
# Christopher Gandrud
# Updated 1 August 2012
############

# Load packages
library(reshape)
library(stringr)
library(countrycode)
library(xtable)


# Load data
## Laeven & Valencia (2012) data can be found at: http://www.imf.org/external/pubs/cat/longres.aspx?sk=26015.0
## The data set 'SYSTEMIC BANKING CRISES DATABASE.xlsx' was downloaded. 
## The 'Crisis Years' sheet was saved as a .csv file
crisis <- read.csv("/git_repositories/amcData/BaseFiles/LaeVal2012/LVAllCrises.csv")

# Rename variables
crisis <- rename(crisis, c(Country = "country", 
                           Systemic.Banking.Crisis..starting.date. = "SystemicCrisis", 
                           Currency.Crisis = "CurrencyCrisis", 
                           Sovereign.Debt.Crisis..default.date. = "SovereignDefault", 
                           Sovereign.Debt.Restructuring..year. = "SovereignDebtRestructuring"
                           ))

# Clean up country names
crisis$country <- gsub("[\x80-\xFF]", "", x= crisis$country)

crisis <- crisis[-1, ]

#### Split Systemic Crisis into individual country years ####
crisis$SystemicCrisis <- gsub(",", "", x= crisis$SystemicCrisis)

cy1 <- str_extract(crisis$SystemicCrisis, "^[1-2][0-9][0-9][0-9]")
  cy1 <- data.frame(cbind(crisis$country, cy1))
  cy1 <- rename(cy1, c(V1 = "country", cy1 = "SystemicCrisis"))
  cy1 <- cy1[!is.na(cy1$SystemicCrisis),]

cy2All <- str_extract(crisis$SystemicCrisis, "^[1-2][0-9][0-9][0-9] [1-2][0-9][0-9][0-9]")
  cy2 <- str_extract(cy2All, "[1-2][0-9][0-9][0-9]$")
  rm(cy2All)
  cy2 <- data.frame(cbind(crisis$country, cy2))
  cy2 <- rename(cy2, c(V1 = "country", cy2 = "SystemicCrisis"))
  cy2 <- cy2[!is.na(cy2$SystemicCrisis),]

cy3All <- str_extract(crisis$SystemicCrisis, "^[1-2][0-9][0-9][0-9] [1-2][0-9][0-9][0-9] [1-2][0-9][0-9][0-9]")
  cy3 <- str_extract(cy3All, "[1-2][0-9][0-9][0-9]$")
  rm(cy3All)
  cy3 <- data.frame(cbind(crisis$country, cy3))
  cy3 <- rename(cy3, c(V1 = "country", cy3 = "SystemicCrisis"))
  cy3 <- cy3[!is.na(cy3$SystemicCrisis),]

cy4All <- str_extract(crisis$SystemicCrisis, "^[1-2][0-9][0-9][0-9] [1-2][0-9][0-9][0-9] [1-2][0-9][0-9][0-9] [1-2][0-9][0-9][0-9]")
  cy4 <- str_extract(cy4All, "[1-2][0-9][0-9][0-9]$")
  rm(cy4All)
  cy4 <- data.frame(cbind(crisis$country, cy4))
  cy4 <- rename(cy4, c(V1 = "country", cy4 = "SystemicCrisis"))
  cy4 <- cy4[!is.na(cy4$SystemicCrisis),]

CrisisIndv <- rbind(cy1, cy2, cy3, cy4)
CrisisIndv <- CrisisIndv[order(CrisisIndv$country), ]
CrisisIndv$year <- CrisisIndv$SystemicCrisis
CrisisIndv$SystemicCrisis <- 1

#### Split Currency Crisis into individual country years ####
crisis$CurrencyCrisis <- gsub(",", "", x= crisis$CurrencyCrisis)

cy1 <- str_extract(crisis$CurrencyCrisis, "^[1-2][0-9][0-9][0-9]")
  cy1 <- data.frame(cbind(crisis$country, cy1))
  cy1 <- rename(cy1, c(V1 = "country", cy1 = "CurrencyCrisis"))
  cy1 <- cy1[!is.na(cy1$CurrencyCrisis),]

cy2All <- str_extract(crisis$CurrencyCrisis, "^[1-2][0-9][0-9][0-9] [1-2][0-9][0-9][0-9]")
  cy2 <- str_extract(cy2All, "[1-2][0-9][0-9][0-9]$")
  rm(cy2All)
  cy2 <- data.frame(cbind(crisis$country, cy2))
  cy2 <- rename(cy2, c(V1 = "country", cy2 = "CurrencyCrisis"))
  cy2 <- cy2[!is.na(cy2$CurrencyCrisis),]

cy3All <- str_extract(crisis$CurrencyCrisis, "^[1-2][0-9][0-9][0-9] [1-2][0-9][0-9][0-9] [1-2][0-9][0-9][0-9]")
  cy3 <- str_extract(cy3All, "[1-2][0-9][0-9][0-9]$")
  rm(cy3All)
  cy3 <- data.frame(cbind(crisis$country, cy3))
  cy3 <- rename(cy3, c(V1 = "country", cy3 = "CurrencyCrisis"))
  cy3 <- cy3[!is.na(cy3$CurrencyCrisis),]

cy4All <- str_extract(crisis$CurrencyCrisis, "^[1-2][0-9][0-9][0-9] [1-2][0-9][0-9][0-9] [1-2][0-9][0-9][0-9] [1-2][0-9][0-9][0-9]")
  cy4 <- str_extract(cy4All, "[1-2][0-9][0-9][0-9]$")
  rm(cy4All)
  cy4 <- data.frame(cbind(crisis$country, cy4))
  cy4 <- rename(cy4, c(V1 = "country", cy4 = "CurrencyCrisis"))
  cy4 <- cy4[!is.na(cy4$CurrencyCrisis),]

CurrencyCrisisIndv <- rbind(cy1, cy2, cy3, cy4)
CurrencyCrisisIndv <- CurrencyCrisisIndv[order(CurrencyCrisisIndv$country), ]
CurrencyCrisisIndv$year <- CurrencyCrisisIndv$CurrencyCrisis
CurrencyCrisisIndv$CurrencyCrisis <- 1

#### Split Sovereign Default into individual country years ####
crisis$SovereignDefault <- gsub(",", "", x= crisis$SovereignDefault)

cy1 <- str_extract(crisis$SovereignDefault, "^[1-2][0-9][0-9][0-9]")
cy1 <- data.frame(cbind(crisis$country, cy1))
cy1 <- rename(cy1, c(V1 = "country", cy1 = "SovereignDefault"))
cy1 <- cy1[!is.na(cy1$SovereignDefault),]

cy2All <- str_extract(crisis$SovereignDefault, "^[1-2][0-9][0-9][0-9] [1-2][0-9][0-9][0-9]")
cy2 <- str_extract(cy2All, "[1-2][0-9][0-9][0-9]$")
rm(cy2All)
cy2 <- data.frame(cbind(crisis$country, cy2))
cy2 <- rename(cy2, c(V1 = "country", cy2 = "SovereignDefault"))
cy2 <- cy2[!is.na(cy2$SovereignDefault),]

cy3All <- str_extract(crisis$SovereignDefault, "^[1-2][0-9][0-9][0-9] [1-2][0-9][0-9][0-9] [1-2][0-9][0-9][0-9]")
cy3 <- str_extract(cy3All, "[1-2][0-9][0-9][0-9]$")
rm(cy3All)
cy3 <- data.frame(cbind(crisis$country, cy3))
cy3 <- rename(cy3, c(V1 = "country", cy3 = "SovereignDefault"))
cy3 <- cy3[!is.na(cy3$SovereignDefault),]

SovDefaultIndv <- rbind(cy1, cy2, cy3)
SovDefaultIndv <- SovDefaultIndv[order(SovDefaultIndv$country), ]
SovDefaultIndv$year <- SovDefaultIndv$SovereignDefault
SovDefaultIndv$SovereignDefault <- 1

#### Split Sovereign Debt Restructuring into individual country years ####
crisis$SovereignDebtRestructuring <- gsub(",", "", x= crisis$SovereignDebtRestructuring)

cy1 <- str_extract(crisis$SovereignDebtRestructuring, "^[1-2][0-9][0-9][0-9]")
cy1 <- data.frame(cbind(crisis$country, cy1))
cy1 <- rename(cy1, c(V1 = "country", cy1 = "SovereignDebtRestructuring"))
cy1 <- cy1[!is.na(cy1$SovereignDebtRestructuring),]

cy2All <- str_extract(crisis$SovereignDebtRestructuring, "^[1-2][0-9][0-9][0-9] [1-2][0-9][0-9][0-9]")
cy2 <- str_extract(cy2All, "[1-2][0-9][0-9][0-9]$")
rm(cy2All)
cy2 <- data.frame(cbind(crisis$country, cy2))
cy2 <- rename(cy2, c(V1 = "country", cy2 = "SovereignDebtRestructuring"))
cy2 <- cy2[!is.na(cy2$SovereignDebtRestructuring),]

cy3All <- str_extract(crisis$SovereignDebtRestructuring, "^[1-2][0-9][0-9][0-9] [1-2][0-9][0-9][0-9] [1-2][0-9][0-9][0-9]")
cy3 <- str_extract(cy3All, "[1-2][0-9][0-9][0-9]$")
rm(cy3All)
cy3 <- data.frame(cbind(crisis$country, cy3))
cy3 <- rename(cy3, c(V1 = "country", cy3 = "SovereignDebtRestructuring"))
cy3 <- cy3[!is.na(cy3$SovereignDebtRestructuring),]

SovDebtRestructIndv <- rbind(cy1, cy2, cy3)
SovDebtRestructIndv <- SovDebtRestructIndv[order(SovDebtRestructIndv$country), ]
SovDebtRestructIndv$year <- SovDebtRestructIndv$SovereignDebtRestructuring
SovDebtRestructIndv$SovereignDebtRestructuring <- 1

#### Merge Country Year data ####
crisis <- merge(CrisisIndv, CurrencyCrisisIndv, by = c("country", "year"), all = TRUE)       
crisis <- merge(crisis, SovDefaultIndv, by = c("country", "year"), all = TRUE)
crisis <- merge(crisis, SovDebtRestructIndv, by = c("country", "year"), all = TRUE)     

#### Create crisis dummies ####

vars <- c("SystemicCrisis",
          "CurrencyCrisis",
          "SovereignDefault",
          "SovereignDebtRestructuring"
            )

for (i in vars){
  crisis[[i]][is.na(crisis[[i]])] <- 0
}

#### Add imfcode ####

crisis$imfcode <- countrycode(crisis$country, origin = "country.name", destination = "imf")
crisis <- crisis[!is.na(crisis$imfcode), ]
crisis <- crisis[, -1]

#### Create variable descriptions ####
ColNames <- names(crisis[, c(3:6)])
Description <- c("Systemic banking crisis starty year", "Currency crisis start year", "Sovereign default year", "Sovereign debt restructuring year")
Source <- c("Laeven & Valencia (2012)")

VarList <- cbind(ColNames, Description, Source)

VarList <- xtable(VarList)

CrisisVariableTable <- print(VarList, type = "html")

cat("# Variables Labels and Variable Descriptions for Laeven & Valencia (2012) Crisis Start Year Data\n ### See: <http://www.imf.org/external/pubs/cat/longres.aspx?sk=26015.0>\n\n", CrisisVariableTable, file = "/git_repositories/amcData/MainData/VariableDescriptions/LVCrisisDummyVariableDescriptions.md")

# Save file
write.table(crisis, file = "/git_repositories/amcData/MainData/CleanedPartial/LVCrisisDummyData.csv", sep = ",")
