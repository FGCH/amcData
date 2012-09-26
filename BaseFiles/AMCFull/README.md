# AMC Full Data Set
## Updated 26 September 2012

This data set includes the universe of *public bodies created to acquire and dispose of distressed assets*. These are commonly referred to as asset management companies or bad banks. 

The AMC Full Data Set was gathered largely by Grzegorz Wolszczak.

The file `AMCFull.csv` in this folder was converted from a Microsoft Excel file available at:

<https://www.dropbox.com/s/eo7njzgi689ows6/List_of_countries_2012.09.24.xls>

This file contains details about how the data was originally coded.

The vast majority of the documents that were used to find and code AMCs are available at: 

<https://www.dropbox.com/sh/i5pvrwva2uaelmz/sZ9PQ5jpca>

---
## Table of Data Collection Codes
### Used in `AMCFull.csv` variable A1

<TABLE border=1>
<TR> <TH>  </TH> <TH> AMCCollectionCode </TH> <TH> Details </TH>  </TR>
  <TR> <TD align="right"> 1 </TD> <TD> ''NF'' </TD> <TD> (nothing found) – if country doesn't appear in any paper K_2000, RR_2008, LV_2012 </TD> </TR>
  <TR> <TD align="right"> 2 </TD> <TD> xx-pAMC </TD> <TD> (no public AMC) – if there is a crisis in a given period in a given country, but according to K_2000 a country didn’t have an AMC then ''xx-pAMC'' </TD> </TR>
  <TR> <TD align="right"> 3 </TD> <TD> xx  </TD> <TD> (no AMC) – if prior to a given crisis in a given country there was no other crisis, then “xx” </TD> </TR>
  <TR> <TD align="right"> 4 </TD> <TD> no entry </TD> <TD> if there was a banking crisis in a given country, but no information was found about AMC existance - work in progress - it has to be checked if an AMC was created and if it still exists </TD> </TR>
  <TR> <TD align="right"> 5 </TD> <TD> None </TD> <TD> if there was no AMC during the years when a banking crisis was indicated by RR_2008, LV_2012 or K_2000. Sometimes crisis dates in those articles vary and then i often go along the LV_2012 list. </TD> </TR>
  <TR> <TD align="right"> 6 </TD> <TD> None </TD> <TD> (to be checked with an indication towards no AMC) - if there was a crisis in a given coutry, but is not mentioned in K_2000 as having an AMC </TD> </TR>
  <TR> <TD align="right"> 7 </TD> <TD> ? </TD> <TD> (to be checked) – if there was a crisis in a given country, but a country does not show up in K_2000 then “?” and has to be checked </TD> </TR>
  <TR> <TD align="right"> 8 </TD> <TD> xxCB </TD> <TD> no AMC, but there is some AMC-like activity at the central bank , e.g. a dedicated unit created etc. - Egypt 2004-2008 </TD> </TR>
  <TR> <TD align="right"> 9 </TD> <TD> CB </TD> <TD> actions were take via a central bank </TD> </TR>
  <TR> <TD align="right"> 10 </TD> <TD> DI </TD> <TD> deposit insurance agency </TD> </TR>
  <TR> <TD align="right"> 11 </TD> <TD> DI/AMC </TD> <TD> an agency which was both deposit insurance and an AMC </TD> </TR>
  <TR> <TD align="right"> 12 </TD> <TD> AMC+ </TD> <TD> an AMC with functions going beyond handling NPLs </TD> </TR>
  <TR> <TD align="right"> 13 </TD> <TD> q-AMC </TD> <TD> quasi-AMC, an agency, which has functions that remind AMC, but is somehow not fully an AMC </TD> </TR>
  <TR> <TD align="right"> 14 </TD> <TD> AMC-corporate </TD> <TD> an AMC for resolution of corporate debts </TD> </TR>
  <TR> <TD align="right"> 15 </TD> <TD> AMC(+)? </TD> <TD> most probably an AMC with broader functions - has to be double checked </TD> </TR>
  <TR> <TD align="right"> 16 </TD> <TD> managing body </TD> <TD> an agency helping with management of ailing banks (reconstruction agency) </TD> </TR>
   </TABLE>