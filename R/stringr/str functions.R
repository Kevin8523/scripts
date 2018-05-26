
###################################################
## Read Data into R
###################################################
library(stringr)

# load data from URL
df <- read.csv(url("https://raw.githubusercontent.com/justmarkham/pandas-videos/master/data/imdb_1000.csv"))

# replace first occurance
str_replace("aaXaaX", "X", "B")

# replace all occurance
str_replace_all("aaXaaX", "X", "B")

# change to lower case
str_to_lower("ABc")

# change to upper case
str_to_upper("xyZ")