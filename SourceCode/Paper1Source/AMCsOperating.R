#############
# AMC Paper: AMCs operating graph
# Christopher Gandrud
# 14 December 2012
#############

# Depends on: 
# library(devtools)
# source_url("https://raw.github.com/christophergandrud/amcData/master/SourceCode/Paper1Source/LoadRPackages.R")
# source_url("https://raw.github.com/christophergandrud/amcData/master/SourceCode/Paper1Source/PaperDataLoadClean.R")

#### Cumulative Count ####
TypeColors <- c("#E6AB02", "#1B9E77")

# Number operating by type
SumOp <- ddply(NotNaAMCType, .(year, AMCType), function(x) sum(x$NumAMCOpNoNA))
SumOp <- subset(SumOp, AMCType !=  "?")
SumOp <- subset(SumOp, AMCType !=  "None")

OperatingPlot <- ggplot(data = SumOp, aes(year, V1)) +
				        geom_vline(xintercept = c(1991, 1997, 2008), linetype = "dashed", size = 0.5) +
				        geom_line(aes(color = AMCType), size = 2, alpha = I(0.9)) +
				        scale_color_manual(values = TypeColors, name="") +
				        scale_x_continuous(limits = c(1980, 2011)) +
				        xlab("") + ylab("Number Operating\n") +
				        theme_bw(base_size = 15)

print(OperatingPlot)