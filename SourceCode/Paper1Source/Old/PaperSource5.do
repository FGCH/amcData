*******************
* AMCPaper 1: Competing Risks 1
* Hallerberg & Gandrud
* 23 January 2013
* Depends on Stata 12.1
*******************

***** Failure Code Legend *****
/*
AMCStatus = 0: None
AMCStatus = 1: Centralised
AMCStatus = 2: Decentralised
*/

* Change working directory
cd "~/Dropbox/AMCPaper1/TempData"


***** Combined (First AMC) *********

* Load data 
** Data file created from Makefile in amcData/SourceCode/Paper1Source
use "AMCMainData.dta", clear

***** Minor cleanup *****
replace ElectionYear1 = "" if ElectionYear1 == "NA"
gen ElectionYear1_n = 0 if ElectionYear1 == "NoElection"
replace ElectionYear1_n = 1 if ElectionYear1 == "Election"

***** No repeat
stset year, id(country) failure(AMCAnyCreated == 1) origin(min)

stcox UDS SystemicCrisisLag3 govfrac i.execrlc


***** Repeat
stset year, failure(AMCAnyCreated == 1) origin(min)

stcox UDS SystemicCrisisLag3, cluster(country) strata(AMCStatus)

logit AMCAnyCreated UDS SystemicCrisisLag3 govfrac i.execrlc, cluster(country) strata(AMCStatus)





************ Centralised *******************************
* Load data 
** Data file created from Makefile in amcData/SourceCode/Paper1Source
use "AMCMainData.dta", clear

***** Minor cleanup *****
replace ElectionYear1 = "" if ElectionYear1 == "NA"
gen ElectionYear1_n = 0 if ElectionYear1 == "NoElection"
replace ElectionYear1_n = 1 if ElectionYear1 == "Election"

* stset data
stset year, id(country) failure(AMCStatus == 1) enter(AMCStatus == 0) exit(AMCStatus == 1 2) origin(min)

stcrreg SystemicCrisisLag3, shr compete(AMCStatus == 2)

stcrreg NPLwdi, shr compete(AMCStatus == 2)

stcrreg IMFDreher, shr compete(AMCStatus == 2)

stcrreg IMFDreher SystemicCrisisLag3, shr compete(AMCStatus == 2)

stcrreg GDPperCapita, shr compete(AMCStatus == 2)

stcrreg GDPperCapita SystemicCrisisLag3, shr compete(AMCStatus == 2)

stcrreg SystemicCrisisLag3 UDS, shr compete(AMCStatus == 2)

stcrreg SystemicCrisisLag3 govfrac UDS ElectionYear1_n, shr compete(AMCStatus == 2)

stcrreg SystemicCrisisLag3 govfrac UDS ElectionYear1_n IMFDreher GDPperCapita, shr compete(AMCStatus == 2)

************ Centralised *******************************
* Load data 
** Data file created from Makefile in amcData/SourceCode/Paper1Source
use "AMCMainData.dta", clear

***** Minor cleanup *****
replace ElectionYear1 = "" if ElectionYear1 == "NA"
gen ElectionYear1_n = 0 if ElectionYear1 == "NoElection"
replace ElectionYear1_n = 1 if ElectionYear1 == "Election"
* stset data
stset year, id(country) failure(AMCStatus == 2) enter(AMCStatus == 0) exit(AMCStatus == 1 2) origin(min)

stcrreg govfrac, shr compete(AMCStatus == 1)

stcrreg UDS govfrac, shr compete(AMCStatus == 1)

stcrreg IMFDreher, shr compete(AMCStatus == 1)

stcrreg CurrentAccount, shr compete(AMCStatus == 1)

stcrreg NPLwdi, shr compete(AMCStatus == 1)

stcrreg govfrac NPLwdi, shr compete(AMCStatus == 1)

stcrreg IMFDreher SystemicCrisisLag3, shr compete(AMCStatus == 1)

stcrreg govfrac SystemicCrisisLag3 IMFDreher, shr compete(AMCStatus == 1)


********* Repeated Competing
* Load data 
** Data file created from Makefile in amcData/SourceCode/Paper1Source
use "AMCMainData.dta", clear

***** Minor cleanup *****
replace ElectionYear1 = "" if ElectionYear1 == "NA"
gen ElectionYear1_n = 0 if ElectionYear1 == "NoElection"
replace ElectionYear1_n = 1 if ElectionYear1 == "Election"

* stset data
stset year, failure(AMCStatus == 2) enter(AMCStatus == 1) origin(min)

stcrreg UDS, compete(AMCStatus == 1) cluster(country) strata 

