
###################################################
## Read Data into R
###################################################

# Get & set working Directory
getwd()
setwd("~/Desktop/Github/scripts/R/dataset")

# csv
dataset <- read.csv("winequality-red.csv", sep = ";")

# read in csv with col names
dataset <- read.csv("winequality-red.csv", sep = ";",
                    col.names = c(1,2,3,4,5,6,7,8,9,10,11,12))

# load data from URL
df <- read.csv(url("https://raw.githubusercontent.com/justmarkham/pandas-videos/master/data/imdb_1000.csv"))

# Choose data
Data <- read.csv(file.choose())

# read in multiple data files; import all files at once
temp = list.files(pattern="*.csv")
for (i in 1:length(temp))
  assign(temp[i], read.csv(temp[i], skip=1, sep=",", quote =""))


###################################################
## Write / Save data in R
###################################################

write.csv(dataset, file = "wine_data.csv")
