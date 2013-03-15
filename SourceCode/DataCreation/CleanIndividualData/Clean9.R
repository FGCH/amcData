############
# Clean Up IMF Government Finance Statistics
# Christopher Gandrud
# 16 February 2013
############


# International Monetary Fund. Government Finance Statistics. ICPSR08624-v2. Ann Arbor, MI: Inter-university Consortium for Political and Social Research [distributor], 2010-07-26. doi:10.3886/ICPSR08624.v2

#### Make note not to distribute #### 

# Load data
IMFGFS <- read.csv("/git_repositories/amcData/BaseFiles/IMF_GFS/IMFGFS.csv")

# Clean up
IMFGFS <- plyr::rename(IMFGFS, c("COUNTRY" = "imfcode", "DATE" = "year"))

# Also Check Out http://www.oecd.org/ctp/fiscalfederalismnetwork/oecdfiscaldecentralisationdatabase.htm#E_12

# TEMP
Sub <- subset(IMFGFS)