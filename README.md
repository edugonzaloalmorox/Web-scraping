#Web scrapping with R

This repository contains the code for scrapping information from a website. All the analyses are based on http://www.carehome.co.uk. The goal of this mini project consists of obtaining a list of the care home groups in England, the types of care homes belonging to each group and their type of ownership. The repository only contains the code used `care homes groups.R` and the final data.frame `care_uk.csv` 

The analysis is done in three steps: 

#####1. Scrap the website 

I use Hadley´s Wickham excellent package `rvest` for obtaining the information from the web. For doing that it is necessary to identify the parts within the website that are interesting. I use [SelectorGadget](http://selectorgadget.com) for identifying the information that I want to retrieve. This enables to select those `CSS` parts in the web that are going to be analysed. 



