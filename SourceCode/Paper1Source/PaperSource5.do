*******************
* AMCPaper 1: Competing Risks 1
* Hallerberg & Gandrud
* 22 January 2013
* Depends on Stata 12.1
*******************

* Change working directory
cd "~/Dropbox/AMCPaper1/TempData"

* Load data 
** Data file created from Makefile in amcData/SourceCode/Paper1Source
use "AMCMainData.dta", clear

***** Failure Code Legend *****
/*
AMCStatus = 1: None
AMCStatus = 2: Centralised
AMCStatus = 3: Decentralised
*/

***** Minor cleanup *****
replace ElectionYear1 = "" if ElectionYear1 == "NA"
gen ElectionYear1_n = 0 if ElectionYear1 == "NoElection"
replace ElectionYear1_n = 1 if ElectionYear1 == "Election"


************ Centralised *******************************
* stset data
stset year, id(country) failure(AMCStatus == 2) enter(AMCStatus == 1) exit(AMCStatus == 2 3) origin(min)

stcrreg SystemicCrisisLag3, shr compete(AMCStatus == 3)

stcrreg NPLwdi, shr compete(AMCStatus == 3)

stcrreg IMFDreher, shr compete(AMCStatus == 3)

stcrreg IMFDreher SystemicCrisisLag3, shr compete(AMCStatus == 3)

stcrreg GDPperCapita, shr compete(AMCStatus == 3)

stcrreg GDPperCapita SystemicCrisisLag3, shr compete(AMCStatus == 3)

stcrreg SystemicCrisisLag3 UDS, shr compete(AMCStatus == 3)

stcrreg SystemicCrisisLag3 govfrac UDS ElectionYear1_n, shr compete(AMCStatus == 3)

stcrreg SystemicCrisisLag3 govfrac UDS ElectionYear1_n IMFDreher GDPperCapita, shr compete(AMCStatus == 3)

************ Centralised *******************************
* Load data 
** Data file created from Makefile in amcData/SourceCode/Paper1Source
use "AMCMainData.dta", clear

***** Failure Code Legend *****
/*
AMCStatus = 1: None
AMCStatus = 2: Centralised
AMCStatus = 3: Decentralised
*/

***** Minor cleanup *****
replace ElectionYear1 = "" if ElectionYear1 == "NA"
gen ElectionYear1_n = 0 if ElectionYear1 == "NoElection"
replace ElectionYear1_n = 1 if ElectionYear1 == "Election"
* stset data
stset year, id(country) failure(AMCStatus == 3) enter(AMCStatus == 1) exit(AMCStatus == 2 3) origin(min)

stcrreg govfrac, shr compete(AMCStatus == 2)

stcrreg UDS govfrac, shr compete(AMCStatus == 2)

stcrreg IMFDreher, shr compete(AMCStatus == 2)

stcrreg CurrentAccount, shr compete(AMCStatus == 2)

stcrreg NPLwdi, shr compete(AMCStatus == 2)

stcrreg govfrac NPLwdi, shr compete(AMCStatus == 2)

stcrreg IMFDreher SystemicCrisisLag3, shr compete(AMCStatus == 2)

stcrreg govfrac SystemicCrisisLag3 IMFDreher, shr compete(AMCStatus == 2)
