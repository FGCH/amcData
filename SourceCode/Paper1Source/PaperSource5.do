
use "/Users/christophergandrud/Desktop/AMC.dta"

stset year, id(country) failure(AMCStatus == 2) enter(AMCStatus == 1) exit(AMCStatus == 2 3) origin(min)

stcrreg govfrac, nohr compete(AMCStatus == 3)

stcrreg govfrac SystemicCrisisLag3 UDS, nohr compete(AMCStatus == 3)
