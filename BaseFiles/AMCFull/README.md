# AMC Full Data Set
## Updated 27 September 2012

This data set includes the universe of *public bodies created to acquire and dispose of distressed assets*. These are commonly referred to as asset management companies or bad banks. 

The AMC Full Data Set was gathered largely by Grzegorz Wolszczak.

The file `AMCFull.csv` in this folder was converted from a Microsoft Excel file available at:

<https://www.dropbox.com/s/thr7v5yeip7f2fj/List_of_countries_2012.09.26.xls>

This file contains details about how the data was originally coded.

The vast majority of the documents that were used to find and code AMCs are available at: 

<https://www.dropbox.com/sh/i5pvrwva2uaelmz/sZ9PQ5jpca>

---
## Table of Data Collection Codes
### Variables used in `AMCFull.csv`

<TABLE border=1>
	<TR><TH> Variable </TH> <TH> Details </TH>  </TR>
	<TR><TD>AMCType</TD> <TD>Type of AMC, Centralized or Decentralized</TD></TR>
	<TR><TD>NumAMCOp</TD> <TD>Number of AMCs that have ever operated in a country</TD></TR>
	<TR><TD>NumAMCCountry</TD> <TD>Number of AMCs currently operating in a country</TD></TR>
	<TR><TD>NumAMCCountryLag</TD> <TD>Number of AMCs currently operating in a country up until, but not including the current year</TD></TR>
</TABLE>

Variables A1-A7 record which AMC it is per country.

Variables F1-F7 give more details about what type of AMC it is, primarily if it is a stand alone institution or run through another body. We used the following codes for these variables:

### Variables F1-F7 codes

<TABLE border=1>
	<TR><TH> Code </TH> <TH> Details </TH>  </TR>
	<TR> <TD>AMC</TD> <TD>Public asset management corporation</TD> </TR>
	  <TR>  </TD> <TD> CB </TD> <TD> actions were taken via a central bank </TD> </TR>
  <TR>  <TD> DI </TD> <TD> deposit insurance agency </TD> </TR>
  <TR>  </TD> <TD> DI/AMC </TD> <TD> an agency which was both deposit insurance and an AMC </TD> </TR>
  <TR>  </TD> <TD> AMC+ </TD> <TD> an AMC with functions going beyond handling NPLs </TD> </TR>
  <TR>   <TD> q-AMC </TD> <TD> quasi-AMC, an agency, which has functions that remind AMC, but is somehow not fully an AMC </TD> </TR>
  <TR>  </TD> <TD> AMC-corporate </TD> <TD> an AMC for resolution of corporate debts </TD> </TR>
  <TR>  <TD> AMC(+)? </TD> <TD> most probably an AMC with broader functions - has to be double checked </TD> </TR>
  <TR> <TD> privatisation agency </TD> <TD> an agency helping with management of ailing banks (reconstruction agency) </TD> </TR>
   <TR> <TD> ? </TD> <TD> Undetermined </TD> </TR>


</TABLE>

