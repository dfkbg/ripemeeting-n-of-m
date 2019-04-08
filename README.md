# ripemeeting-n-of-m
Hack to determine approximately how many people attended n out of m previous RIPE meetings for the purpose of establishing eligibility criteria for the RIPE SelCom.

This is based on a gross hack of https://github.com/shane-kerr/ripemtggender. I just mutilated the main python script to output approximations of the attendee names and process them further with a perl script. The script has an option to output similar names in order to make an equivalence list of different spellings. 

The aim here is not 100% exact results. There are simply too many gross heuristics involved.

Publishing this here is mainly to enable verification and/or improvement of this specific work and not general usefulness.
Again, it is a quick hack. Treat it as such please.


## Installation & Usage

Install https://github.com/shane-kerr/ripemtggender according to the instructions there.
Replace getattendees.py with the hacked version and run it.

Then run selcom.pl to get the results.

run selcom.pl with -h to see specific options.

## Results as of RIPE77

```
attended, RIPE68, RIPE69, RIPE70, RIPE71, RIPE72, RIPE73, RIPE74, RIPE75, RIPE76, RIPE77
  5 of 5,     78,     83,    103,     96,     99,    113,    119,     89,    101,    100
  4 of 5,    153,    175,    203,    194,    209,    202,    214,    192,    213,    207
  3 of 5,    278,    306,    335,    308,    337,    352,    371,    329,    361,    354
  2 of 5,    504,    540,    585,    595,    645,    639,    641,    593,    631,    664
  1 of 5,   1500,   1576,   1668,   1657,   1763,   1806,   1794,   1743,   1886,   2005
  4 of 4,    105,    118,    125,    120,    135,    140,    138,    113,    117,    119
  3 of 4,    218,    253,    253,    249,    262,    262,    279,    258,    266,    258
  2 of 4,    443,    466,    500,    515,    542,    537,    529,    505,    510,    557
  1 of 4,   1306,   1379,   1446,   1497,   1545,   1564,   1515,   1545,   1627,   1768
  3 of 3,    156,    151,    166,    169,    169,    170,    196,    135,    147,    142
  2 of 3,    360,    353,    416,    385,    414,    384,    432,    367,    381,    408
  1 of 3,   1092,   1142,   1273,   1258,   1292,   1271,   1308,   1247,   1364,   1516
  2 of 2,    219,    223,    273,    236,    229,    271,    269,    185,    200,    312
  1 of 2,    819,    954,   1013,    967,    968,   1029,    995,    936,   1056,   1269
  1 of 1,    569,    608,    674,    525,    672,    628,    636,    485,    771,    810
```




