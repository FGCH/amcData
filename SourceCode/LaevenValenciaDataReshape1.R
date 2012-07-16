###########
# Laeven and Valencia 2012 Data Reshape
# Christopher Gandrud
# 16 July 2012
###########

library(reshape)
library(xtable)

## Input data and transform it into long format

setwd("~/Desktop/LavVal2012/")

restruct <- read.csv("LavValPolicies.csv")

restruct.r <- t(restruct)

write.table(restruct.r, file = "restruct.csv", sep = ",")

## Manually removed automatic column names

restruct.rmod <- read.csv("restruct.csv")

## Create list of countries and AMCs

amcs <- restruct.rmod[, c(1:2, 40)]

amcs <- subset(amcs, amcs$Asset.management.company > 0)

amcs <- rename(amcs, c(Asset.management.company = "AMC"))

amcs$AMC[amcs$AMC == 1] <- "Centralised"
amcs$AMC[amcs$AMC == 2] <- "Decentralized"

print(xtable(amcs), type = "html", include.rownames = FALSE)
