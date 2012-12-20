#############
# AMC Paper: AMCs operating graph
# Christopher Gandrud
# 21 December 2012
#############

# Depends on: 
# library(devtools)
# source_url("https://raw.github.com/christophergandrud/amcData/master/SourceCode/Paper1Source/LoadRPackages.R")
# source_url("https://raw.github.com/christophergandrud/amcData/master/SourceCode/Paper1Source/PaperDataLoadClean.R")


# Number Operating
SumOp <- subset(NotNaAMCType, AMCType !=  "?")
SumOp <- subset(SumOp, AMCType !=  "None")
#SumOpAll <- ddply(SumOp, .(year), function(x) sum(x$NumAMCOpNoNA))

#OperatingAllPlot <- ggplot(data = SumOpAll, aes(year, V1)) +
#  geom_vline(xintercept = c(1991, 1997, 2008), size = 0.5, color = "#DEDEDE") +
#  geom_line(size = 2, alpha = I(0.9)) +
#  scale_x_continuous(limits = c(1980, 2011)) +
#  xlab("") + ylab("Number of AMCs Operating\n") +
#  theme_bw(base_size = 15)


# Number operating by type
SumOp$Marker[SumOp$NumAMCOpNoNA >= 1] <- 1
SumOp <- ddply(SumOp, .(year, AMCType), function(x) sum(x$Marker))


OperatingTypePlot <- ggplot(data = SumOp, aes(year, V1)) +
				        geom_vline(xintercept = c(1991, 1997, 2008), size = 0.5, color = "#DEDEDE") +
				        geom_line(aes(color = AMCType, linetype = AMCType), size = 1, alpha = I(0.9)) +
                scale_color_discrete(name = "") +
                scale_linetype_discrete(name = "") +
				        scale_x_continuous(limits = c(1980, 2011)) +
				        xlab("") + ylab("Number of Countries\n") +
				        theme_bw(base_size = 15)
print(OperatingTypePlot)

#grid.arrange(OperatingAllPlot, OperatingTypePlot, ncol = 2)