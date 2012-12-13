#############
# AMC Paper: Paper Data Load and Clearn
# Christopher Gandrud
# 13 December 2012
#############


# Load most recent data
URL <- "https://raw.github.com/christophergandrud/amcData/master/MainData/amcCountryYear.csv"
AMC <- getURL(URL)
AMC <- read.csv(textConnection(AMC))

#### Create lagged crisis variable (Crisis onset year -3) ####
# Create individual year lags
AMCLag <- ddply(AMC, .(country), transform, SCL1 = c(NA, SystemicCrisis[-length(SystemicCrisis)]))
AMCLag <- ddply(AMCLag, .(country), transform, SCL2 = c(NA, SCL1[-length(SCL1)]))

# Create combined lagged variable
attach(AMCLag)
AMCLag$SystemicCrisisLag3 <- SystemicCrisis + SCL1 + SCL2
detach(AMCLag)

# Remove old lag variables
AMCLag$SCL1 <- AMCLag$SCL2 <- NULL

#### Create Election Year +1 lag ####
lg<-function(x)c(x[2:(length(x))], NA)
AMCLag <- ddply(AMCLag, .(country), transform, ElectionYear1 = lg(ElectionYear))
AMCLag$ElectionYear1[AMCLag$ElectionYear1 == 2] <- "NoElection"
AMCLag$ElectionYear1[AMCLag$ElectionYear1 == 1] <- "Election"

#### Remove (De)centralised category
AMCLag$AMCType[AMCLag$AMCType == "(De)centralised"] <- "Decentralised"

#### Remove NA in AMC Type & Capture only an AMC's first year ####
AMCLag$AMCType[AMCLag$AMCType == ""] <- NA
NotNaAMCType <- subset(AMCLag, !is.na(AMCType) | AMCType != "None")

NotNaAMCType <- ddply(NotNaAMCType, .(country), transform, NotFirstYear = duplicated(NumAMCOpNoNA))
FirstYearNotNa <- subset(NotNaAMCType, NumAMCOpNoNA != 0 & NotFirstYear == FALSE)
