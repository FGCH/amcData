######### 
# Exploritory AMC Analysis
# Christopher Gandrud
# Updated 17 July 2012
#########

# Load required packages
library(RCurl)
library(ggplot2)
library(Zelig)

# Load data from the GitHub site
url <- "https://raw.github.com/christophergandrud/amcData/master/MainData/amcCrisisYear.csv"
main <- getURL(url)
main <- read.csv(textConnection(main))

# Create new analysis variables
main$AMCDummy[main$AMC == "NoAMC"] <- 0
main$AMCDummy[main$AMC == "AMCCreated"] <- 1

# Create new analysis variables
main$AMCTypeNum[main$AMCType == "None"] <- 0
main$AMCTypeNum[main$AMCType == "Decentralised"] <- 1
main$AMCTypeNum[main$AMCType == "Centralised"] <- 2



main$SingleParty[main$govfrac > 0] <- "MultiParty"
main$SingleParty[main$govfrac == 0] <- "SingleParty"

##### Basic Boxplots ####

qplot(AMC, execrlc, geom = "jitter", data = main) + theme_bw()

#### Exploratory Models ####

M1 <- zelig(AMCType ~ IMFProgram, model = "mlogit.bayes", data = main)
  
  ImfValues <- c("N", "Y")
  M1.set <- setx(M1, IMFProgram = ImfValues)
  M1.sim <- sim(M1, x = M1.set)
  plot.ci(M1.sim)

M2 <- zelig(AMCDummy ~ SingleParty, model = "logit.bayes", data = main)

M3 <- zelig(AMCDummy ~ IMFProgram + execrlc, model = "logit.bayes", data = main)

M4 <- zelig(AMCDummy ~ PeakNPLs, model = "logit.bayes", data = main)

M5 <- zelig(as.factor(AMCType) ~ UDS, model = "mlogit.bayes", data = main)

M6 <- zelig(AMCType ~ govfrac, model = "mlogit.bayes", data = main)





