library(crrSC)
library(cmprsk)


# Depends on: 
# library(devtools)
# source_url("https://raw.github.com/christophergandrud/amcData/master/SourceCode/Paper1Source/LoadRPackages.R")
# source_url("https://raw.github.com/christophergandrud/amcData/master/SourceCode/Paper1Source/PaperDataLoadClean.R")


# Create fstatus variable from AMCType
## 1 = No AMC
## 2 = Centralised AMC
## 3 = Decentralised AMC

AMCLag$AMCStatus <- 1
AMCLag$AMCStatus[AMCLag$AMCType == "Centralised"] <-2
AMCLag$AMCStatus[AMCLag$AMCType == "Decentralised"] <-3

# Stratified competing risks model
attach(AMCLag)
M1 <- crrs(ftime = year,
           fstatus = AMCStatus,
           cov1 = cbind(govfrac, execrlc, SystemicCrisisLag3),
           failcode = 2,
           ctype = 1,
           strata = country)
detach(AMCLag)
print(M1)


M1Predict <- predict(M1, c(-5, 0, 5, 10))
plot.cuminc(M1)