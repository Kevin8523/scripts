
###################################################
# DATA RESHAPING WITH TIDYR
#
# How to ...
#   - reshape data wide to long:    spread()
#   - reshape data long to wide:    gather()
#   - split a variable:             separate()
#   - combine two varibale values:  unite()
###################################################

library(tidyr)
library(startingDataScience)
#=================================
# GATHER
# - gather() converts wide to long
#
#=================================

# inspect
head(revenue_2_untidy)


# gather()
# - reshape wide to long
# - new key: year
# - new value: income

gather(revenue_2_untidy, quarter, revenue, -region)




#===================================
# SPREAD
# - spread() converts long to wide
#
#===================================

# inspect
print(revenue_tidy)


# spread()
# - reshape long to wide
# - "year" variable holds the values that will become new columns

spread(revenue_tidy , quarter, revenue)




#====================================================
# SEPARATE
# - separate() divides a column into multiple columns
#
#====================================================

# inspect
print(founders)


# separate()
# - break "name" into "first_name" and "last_name"
separate(founders , name , c("first_name","last_name") , sep = " ")




#====================================================
# UNITE
# - unite() combines multiple columns into one column
#
#====================================================


# inspect
print(founders_2)


# unite()
# - combine
unite(founders_2, name, first_name, last_name, sep = " ")

