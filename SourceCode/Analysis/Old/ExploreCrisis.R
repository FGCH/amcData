######### 
# Exploritory AMC Analysis with amcCrisisYear dataset
# Christopher Gandrud
# Updated 30 July 2012
#########

# Load required packages
library(RCurl)
library(ggplot2)
library(Zelig)

# Load data from the GitHub site
url <- "https://raw.github.com/christophergandrud/amcData/master/MainData/amcCrisisYear.csv"
mainCrisis <- getURL(url)
mainCrisis <- read.csv(textConnection(mainCrisis))

# Create new analysis variables
mainCrisis$AMCDummy[mainCrisis$AMC == "NoAMC"] <- 0
mainCrisis$AMCDummy[mainCrisis$AMC == "AMCCreated"] <- 1

# Create new analysis variables
mainCrisis$AMCTypeNum[mainCrisis$AMCType == "None"] <- 0
mainCrisis$AMCTypeNum[mainCrisis$AMCType == "Decentralised"] <- 1
mainCrisis$AMCTypeNum[mainCrisis$AMCType == "Centralised"] <- 2



mainCrisis$SingleParty[mainCrisis$govfrac > 0] <- "MultiParty"
mainCrisis$SingleParty[mainCrisis$govfrac == 0] <- "SingleParty"

##### Basic Boxplots ####

qplot(AMC, execrlc, geom = "jitter", data = mainCrisis) + theme_bw()

#### Exploratory Models ####

M1 <- zelig(AMCType ~ IMFProgram, model = "mlogit.bayes", data = mainCrisis)
  
  ImfValues <- c("N", "Y")
  M1.set <- setx(M1, IMFProgram = ImfValues)
  M1.sim <- sim(M1, x = M1.set)
  plot.ci(M1.sim)

M2 <- zelig(AMCDummy ~ SingleParty, model = "logit.bayes", data = mainCrisis)

M3 <- zelig(AMCDummy ~ IMFProgram + execrlc, model = "logit.bayes", data = mainCrisis)

M4 <- zelig(AMCDummy ~ PeakNPLs, model = "logit.bayes", data = mainCrisis)

M5 <- zelig(as.factor(AMCType) ~ UDS, model = "mlogit.bayes", data = mainCrisis)

M6 <- zelig(AMCType ~ govfrac, model = "mlogit.bayes", data = mainCrisis)

M7 <- zelig(AMCDummy ~ GDPperCapita + IMFProgram, model = "logit.bayes", data = mainCrisis)






