# scrap carehome.co.uk information regarding care homes groups
# Goal: obtain information regarding the capacity  of different care homes
# This may be used as a robustness check with regards to the capacity
# Analysis done in three steps
#
#         1. Scrap the information from the website and transform it into a dataset
#         2. Create variables with the number of care homes
#         3. Link the information of the of the numver of care homes and names 
# -------------------------------------------------------------------


# 1 Scrap information from the website
install.packages("rvest")
install.packages("xml2")

library(rvest)
library(xml2)
library(magrittr)
library(stringr)

careuk <- read_html("http://www.carehome.co.uk/caregroups/allcarehomegroups.cfm")

names_homes <- careuk %>% 
  html_nodes("a") %>% #insert the CSS code. The xpath could work as well 
  html_text() 
  
test_names = as.data.frame(names_homes) #this data frame contains all the information that I want 

capacity_homes <- careuk %>% 
  html_nodes(".details") %>% #insert the CSS code. The xpath could work as well 
  html_text() 

test_capacity = as.data.frame(capacity_homes)
test = as.character(capacity_homes)



# 2 Create variables depending on the group  
# ----------------------------------------------

# Goal: create variables considering the type and number of care homes 
# Then this information is merged with the names of the 

test_capacity$ownership =  as.data.frame(with(test_capacity, str_split_fixed(capacity_homes, "•", 2)))

# number and types of care homes associated with the care homes groups


library(dplyr)
library(plyr)


check = test_capacity$ownership
check = with(check, str_split_fixed(V1, ",", 4))
check = as.data.frame(as.matrix(check))





library(reshape2)
check = apply(check, 2, function(x) str_trim(x, side = "both"))
check = apply(check, 2, function(x) gsub("ECH","ech", x))

check = as.data.frame(as.matrix(check))
check = colwise(as.character)(check)




str(check)



check$CH = with(check, ifelse(grepl("CH", V1), substr(V1, 1,2), 
                              ifelse(grepl("CH", V2), substr(V2, 1, 2),
                                     ifelse(grepl("CH", V3), substr(V3,1,2), 
                                            ifelse(grepl("CH", V4), substr(V4,1,2)," ")))))



check$ADC = with(check, ifelse(grepl("ADC", V1), substr(V1, 1,2), 
                               ifelse(grepl("ADC", V2), substr(V2, 1, 2),
                                      ifelse(grepl("ADC", V3), substr(V3,1,2), 
                                             ifelse(grepl("ADC", V4), substr(V4,1,2)," ")))))



check$ECH = with(check, ifelse(grepl("ech", V1), substr(V1, 1,2), 
                               ifelse(grepl("ech", V2), substr(V2, 1, 2),
                                      ifelse(grepl("ech", V3), substr(V3,1,2), 
                                             ifelse(grepl("ech", V4), substr(V4,1,2)," ")))))

check$MHH = with(check, ifelse(grepl("MHH", V1), substr(V1, 1,2), 
                               ifelse(grepl("MHH", V2), substr(V2, 1, 2),
                                      ifelse(grepl("MHH", V3), substr(V3,1,2), 
                                             ifelse(grepl("MHH", V4), substr(V4,1,2)," ")))))

check = check %>% select(`CH`:`MHH`) #final data set with the variables; merge with test_names

# determine ownership 
# -------------------
check.1 = test_capacity$ownership
names(check.1)[2] = "ownership" 
check.1 = check.1 %>% select(`ownership`)




# clean the names (remove the ratings)
#----------------------------------------------
#clean garbage - observations that are not referred to names of care homes

groups = as.data.frame(test_names[-c(1:110), ])
groups = as.data.frame(groups[-c(2435:2453), ])

str(groups)

# clean the ratings that are at the end of the name 


names(groups)[1] <- "care_group"

groups$care_group = as.character(groups$care_group)

# get rid of those characters within the levels of the factor that aren´t suitable
groups$new_var = with(groups, gsub("\t", " ", care_group))
groups$new_var = with(groups, gsub("\n", " ", new_var))
groups$new_var = as.character(groups$new_var) 
groups$new_var = with(groups, str_trim(new_var, side = "both"))

# remove the numbers at the end
groups$new_var.1 = with(groups, gsub(" [0-9.]+$", " ", new_var))

#................................................................
#   Note: 
#        the $ anchors the expression to the end of the text
#        the "[0-9.]+" says any sequence of numerical characters including "."
#.................................................................

# remove another character that is garbage
groups$new_var.1 = with(groups, gsub("\r", " ", new_var.1)) 
groups$new_var.1 = with(groups, str_trim(new_var.1, side = "both"))

groups =  groups %>% select(`new_var.1`) #data.frame taht contains the names of the groups


names(groups)[1] <- "care_group"


# 


# 3. Link names and number and type of care homes
# -----------------------------------------------

care_uk = data.frame(groups, check, check.1)



