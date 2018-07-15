
###################################################
## Exploration Functions
###################################################
# Movies Dataset
df <- read.csv(url("https://raw.githubusercontent.com/justmarkham/pandas-videos/master/data/imdb_1000.csv"))

# Sample Iris Dataset
dataset <- iris

# Exploring the dataset
head(dataset)
tail(dataset)
dim(dataset)
str(dataset)
summary(dataset)
names(dataset)
levels(dataset$Species)

library(dplyr)
glimpse(dataset)