##############
# Misc. Diagnostic Tests
# Christopher Gandrd
# 2 April 2013
##############

# See PaperSource5.R for set up and common code.

#### Examine Reserves coef for same period as CvHForeignOwn ####

# Subset
DataSub <- subset(Data, year > 1994)
DataSub <- subset(DataSub, year < 2010)

# Run model
MA1 <- coxph(Surv(year1980, AMCAnyCreated) ~ SystemicCrisisLag3 + 
TotalReservesGDP +
  cluster(imfcode) + strata(NumAMCCountryNoNA), data = DataSub)