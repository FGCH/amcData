####################
# Create normal.bayes predicted probability of AMC creation graph
# Building Better Bad Banks
# Christopher Gandrud
# Updated 2 August 2012
###################

library(RCurl)
library(Zelig)
library(ggplot2)
library(reshape2)
library(gridExtra)

# Load data from the GitHub site
url <- "https://raw.github.com/christophergandrud/amcData/master/MainData/amcCountryYear.csv"
mainCountry <- getURL(url)
mainCountry <- read.csv(textConnection(mainCountry))

# Run Model
Model <- zelig(AMCDummy ~ IMFDreher + govfrac + GDPperCapita + SystemicCrisis, model = "logit.bayes", data = mainCountry, robust = "weave")

# Ranges of fitted values
imf.r <- c(0, 1)
govfrac.r <- seq(from = 0, to = 1, by = 0.1)


# Set fitted values
Model.ImfSet <- setx(Model, IMFDreher = imf.r)

Model.GovSet <- setx(Model, govfrac = govfrac.r, SystemicCrisis = 1)

# Simulate quantities of interest

Model.IMFSim <- sim(Model, x = Model.ImfSet)

Model.GovSim <- sim(Model, x = Model.GovSet)

#### IMF Graph ####
# Extract expected values from simulations for IMF


#### GovFrac Graph ####
# Extract expected values from simulations for GovFrac
Model.GovSim.e <- data.frame(Model.GovSim$qi)
Model.GovSim.e <- Model.GovSim.e[, 1:11]
names(Model.GovSim.e) <- c("X0.0", "X0.1", "X0.2", "X0.3", "X0.4", "X0.5", "X0.6", "X0.7", "X0.8", "X0.9", "X1") 
Model.GovSim.e <- melt(Model.GovSim.e, measure = 1:11)

Model.GovSim.e$variable <- as.numeric(gsub("X", "", Model.GovSim.e$variable))

#### Plot GovFrac #### 
Model.GovPlot <- ggplot(Model.GovSim.e, aes(variable, value)) +
                          geom_point(shape = 21, color = "gray30",, alpha = I(0.01), size = 7) +
                          stat_smooth(method = "auto") +
                          xlab("\nGovernment Fractionalisation") + ylab("Probability\n") +
                          opts(title = "Simulated Probability of Creating an AMC\n in the 1st Year of a Crisis\n") +
                          theme_bw(base_size = 15)

print(Model.GovPlot)

