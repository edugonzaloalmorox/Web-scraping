# Web scraping with R

This repository contains the code for scraping information from a website. All the analyses are based on http://www.carehome.co.uk. The goal of this mini project consists of obtaining a list of the care home groups in England, the types of care homes belonging to each group and their type of ownership. The repository only contains the code used `care homes groups.R` and the final data.frame `care_uk.csv` 

The analysis is done in three steps: 

### 1. Scrap the website 

I use Hadley´s Wickham excellent package `rvest` for obtaining the information from the web. For doing that it is necessary to identify the parts within the website that are interesting. I use [SelectorGadget](http://selectorgadget.com) for identifying the information that I want to retrieve. This enables to select those `CSS` parts in the web that are going to be analysed. Subsequently this information needs to be transformed into a `data.frame` to be manipulated and analysed. 

Two data.frames are created containing the names of the groups (`test_names`) and the respective capacity (`test_capacity`
). The capacity consists of various types of information that have to be split. 

### 2. Create variables according to the types of premises

I aim to create a variable for every type of premise and the ownership corresponding to each group. There are four types of premises (CH, ADC, ECH and MHH) whereas the ownership may be (P, V, L, N). I use `dplyr`, `plyr` and `stringr` for carrying out all the manipulations. I do the analysis considering `test_names` and `test_capacity`independently. 

`test_capacity`

The information regarding the capacity is stored in one variable. I need to split considering the characters that are used to associate the capacity with each type of premise. There are  types of characters (`,`) and (`•`) so I cannot split the variable in one time using `str_split_fixed`. I first do for `•` and then for `,`

Then I create variables considering only the first two elements for each observation. This gives me most of the numbers referred to the capacity of each care home group. I need to double check some groups that have more than 99 facilities and therefore only the first two characters are captured. 

I do **ownership** spliting `test_capacity` and renaming accordingly.

`test_names`

Some names have a rating at the end. Since I am not interested in these I create a general rule (`regex`) for removing them. The final purpose of this exercise is to compare this list of names with the list of care home groups provided by the CQC. `test_names` also contains information regarding other parts of the website. I also remove those rows because they are not used in the analysis. 

#### 3. Link names and number and type of care homes

The `data.frames` referred to the names, the capacity and the ownership have the same dimension. It is possible to merge them simply by `finaldf = data.frame(names, capacity, ownership)`







