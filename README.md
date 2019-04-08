# ripemeeting-n-of-m
Hack to determine approximately how many people attended n out of m previous RIPE meetings for the purpose of establishing eligibility criteria for the RIPE SelCom.

This is based on a gross hack of https://github.com/shane-kerr/ripemtggender. I just mutilated the main python script to output approximations of the attendee names and process them further with a perl script. The script has an option to output similar names in order to make an equivalence list of different spellings. 

The aim here is not 100% exact results. There are simply too many gross heuristics involved.


## Installation

Install https://github.com/shane-kerr/ripemtggender according to the instructions there.
Replace 

