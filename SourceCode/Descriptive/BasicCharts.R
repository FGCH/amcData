#############
# AMC Data Explore Early November
# Christopher Gandrud
# 15 November 2012
#############

# Load libraries
library(RCurl)
library(plyr)
library(xts)
library(ggplot2)
library(MASS)
library(reshape2)

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

#### Graphs ####
# Basic graph of AMC types
ggplot(data = FirstYearNotNa, aes(AMCType)) +
      geom_bar() +
      theme_bw()

# Created During Crisis (onset year + 2) & Not
# Crisis Creation Variable (1 no crisis, 2 crisis)
FirstYearNotNa$CrisisCreated <- FALSE
FirstYearNotNa$CrisisCreated[FirstYearNotNa$AMCAnyCreate == 1 & 
                               FirstYearNotNa$SystemicCrisisLag3 == 1] <- TRUE

ggplot(data = FirstYearNotNa, aes(AMCType)) +
  facet_grid(.~ CrisisCreated) +
  geom_bar() +
  theme_bw()

# Election the previous year
# Facited by ElectionYear & Crisis Created
ggplot(data = FirstYearNotNa, aes(AMCType)) +
  facet_grid(.~ ElectionYear1) +
  geom_bar() +
  theme_bw()


# Facited by ElectionYear & Crisis Created
ggplot(data = FirstYearNotNa, aes(AMCType)) +
  facet_grid(ElectionYear ~ CrisisCreated) +
  geom_bar() +
  theme_bw()

# govfrac density
ggplot(data = FirstYearNotNa, aes(govfrac)) +
  geom_density(aes(line = AMCType, color = AMCType)) +
  theme_bw()

# govfrac frequency
ggplot(data = FirstYearNotNa, aes(govfrac)) +
  geom_freqpoly(aes(line = AMCType, color = AMCType), bandwidth = 0.1) +
  theme_bw()

# UDS density
ggplot(data = FirstYearNotNa, aes(UDS)) +
  geom_density(aes(line = AMCType, color = AMCType)) +
  theme_bw()

# GDP density
ggplot(data = FirstYearNotNa, aes(log(GDPperCapita))) +
  geom_density(aes(line = AMCType, color = AMCType)) +
  theme_bw()

# Current account density
ggplot(data = FirstYearNotNa, aes(CurrentAccount)) +
  geom_density(aes(line = AMCType, color = AMCType)) +
  theme_bw()

#### Cumulative Count ####
TypeColors <- c("#E6AB02", "#1B9E77")

# Number operating by type
SumOp <- ddply(NotNaAMCType, .(year, AMCType), function(x) sum(x$NumAMCOpNoNA))
SumOp <- subset(SumOp, AMCType !=  "?")
SumOp <- subset(SumOp, AMCType !=  "None")

ggplot(data = SumOp, aes(year, V1)) +
        geom_vline(xintercept = c(1991, 1997, 2008), linetype = "dashed", size = 0.5) +
        geom_line(aes(color = AMCType), size = 2, alpha = I(0.9)) +
        scale_color_manual(values = TypeColors) +
        scale_x_continuous(limits = c(1980, 2011)) +
        xlab("") + ylab("Number Operating\n") +
        theme_bw(base_size = 15)

# Number Created by type
SumCreated <- ddply(NotNaAMCType, .(year, AMCType), function(x) sum(x$NumAMCCountryNoNA))
SumCreated <- subset(SumCreated, AMCType !=  "?")
SumCreated <- subset(SumCreated, AMCType !=  "None")

ggplot(data = SumCreated, aes(year, V1)) +
  geom_line(aes(color = AMCType)) +
  xlab("") + ylab("Number Created\n") +
  theme_bw(base_size = 15)


# Number Created by type & Crisis
SumOpCrisis <- ddply(NotNaAMCType, .(year, AMCType, SystemicCrisisLag3), function(x) sum(x$NumAMCOpNoNA))
SumOpCrisis <- subset(SumOpCrisis, AMCType !=  "?")
SumOpCrisis <- subset(SumOpCrisis, AMCType !=  "None")
SumOpCrisis$SystemicCrisisLag3[is.na(SumOpCrisis$SystemicCrisisLag3)] <- 0

ggplot(data = SumOpCrisis, aes(year, V1)) +
  geom_line(aes(color = AMCType, linetype = as.factor(SystemicCrisisLag3))) +
  xlab("") + ylab("Number Operating\n") +
  scale_x_continuous(limits = c(1980, 2010)) + # No crisis data later
  theme_bw(base_size = 15)

