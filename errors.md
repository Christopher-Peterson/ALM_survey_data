
# Errors detected in Data Parsing

Errors or issues were detected while parsing input files.

# Late Period Errors

## 2006 Leaf Survey MASTER RAW.xlsx

### Multiple binary columns in one row

|  row | total | site | tree | leaf_position | leaf_side | individual |
|-----:|------:|:-----|-----:|--------------:|:----------|-----------:|
| 1013 |     2 | BNZ  |   25 |             5 | T         |          2 |

### Leaves with major data conflicts among rows; these will be dropped for now.

| rows      | raw_column   | column            | values | year | site | tree | leaf_position |
|:----------|:-------------|:------------------|:-------|-----:|:-----|-----:|--------------:|
| 91:93     | leaf wd (cm) | leaf_width        | 42,3   | 2006 | BNZ  |    2 |            14 |
| 91:93     | % min bot    | mine_bttm_perc    | 2,0    | 2006 | BNZ  |    2 |            14 |
| 94:97     | leaf wd (cm) | leaf_width        | 50,42  | 2006 | BNZ  |    3 |             1 |
| 94:97     | EFNs         | efn_n             | 3,2    | 2006 | BNZ  |    3 |             1 |
| 94:97     | % min top    | mine_top_perc     | 95,80  | 2006 | BNZ  |    3 |             1 |
| 94:97     | % min bot    | mine_bttm_perc    | 60,65  | 2006 | BNZ  |    3 |             1 |
| 94:97     | % miss       | leaf_missing_perc | 2,0    | 2006 | BNZ  |    3 |             1 |
| 174:176   | leaf wd (cm) | leaf_width        | 42,27  | 2006 | BNZ  |    4 |             1 |
| 174:176   | % min top    | mine_top_perc     | 80,100 | 2006 | BNZ  |    4 |             1 |
| 174:176   | % min bot    | mine_bttm_perc    | 65,60  | 2006 | BNZ  |    4 |             1 |
| 201:203   | leaf wd (cm) | leaf_width        | 27,45  | 2006 | BNZ  |    5 |             1 |
| 201:203   | % min top    | mine_top_perc     | 100,60 | 2006 | BNZ  |    5 |             1 |
| 201:203   | % min bot    | mine_bttm_perc    | 60,50  | 2006 | BNZ  |    5 |             1 |
| 220:221   | leaf wd (cm) | leaf_width        | 45,44  | 2006 | BNZ  |    6 |             1 |
| 220:221   | % min top    | mine_top_perc     | 60,75  | 2006 | BNZ  |    6 |             1 |
| 220:221   | % min bot    | mine_bttm_perc    | 50,25  | 2006 | BNZ  |    6 |             1 |
| 220:221   | % miss       | leaf_missing_perc | 0,3    | 2006 | BNZ  |    6 |             1 |
| 250:251   | leaf wd (cm) | leaf_width        | 44,18  | 2006 | BNZ  |    7 |             1 |
| 250:251   | % min top    | mine_top_perc     | 75,100 | 2006 | BNZ  |    7 |             1 |
| 250:251   | % min bot    | mine_bttm_perc    | 25,70  | 2006 | BNZ  |    7 |             1 |
| 250:251   | % miss       | leaf_missing_perc | 3,40   | 2006 | BNZ  |    7 |             1 |
| 308:309   | leaf wd (cm) | leaf_width        | 18,21  | 2006 | BNZ  |    8 |             1 |
| 308:309   | EFNs         | efn_n             | 2,0    | 2006 | BNZ  |    8 |             1 |
| 308:309   | % min top    | mine_top_perc     | 100,5  | 2006 | BNZ  |    8 |             1 |
| 308:309   | % min bot    | mine_bttm_perc    | 70,100 | 2006 | BNZ  |    8 |             1 |
| 308:309   | % miss       | leaf_missing_perc | 40,0   | 2006 | BNZ  |    8 |             1 |
| 308:309   | galls        | gall_n            | 0,1    | 2006 | BNZ  |    8 |             1 |
| 335:336   | leaf wd (cm) | leaf_width        | 21,32  | 2006 | BNZ  |    9 |             1 |
| 335:336   | EFNs         | efn_n             | 0,2    | 2006 | BNZ  |    9 |             1 |
| 335:336   | % min top    | mine_top_perc     | 5,100  | 2006 | BNZ  |    9 |             1 |
| 335:336   | % min bot    | mine_bttm_perc    | 100,90 | 2006 | BNZ  |    9 |             1 |
| 335:336   | galls        | gall_n            | 1,0    | 2006 | BNZ  |    9 |             1 |
| 417:418   | leaf wd (cm) | leaf_width        | 32,39  | 2006 | BNZ  |   10 |             1 |
| 417:418   | % min bot    | mine_bttm_perc    | 90,65  | 2006 | BNZ  |   10 |             1 |
| 435:437   | leaf wd (cm) | leaf_width        | 39,45  | 2006 | BNZ  |   11 |             1 |
| 435:437   | % min bot    | mine_bttm_perc    | 65,90  | 2006 | BNZ  |   11 |             1 |
| 449:452   | leaf wd (cm) | leaf_width        | 45,13  | 2006 | BNZ  |   12 |             1 |
| 449:452   | EFNs         | efn_n             | 2,1    | 2006 | BNZ  |   12 |             1 |
| 449:452   | % min top    | mine_top_perc     | 100,0  | 2006 | BNZ  |   12 |             1 |
| 449:452   | % min bot    | mine_bttm_perc    | 90,5   | 2006 | BNZ  |   12 |             1 |
| 467:468   | leaf wd (cm) | leaf_width        | 13,42  | 2006 | BNZ  |   13 |             1 |
| 467:468   | EFNs         | efn_n             | 1,2    | 2006 | BNZ  |   13 |             1 |
| 467:468   | % min top    | mine_top_perc     | 0,100  | 2006 | BNZ  |   13 |             1 |
| 467:468   | % min bot    | mine_bttm_perc    | 5,90   | 2006 | BNZ  |   13 |             1 |
| 467:468   | leaf rolls   | leaf_roll_n       | 0,1    | 2006 | BNZ  |   13 |             1 |
| 512:515   | leaf wd (cm) | leaf_width        | 42,40  | 2006 | BNZ  |   14 |             1 |
| 512:515   | % min top    | mine_top_perc     | 100,50 | 2006 | BNZ  |   14 |             1 |
| 512:515   | % min bot    | mine_bttm_perc    | 90,55  | 2006 | BNZ  |   14 |             1 |
| 512:515   | leaf rolls   | leaf_roll_n       | 1,0    | 2006 | BNZ  |   14 |             1 |
| 539:540   | leaf wd (cm) | leaf_width        | 40,44  | 2006 | BNZ  |   15 |             1 |
| 539:540   | EFNs         | efn_n             | 2,4    | 2006 | BNZ  |   15 |             1 |
| 539:540   | % min top    | mine_top_perc     | 50,95  | 2006 | BNZ  |   15 |             1 |
| 539:540   | % min bot    | mine_bttm_perc    | 55,60  | 2006 | BNZ  |   15 |             1 |
| 554:559   | leaf wd (cm) | leaf_width        | 44,8   | 2006 | BNZ  |   16 |             1 |
| 554:559   | EFNs         | efn_n             | 4,0    | 2006 | BNZ  |   16 |             1 |
| 554:559   | % min top    | mine_top_perc     | 95,100 | 2006 | BNZ  |   16 |             1 |
| 554:559   | % min bot    | mine_bttm_perc    | 60,0   | 2006 | BNZ  |   16 |             1 |
| 583:584   | leaf wd (cm) | leaf_width        | 8,39   | 2006 | BNZ  |   17 |             1 |
| 583:584   | EFNs         | efn_n             | 0,2    | 2006 | BNZ  |   17 |             1 |
| 583:584   | % min top    | mine_top_perc     | 100,95 | 2006 | BNZ  |   17 |             1 |
| 583:584   | % min bot    | mine_bttm_perc    | 0,100  | 2006 | BNZ  |   17 |             1 |
| 635:637   | leaf wd (cm) | leaf_width        | 39,42  | 2006 | BNZ  |   18 |             1 |
| 635:637   | EFNs         | efn_n             | 2,0    | 2006 | BNZ  |   18 |             1 |
| 635:637   | % min top    | mine_top_perc     | 95,75  | 2006 | BNZ  |   18 |             1 |
| 635:637   | % min bot    | mine_bttm_perc    | 100,75 | 2006 | BNZ  |   18 |             1 |
| 648:652   | leaf wd (cm) | leaf_width        | 42,30  | 2006 | BNZ  |   19 |             1 |
| 648:652   | EFNs         | efn_n             | 0,2    | 2006 | BNZ  |   19 |             1 |
| 648:652   | % min top    | mine_top_perc     | 75,95  | 2006 | BNZ  |   19 |             1 |
| 648:652   | % min bot    | mine_bttm_perc    | 75,0   | 2006 | BNZ  |   19 |             1 |
| 648:652   | galls        | gall_n            | 0,1    | 2006 | BNZ  |   19 |             1 |
| 686:689   | leaf wd (cm) | leaf_width        | 30,75  | 2006 | BNZ  |   20 |             1 |
| 686:689   | EFNs         | efn_n             | 2,3    | 2006 | BNZ  |   20 |             1 |
| 686:689   | % min top    | mine_top_perc     | 95,65  | 2006 | BNZ  |   20 |             1 |
| 686:689   | % min bot    | mine_bttm_perc    | 0,50   | 2006 | BNZ  |   20 |             1 |
| 686:689   | galls        | gall_n            | 1,0    | 2006 | BNZ  |   20 |             1 |
| 708:719   | leaf wd (cm) | leaf_width        | 75,27  | 2006 | BNZ  |   21 |             1 |
| 708:719   | EFNs         | efn_n             | 3,2    | 2006 | BNZ  |   21 |             1 |
| 708:719   | % min top    | mine_top_perc     | 65,100 | 2006 | BNZ  |   21 |             1 |
| 708:719   | % min bot    | mine_bttm_perc    | 50,0   | 2006 | BNZ  |   21 |             1 |
| 785:786   | leaf wd (cm) | leaf_width        | 27,26  | 2006 | BNZ  |   28 |             1 |
| 785:786   | % min bot    | mine_bttm_perc    | 0,80   | 2006 | BNZ  |   28 |             1 |
| 839:841   | leaf wd (cm) | leaf_width        | 26,24  | 2006 | BNZ  |   29 |             1 |
| 839:841   | EFNs         | efn_n             | 2,1    | 2006 | BNZ  |   29 |             1 |
| 839:841   | % min top    | mine_top_perc     | 100,95 | 2006 | BNZ  |   29 |             1 |
| 839:841   | % min bot    | mine_bttm_perc    | 80,100 | 2006 | BNZ  |   29 |             1 |
| 842:845   | leaf wd (cm) | leaf_width        | 61,43  | 2006 | BNZ  |   29 |             2 |
| 842:845   | % min top    | mine_top_perc     | 60,75  | 2006 | BNZ  |   29 |             2 |
| 842:845   | galls        | gall_n            | 1,0    | 2006 | BNZ  |   29 |             2 |
| 862:864   | leaf wd (cm) | leaf_width        | 43,61  | 2006 | BNZ  |   30 |             2 |
| 862:864   | % min top    | mine_top_perc     | 35,60  | 2006 | BNZ  |   30 |             2 |
| 862:864   | % min bot    | mine_bttm_perc    | 45,50  | 2006 | BNZ  |   30 |             2 |
| 862:864   | galls        | gall_n            | 0,1    | 2006 | BNZ  |   30 |             2 |
| 1089:1091 | leaf wd (cm) | leaf_width        | 48,55  | 2006 | ED   |    2 |             4 |
| 1089:1091 | % min top    | mine_top_perc     | 100,35 | 2006 | ED   |    2 |             4 |
| 1089:1091 | % min bot    | mine_bttm_perc    | 75,0   | 2006 | ED   |    2 |             4 |
| 1089:1091 | % miss       | leaf_missing_perc | 0,3    | 2006 | ED   |    2 |             4 |
| 1100:1102 | leaf wd (cm) | leaf_width        | 43,40  | 2006 | ED   |    3 |             5 |
| 1100:1102 | % min top    | mine_top_perc     | 0,80   | 2006 | ED   |    3 |             5 |
| 1100:1102 | % min bot    | mine_bttm_perc    | 0,2    | 2006 | ED   |    3 |             5 |
| 1100:1102 | % miss       | leaf_missing_perc | 0,10   | 2006 | ED   |    3 |             5 |
| 1824:1826 | leaf wd (cm) | leaf_width        | 28,30  | 2006 | RP   |   21 |             4 |
| 1824:1826 | % min top    | mine_top_perc     | 100,80 | 2006 | RP   |   21 |             4 |
| 1824:1826 | % min bot    | mine_bttm_perc    | 90,70  | 2006 | RP   |   21 |             4 |
| 1824:1826 | % miss       | leaf_missing_perc | 0,3    | 2006 | RP   |   21 |             4 |
| 2375:2380 | leaf wd (cm) | leaf_width        | 44,38  | 2006 | WR   |   26 |             2 |
| 2375:2380 | EFNs         | efn_n             | 1,2    | 2006 | WR   |   26 |             2 |
| 2375:2380 | % min top    | mine_top_perc     | 90,80  | 2006 | WR   |   26 |             2 |
| 2375:2380 | % min bot    | mine_bttm_perc    | 18,70  | 2006 | WR   |   26 |             2 |
| 2381:2389 | leaf wd (cm) | leaf_width        | 42,44  | 2006 | WR   |   26 |             3 |
| 2381:2389 | % min top    | mine_top_perc     | 9,0    | 2006 | WR   |   26 |             3 |
| 2381:2389 | % min bot    | mine_bttm_perc    | 100,0  | 2006 | WR   |   26 |             3 |
| 2381:2389 | % miss       | leaf_missing_perc | 0,75   | 2006 | WR   |   26 |             3 |
| 2381:2389 | leaf rolls   | leaf_roll_n       | 1,0    | 2006 | WR   |   26 |             3 |
| 2390:2396 | leaf wd (cm) | leaf_width        | 51,37  | 2006 | WR   |   26 |             4 |
| 2390:2396 | % min top    | mine_top_perc     | 0,86   | 2006 | WR   |   26 |             4 |
| 2390:2396 | % min bot    | mine_bttm_perc    | 8,50   | 2006 | WR   |   26 |             4 |
| 2397:2406 | leaf wd (cm) | leaf_width        | 41,43  | 2006 | WR   |   26 |             5 |
| 2397:2406 | % min top    | mine_top_perc     | 85,25  | 2006 | WR   |   26 |             5 |
| 2397:2406 | % min bot    | mine_bttm_perc    | 45,82  | 2006 | WR   |   26 |             5 |
| 2397:2406 | % miss       | leaf_missing_perc | 0,2    | 2006 | WR   |   26 |             5 |

### Individuals are not unique within a leaf surface

| rows      | individuals | leaf_id             | leaf_side |
|:----------|:------------|:--------------------|:----------|
| 633:634   | NA,NA       | leaf_2006_BNZ_17_13 | T         |
| 2210:2213 | 1,1,2,3     | leaf_2006_WR_16_6   | B         |
| 2214:2219 | 1,1,2,2,3,3 | leaf_2006_WR_16_6   | T         |

## 2007 Leaf Survey MASTER RAW.xlsx

### Invalid site name

| row |
|----:|
| 223 |

### Individuals are not unique within a leaf surface

| rows      | individuals | leaf_id           | leaf_side |
|:----------|:------------|:------------------|:----------|
| 1836:1837 | 1,1         | leaf_2007_ED_23_6 | T         |

## 2008 Leaf Survey MASTER RAW.xlsx

### Leaves with major data conflicts among rows; these will be dropped for now.

| rows      | raw_column   | column            | values | year | site | tree | leaf_position |
|:----------|:-------------|:------------------|:-------|-----:|:-----|-----:|--------------:|
| 18:19     | \# galls     | gall_n            | 0,2    | 2008 | BNZ  |    1 |             7 |
| 78:81     | \# galls     | gall_n            | 0,1    | 2008 | BNZ  |    4 |             5 |
| 114:118   | \# galls     | gall_n            | 0,1    | 2008 | BNZ  |    5 |             9 |
| 153:156   | \# galls     | gall_n            | 0,1    | 2008 | BNZ  |    6 |             5 |
| 201:204   | \# galls     | gall_n            | 0,2    | 2008 | BNZ  |    8 |             3 |
| 209:215   | \# galls     | gall_n            | 0,2    | 2008 | BNZ  |    8 |             5 |
| 236:239   | \# galls     | gall_n            | 0,1    | 2008 | BNZ  |    9 |             8 |
| 240:241   | \# galls     | gall_n            | 2,0    | 2008 | BNZ  |   10 |             1 |
| 252:254   | \# galls     | gall_n            | 0,1    | 2008 | BNZ  |   10 |             5 |
| 255:259   | \# galls     | gall_n            | 0,2    | 2008 | BNZ  |   10 |             6 |
| 283:284   | \# galls     | gall_n            | 1,0    | 2008 | BNZ  |   12 |             4 |
| 289:290   | \# galls     | gall_n            | 0,1    | 2008 | BNZ  |   12 |             7 |
| 1634:1636 | \# galls     | gall_n            | 0,1    | 2008 | RP   |   11 |             5 |
| 1656:1657 | \# galls     | gall_n            | 0,4    | 2008 | RP   |   13 |             6 |
| 1862:1865 | leaf wd (cm) | leaf_width        | 22,26  | 2008 | RP   |   27 |             5 |
| 1862:1865 | % min top    | mine_top_perc     | 90,30  | 2008 | RP   |   27 |             5 |
| 1862:1865 | % min bot    | mine_bttm_perc    | 47,54  | 2008 | RP   |   27 |             5 |
| 1862:1865 | % miss       | leaf_missing_perc | 0,10   | 2008 | RP   |   27 |             5 |

### Individuals are not unique within a leaf surface

| rows      | individuals | leaf_id           | leaf_side |
|:----------|:------------|:------------------|:----------|
| 1924:1928 | 1,1,2,2,3   | leaf_2008_RP_31_5 | T         |
| 2354:2355 | 1,1         | leaf_2008_WR_20_3 | T         |

## 2009 Leaf Survey MASTER RAW.xlsx

### Leaves with major data conflicts among rows; these will be dropped for now.

| rows  | raw_column | column | values | year | site | tree | leaf_position |
|:------|:-----------|:-------|:-------|-----:|:-----|-----:|--------------:|
| 61:63 | Ngalls     | gall_n | 0,1    | 2009 | BNZ  |    3 |             2 |
| 83:84 | Ngalls     | gall_n | NA,0   | 2009 | BNZ  |    4 |             2 |

### Individuals are not unique within a leaf surface

| rows      | individuals                 | leaf_id            | leaf_side |
|:----------|:----------------------------|:-------------------|:----------|
| 407:408   | 1,1                         | leaf_2009_BNZ_17_5 | T         |
| 420:432   | 1,1,2,2,3,4,5,6,7,8,9,10,11 | leaf_2009_BNZ_18_1 | T         |
| 130:133   | 1,1,2,3                     | leaf_2009_BNZ_6_6  | B         |
| 1435:1436 | 1,1                         | leaf_2009_ED_18_4  | B         |
| 1459:1460 | 1,1                         | leaf_2009_ED_19_7  | T         |
| 1319:1320 | 1,1                         | leaf_2009_ED_7_3   | B         |
| 1330:1331 | 1,1                         | leaf_2009_ED_7_8   | T         |
| 1943:1944 | 1,1                         | leaf_2009_RP_28_3  | T         |

## 2010 Leaf Survey MASTER RAW.xlsx

### Leaves with major data conflicts among rows; these will be dropped for now.

| rows      | raw_column | column            | values | year | site | tree | leaf_position |
|:----------|:-----------|:------------------|:-------|-----:|:-----|-----:|--------------:|
| 708:709   | LfWid(cm)  | leaf_width        | 39,27  | 2010 | ED   |   17 |             1 |
| 708:709   | %MinTop    | mine_top_perc     | 65,0   | 2010 | ED   |   17 |             1 |
| 710:711   | LfWid(cm)  | leaf_width        | 40,28  | 2010 | ED   |   17 |             2 |
| 710:711   | %MinTop    | mine_top_perc     | 55,0   | 2010 | ED   |   17 |             2 |
| 718:721   | LfWid(cm)  | leaf_width        | 28,37  | 2010 | ED   |   17 |             5 |
| 718:721   | %MinTop    | mine_top_perc     | 15,80  | 2010 | ED   |   17 |             5 |
| 718:721   | %MinBot    | mine_bttm_perc    | 0,30   | 2010 | ED   |   17 |             5 |
| 718:721   | %Miss      | leaf_missing_perc | 5,0    | 2010 | ED   |   17 |             5 |
| 718:721   | Ngalls     | gall_n            | 0,4    | 2010 | ED   |   17 |             5 |
| 722:726   | LfWid(cm)  | leaf_width        | 27,39  | 2010 | ED   |   17 |             6 |
| 722:726   | %MinTop    | mine_top_perc     | 55,70  | 2010 | ED   |   17 |             6 |
| 722:726   | %MinBot    | mine_bttm_perc    | 30,15  | 2010 | ED   |   17 |             6 |
| 722:726   | %Miss      | leaf_missing_perc | 15,0   | 2010 | ED   |   17 |             6 |
| 722:726   | Ngalls     | gall_n            | 0,3    | 2010 | ED   |   17 |             6 |
| 727:729   | LfWid(cm)  | leaf_width        | 24,20  | 2010 | ED   |   17 |             7 |
| 727:729   | EFNs       | efn_n             | 2,0    | 2010 | ED   |   17 |             7 |
| 727:729   | %MinTop    | mine_top_perc     | 0,70   | 2010 | ED   |   17 |             7 |
| 727:729   | %MinBot    | mine_bttm_perc    | 65,40  | 2010 | ED   |   17 |             7 |
| 727:729   | NLfRolls   | leaf_roll_n       | 0,2    | 2010 | ED   |   17 |             7 |
| 1140:1144 | LfWid(cm)  | leaf_width        | 37,38  | 2010 | RP   |   21 |             3 |
| 1140:1144 | %MinBot    | mine_bttm_perc    | 5,50   | 2010 | RP   |   21 |             3 |
| 1213:1214 | Ngalls     | gall_n            | 1,2    | 2010 | WR   |    1 |             2 |
| 1300:1314 | LfWid(cm)  | leaf_width        | 63,55  | 2010 | WR   |    3 |             4 |
| 1300:1314 | EFNs       | efn_n             | 1,0    | 2010 | WR   |    3 |             4 |
| 1300:1314 | %MinTop    | mine_top_perc     | 80,60  | 2010 | WR   |    3 |             4 |
| 1300:1314 | %MinBot    | mine_bttm_perc    | 50,55  | 2010 | WR   |    3 |             4 |
| 1300:1314 | %Miss      | leaf_missing_perc | 3,5    | 2010 | WR   |    3 |             4 |
| 1300:1314 | NLfRolls   | leaf_roll_n       | 0,2    | 2010 | WR   |    3 |             4 |

### Individuals are not unique within a leaf surface

| rows      | individuals | leaf_id            | leaf_side |
|:----------|:------------|:-------------------|:----------|
| 272:274   | 1,1,2       | leaf_2010_BNZ_16_3 | B         |
| 312:313   | 1,1         | leaf_2010_BNZ_17_3 | B         |
| 42:44     | 1,1,3       | leaf_2010_BNZ_2_7  | T         |
| 68:69     | 1,1         | leaf_2010_BNZ_3_6  | B         |
| 72:73     | 1,1         | leaf_2010_BNZ_4_2  | T         |
| 122:123   | 1,1         | leaf_2010_BNZ_7_5  | T         |
| 153:154   | 1,1         | leaf_2010_BNZ_9_8  | B         |
| 870:871   | 1,1         | leaf_2010_ED_25_8  | B         |
| 1179:1180 | 1,1         | leaf_2010_RP_26_2  | B         |
| 1599:1600 | 1,1         | leaf_2010_WR_11_4  | B         |
| 1601:1602 | 1,1         | leaf_2010_WR_11_5  | T         |
| 1621:1624 | 1,1,2,3     | leaf_2010_WR_12_3  | T         |
| 1746:1747 | 1,1         | leaf_2010_WR_18_5  | B         |
| 1519:1520 | 1,1         | leaf_2010_WR_6_6   | B         |

## 2011 Leaf Survey MASTER RAW.xlsx

### Leaves with major data conflicts among rows; these will be dropped for now.

| rows      | raw_column  | column          | values                | year | site | tree | leaf_position |
|:----------|:------------|:----------------|:----------------------|-----:|:-----|-----:|--------------:|
| 1592:1593 | lf wd (cm)  | leaf_width      | 22,26                 | 2011 | RP   |   10 |             5 |
| 1592:1593 | %min top    | mine_top_perc   | 10,0                  | 2011 | RP   |   10 |             5 |
| 1592:1593 | %min bot    | mine_bttm_perc  | 85,0                  | 2011 | RP   |   10 |             5 |
| 1592:1593 | \# lf rolls | leaf_roll_n     | 1,0                   | 2011 | RP   |   10 |             5 |
| 1878:1883 | lf wd (cm)  | leaf_width      | 61,53                 | 2011 | WR   |    2 |             4 |
| 1878:1883 | EFNs        | efn_n           | 2,3                   | 2011 | WR   |    2 |             4 |
| 1878:1883 | %min top    | mine_top_perc   | 5,32                  | 2011 | WR   |    2 |             4 |
| 1878:1883 | %min bot    | mine_bttm_perc  | 13,5                  | 2011 | WR   |    2 |             4 |
| 1944:1945 | Coll Date   | collection_date | 2011-06-19,2011-06-18 | 2011 | WR   |    6 |             4 |
| 2136:2137 | Coll Date   | collection_date | 2011-06-19,2011-06-18 | 2011 | WR   |   17 |             4 |
| 2228:2229 | Coll Date   | collection_date | 2011-06-19,2011-06-18 | 2011 | WR   |   22 |             7 |
| 2251:2252 | Coll Date   | collection_date | 2011-06-19,2011-06-18 | 2011 | WR   |   24 |             7 |

### Individuals are not unique within a leaf surface

| rows      | individuals | leaf_id            | leaf_side |
|:----------|:------------|:-------------------|:----------|
| 941:944   | 1,2,2,3     | leaf_2011_BNZ_20_6 | B         |
| 1277:1279 | 1,2,2       | leaf_2011_ED_8_7   | B         |
| 1676:1677 | 1,1         | leaf_2011_RP_21_2  | T         |
| 1540:1541 | 1,1         | leaf_2011_RP_4_2   | B         |
| 2218:2219 | 1,1         | leaf_2011_WR_21_6  | T         |
| 1942:1943 | 1,1         | leaf_2011_WR_6_3   | B         |
| 1954:1955 | 1,1         | leaf_2011_WR_7_4   | T         |

## 2012 Leaf Survey MASTER RAW.xlsx

### Leaves with major data conflicts among rows; these will be dropped for now.

| rows      | raw_column  | column         | values | year | site | tree | leaf_position |
|:----------|:------------|:---------------|:-------|-----:|:-----|-----:|--------------:|
| 54:55     | \# bltch    | blotch_mines_n | 0,1    | 2012 | BNZ  |    3 |             2 |
| 194:195   | \# bltch    | blotch_mines_n | 1,0    | 2012 | BNZ  |   10 |             1 |
| 198:200   | \# bltch    | blotch_mines_n | 2,0    | 2012 | BNZ  |   10 |             3 |
| 1542:1543 | \# bltch    | blotch_mines_n | 2,0    | 2012 | WR   |    1 |             1 |
| 1551:1552 | \# lf rolls | leaf_roll_n    | 1,0    | 2012 | WR   |    1 |             6 |
| 1551:1552 | \# bltch    | blotch_mines_n | 1,0    | 2012 | WR   |    1 |             6 |
| 1941:1943 | \# bltch    | blotch_mines_n | 0,1    | 2012 | WR   |   21 |             7 |
| 1958:1968 | \# bltch    | blotch_mines_n | 1,0    | 2012 | WR   |   21 |            10 |
| 2074:2077 | \# bltch    | blotch_mines_n | 2,0    | 2012 | WR   |   25 |             9 |
| 2149:2152 | \# bltch    | blotch_mines_n | 2,0    | 2012 | WR   |   29 |             8 |

## 2013 Leaf Survey MASTER RAW.xlsx

### Individuals are not unique within a leaf surface

| rows    | individuals | leaf_id           | leaf_side |
|:--------|:------------|:------------------|:----------|
| 993:997 | 1,1,2,3,4   | leaf_2013_WR_5_11 | B         |

## 2014 Leaf Survey MASTER RAW.xlsx

### Leaves with major data conflicts among rows; these will be dropped for now.

| rows    | raw_column | column | values | year | site | tree | leaf_position |
|:--------|:-----------|:-------|:-------|-----:|:-----|-----:|--------------:|
| 255:258 | galls      | gall_n | 0,1    | 2014 | BNZ  |   16 |             9 |

### Individuals are not unique within a leaf surface

| rows      | individuals | leaf_id           | leaf_side |
|:----------|:------------|:------------------|:----------|
| 517:519   | 1,1,1       | leaf_2014_ED_10_8 | T         |
| 1038:1039 | 1,1         | leaf_2014_WR_15_9 | B         |

## 2015 Leaf Survey MASTER RAW.xlsx

### Leaves with major data conflicts among rows; these will be dropped for now.

| rows      | raw_column | column     | values | year | site | tree | leaf_position |
|:----------|:-----------|:-----------|:-------|-----:|:-----|-----:|--------------:|
| 250:254   | galls      | gall_n     | 1,0    | 2015 | BNZ  |   13 |             3 |
| 626:628   | galls      | gall_n     | 1,0    | 2015 | ED   |    3 |             4 |
| 1447:1448 | lf_wd_mm   | leaf_width | 39,41  | 2015 | WR   |   22 |             1 |

### Individuals are not unique within a leaf surface

| rows      | individuals | leaf_id            | leaf_side |
|:----------|:------------|:-------------------|:----------|
| 265:266   | 1,1         | leaf_2015_BNZ_13_6 | B         |
| 1332:1333 | 1,1         | leaf_2015_WR_15_6  | T         |
| 1426:1430 | 1,2,2,3,4   | leaf_2015_WR_21_10 | B         |
| 1419:1420 | 1,1         | leaf_2015_WR_21_8  | T         |
| 1421:1423 | 1,2,2       | leaf_2015_WR_21_9  | T         |

## 2016 Leaf Survey MASTER RAW.xlsx

### Leaves with minor data conflicts among rows; these will be averaged for now.

| rows      | raw_column   | column            | values | year | site | tree | leaf_position |
|:----------|:-------------|:------------------|:-------|-----:|:-----|-----:|--------------:|
| 25:26     | galls (#)    | gall_n            | 1,0    | 2016 | BNZ  |    2 |             1 |
| 27:28     | galls (#)    | gall_n            | 1,0    | 2016 | BNZ  |    2 |             2 |
| 246:248   | %\_miss (#)  | leaf_missing_perc | 2,0    | 2016 | BNZ  |   10 |             5 |
| 2062:2065 | galls (#)    | gall_n            | 1,0    | 2016 | WR   |   21 |             6 |
| 2165:2168 | lf_rolls (#) | leaf_roll_n       | 1,0    | 2016 | WR   |   28 |             9 |

### Leaves with major data conflicts among rows; these will be dropped for now.

| rows      | raw_column    | column           | values | year | site | tree | leaf_position |
|:----------|:--------------|:-----------------|:-------|-----:|:-----|-----:|--------------:|
| 1681:1685 | lf_wd_mm (#)  | leaf_width       | 43,50  | 2016 | RP   |   23 |            11 |
| 1681:1685 | mine_top (#)  | mine_top_perc    | 2,5    | 2016 | RP   |   23 |            11 |
| 1681:1685 | mine_bttm (#) | mine_bttm_perc   | 5,3    | 2016 | RP   |   23 |            11 |
| 1681:1685 | init_bttm (#) | mine_init_bttm_n | 1,2    | 2016 | RP   |   23 |            11 |

### Individuals are not unique within a leaf surface

| rows      | individuals | leaf_id            | leaf_side |
|:----------|:------------|:-------------------|:----------|
| 240:241   | 1,1         | leaf_2016_BNZ_10_2 | B         |
| 518:519   | 1,1         | leaf_2016_BNZ_21_2 | T         |
| 85:89     | 1,1,2,2,3   | leaf_2016_BNZ_5_2  | T         |
| 1251:1252 | 1,1         | leaf_2016_ED_22_1  | B         |
| 1272:1273 | 1,1         | leaf_2016_ED_24_4  | T         |
| 1344:1345 | 1,1         | leaf_2016_ED_29_6  | B         |
| 1650:1651 | 1,1         | leaf_2016_RP_22_6  | B         |
| 2167:2168 | 1,1         | leaf_2016_WR_28_9  | B         |

## 2017 Leaf Survey MASTER RAW.xlsx

### Leaves with minor data conflicts among rows; these will be averaged for now.

| rows      | raw_column  | column            | values | year | site | tree | leaf_position |
|:----------|:------------|:------------------|:-------|-----:|:-----|-----:|--------------:|
| 252:254   | %\_miss (#) | leaf_missing_perc | 0,1    | 2017 | BNZ  |   10 |             7 |
| 1120:1121 | %\_miss (#) | leaf_missing_perc | 2,1    | 2017 | ED   |   24 |             3 |

### Leaves with major data conflicts among rows; these will be dropped for now.

| rows      | raw_column    | column         | values | year | site | tree | leaf_position |
|:----------|:--------------|:---------------|:-------|-----:|:-----|-----:|--------------:|
| 1405:1406 | mine_bttm (#) | mine_bttm_perc | 30,35  | 2017 | RP   |   21 |             3 |

### Individuals are not unique within a leaf surface

| rows      | individuals | leaf_id           | leaf_side |
|:----------|:------------|:------------------|:----------|
| 1141:1142 | 1,1         | leaf_2017_ED_25_6 | T         |
| 1954:1955 | 1,1         | leaf_2017_WR_27_9 | B         |

## 2018 Leaf survey MASTER SHORT RAW.xlsx

### Leaves with minor data conflicts among rows; these will be averaged for now.

| rows      | raw_column   | column          | values                | year | site | tree | leaf_position |
|:----------|:-------------|:----------------|:----------------------|-----:|:-----|-----:|--------------:|
| 488:489   | lf_rolls (#) | leaf_roll_n     | 2,0                   | 2018 | BNZ  |   23 |             5 |
| 1347:1351 | coll_date    | collection_date | 2018-06-27,2018-06-28 | 2018 | RP   |   13 |             4 |
| 1975:1978 | coll_date    | collection_date | 2018-06-28,2018-06-29 | 2018 | WR   |   13 |             5 |
| 1981:1983 | coll_date    | collection_date | 2018-06-28,2018-06-29 | 2018 | WR   |   13 |             7 |
| 2015:2017 | coll_date    | collection_date | 2018-06-28,2018-06-29 | 2018 | WR   |   15 |             7 |

### Leaves with major data conflicts among rows; these will be dropped for now.

| rows      | raw_column    | column            | values | year | site | tree | leaf_position |
|:----------|:--------------|:------------------|:-------|-----:|:-----|-----:|--------------:|
| 16:17     | lf_wd_mm (#)  | leaf_width        | 45,52  | 2018 | BNZ  |    1 |             8 |
| 16:17     | EFNs (#)      | efn_n             | 0,2    | 2018 | BNZ  |    1 |             8 |
| 16:17     | mine_bttm (#) | mine_bttm_perc    | 2,0    | 2018 | BNZ  |    1 |             8 |
| 16:17     | init_bttm (#) | mine_init_bttm_n  | 1,0    | 2018 | BNZ  |    1 |             8 |
| 16:17     | %\_miss (#)   | leaf_missing_perc | 0,2    | 2018 | BNZ  |    1 |             8 |
| 1590:1593 | lf_wd_mm (#)  | leaf_width        | 44,4   | 2018 | RP   |   32 |             4 |

### Individuals are not unique within a leaf surface

| rows      | individuals | leaf_id          | leaf_side |
|:----------|:------------|:-----------------|:----------|
| 702:703   | 1,1         | leaf_2018_ED_6_9 | B         |
| 699:701   | 1,2,2       | leaf_2018_ED_6_9 | T         |
| 704:707   | 1,1,2,2     | leaf_2018_ED_7_1 | B         |
| 710:711   | 1,1         | leaf_2018_ED_7_2 | B         |
| 708:709   | 1,1         | leaf_2018_ED_7_2 | T         |
| 716:717   | 1,1         | leaf_2018_ED_7_3 | B         |
| 712:715   | 1,1,2,2     | leaf_2018_ED_7_3 | T         |
| 720:721   | 1,1         | leaf_2018_ED_7_4 | B         |
| 718:719   | 1,1         | leaf_2018_ED_7_4 | T         |
| 724:725   | 1,1         | leaf_2018_ED_7_5 | B         |
| 722:723   | 1,1         | leaf_2018_ED_7_5 | T         |
| 730:731   | 1,1         | leaf_2018_ED_7_6 | B         |
| 726:729   | 1,1,2,2     | leaf_2018_ED_7_6 | T         |
| 732:735   | 1,1,2,2     | leaf_2018_ED_7_7 | B         |
| 736:737   | 1,1         | leaf_2018_ED_7_8 | B         |
| 1667:1670 | 1,1,2,4     | leaf_2018_WR_1_2 | B         |

## 2019 Leaf survey MASTER SHORT RAW.xlsx

### Leaves with minor data conflicts among rows; these will be averaged for now.

| rows      | raw_column    | column            | values | year | site | tree | leaf_position |
|:----------|:--------------|:------------------|:-------|-----:|:-----|-----:|--------------:|
| 1131:1132 | mine_bttm (#) | mine_bttm_perc    | 1,2    | 2019 | BNZ  |   27 |             7 |
| 2065:2066 | lf_rolls (#)  | leaf_roll_n       | 2,0    | 2019 | RP   |   29 |             7 |
| 2692:2693 | %\_miss (#)   | leaf_missing_perc | 0,1    | 2019 | WR   |   23 |             6 |

### Leaves with major data conflicts among rows; these will be dropped for now.

| rows    | raw_column    | column            | values | year | site | tree | leaf_position |
|:--------|:--------------|:------------------|:-------|-----:|:-----|-----:|--------------:|
| 930:939 | lf_wd_mm (#)  | leaf_width        | 59,56  | 2019 | BNZ  |   23 |             3 |
| 930:939 | mine_top (#)  | mine_top_perc     | 50,100 | 2019 | BNZ  |   23 |             3 |
| 930:939 | mine_bttm (#) | mine_bttm_perc    | 15,80  | 2019 | BNZ  |   23 |             3 |
| 930:939 | %\_miss (#)   | leaf_missing_perc | 40,0   | 2019 | BNZ  |   23 |             3 |

### Individuals are not unique within a leaf surface

| rows    | individuals   | leaf_id            | leaf_side |
|:--------|:--------------|:-------------------|:----------|
| 208:214 | 1,2,3,4,4,5,6 | leaf_2019_BNZ_12_2 | T         |

## 2020 Leaf Survey Master RAW.xlsx

### Leaves with minor data conflicts among rows; these will be averaged for now.

| rows    | raw_column    | column         | values | year | site | tree | leaf_position |
|:--------|:--------------|:---------------|:-------|-----:|:-----|-----:|--------------:|
| 21:24   | mine_bttm (#) | mine_bttm_perc | 1,2    | 2020 | BNZ  |    1 |            11 |
| 149:152 | lf_rolls (#)  | leaf_roll_n    | 0,1    | 2020 | BNZ  |    5 |             7 |

### Leaves with major data conflicts among rows; these will be dropped for now.

| rows      | raw_column    | column            | values | year | site | tree | leaf_position |
|:----------|:--------------|:------------------|:-------|-----:|:-----|-----:|--------------:|
| 854:858   | lf_wd_mm (#)  | leaf_width        | 35,NA  | 2020 | ED   |    5 |             3 |
| 854:858   | EFNs (#)      | efn_n             | 2,0    | 2020 | ED   |    5 |             3 |
| 897:898   | lf_wd_mm (#)  | leaf_width        | 33,27  | 2020 | ED   |    7 |             2 |
| 897:898   | mine_top (#)  | mine_top_perc     | 15,0   | 2020 | ED   |    7 |             2 |
| 897:898   | init_top (#)  | mine_init_top_n   | 1,0    | 2020 | ED   |    7 |             2 |
| 897:898   | %\_miss (#)   | leaf_missing_perc | 5,0    | 2020 | ED   |    7 |             2 |
| 1591:1593 | lf_wd_mm (#)  | leaf_width        | 54,62  | 2020 | RP   |    9 |             6 |
| 1591:1593 | EFNs (#)      | efn_n             | 2,1    | 2020 | RP   |    9 |             6 |
| 1591:1593 | mine_top (#)  | mine_top_perc     | 10,0   | 2020 | RP   |    9 |             6 |
| 1591:1593 | mine_bttm (#) | mine_bttm_perc    | 3,5    | 2020 | RP   |    9 |             6 |
| 1591:1593 | init_top (#)  | mine_init_top_n   | 1,0    | 2020 | RP   |    9 |             6 |

### Individuals are not unique within a leaf surface

| rows      | individuals | leaf_id           | leaf_side |
|:----------|:------------|:------------------|:----------|
| 151:152   | 1,1         | leaf_2020_BNZ_5_7 | B         |
| 913:914   | 1,1         | leaf_2020_ED_8_1  | B         |
| 976:977   | 1,1         | leaf_2020_ED_9_9  | B         |
| 2126:2127 | 1,1         | leaf_2020_WR_10_5 | B         |

## 2021 Leaf survey MASTER RAW.xlsx

### Individuals are not unique within a leaf surface

| rows      | individuals | leaf_id            | leaf_side |
|:----------|:------------|:-------------------|:----------|
| 296:298   | 1,1,2       | leaf_2021_BNZ_12_8 | T         |
| 477:480   | 1,2,2,3     | leaf_2021_BNZ_19_8 | T         |
| 661:662   | 1,1         | leaf_2021_BNZ_24_3 | T         |
| 830:831   | 1,1         | leaf_2021_ED_1_4   | B         |
| 839:840   | 1,1         | leaf_2021_ED_1_8   | T         |
| 1332:1333 | 1,1         | leaf_2021_ED_30_6  | T         |
| 922:923   | 1,1         | leaf_2021_ED_6_7   | B         |
| 1555:1556 | 1,1         | leaf_2021_RP_25_6  | B         |
| 2068:2072 | 1,2,3,4,4   | leaf_2021_WR_25_8  | B         |

## 2022 Leaf survey Master RAW.xlsx

### Individuals are not unique within a leaf surface

| rows      | individuals   | leaf_id            | leaf_side |
|:----------|:--------------|:-------------------|:----------|
| 439:440   | 1,1           | leaf_2022_BNZ_16_6 | B         |
| 704:710   | 1,2,3,3,4,5,6 | leaf_2022_BNZ_23_1 | B         |
| 212:214   | 1,1,3         | leaf_2022_BNZ_7_4  | T         |
| 273:277   | 1,2,3,3,4     | leaf_2022_BNZ_9_5  | T         |
| 1750:1752 | 1,2,2         | leaf_2022_WR_1_11  | T         |

## 2023 Leaf survey master RAW.xlsx

### Leaves with major data conflicts among rows; these will be dropped for now.

| rows      | raw_column   | column          | values | year | site | tree | leaf_position |
|:----------|:-------------|:----------------|:-------|-----:|:-----|-----:|--------------:|
| 1871:1872 | lf_wd_mm (#) | leaf_width      | 57,35  | 2023 | ED   |    3 |             5 |
| 1871:1872 | EFNs (#)     | efn_n           | 0,2    | 2023 | ED   |    3 |             5 |
| 1871:1872 | mine_top (#) | mine_top_perc   | 5,0    | 2023 | ED   |    3 |             5 |
| 1871:1872 | init_top (#) | mine_init_top_n | 1,0    | 2023 | ED   |    3 |             5 |

### Individuals are not unique within a leaf surface

| rows    | individuals                        | leaf_id            | leaf_side |
|:--------|:-----------------------------------|:-------------------|:----------|
| 960:962 | 1,1,2                              | leaf_2023_BNZ_13_1 | T         |
| 394:402 | 1,2,3,4,5,6,7,8,8                  | leaf_2023_BNZ_6_4  | T         |
| 456:471 | 1,2,3,3,4,4,5,5,6,6,7,8,9,10,11,12 | leaf_2023_BNZ_6_7  | T         |
| 784:785 | 1,1                                | leaf_2023_BNZ_9_4  | B         |
