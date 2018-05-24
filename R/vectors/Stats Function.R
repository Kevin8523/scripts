
###################################################
# Computing Basic Statistics
###################################################
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

# Create the Variables 
x <- dataset$Sepal.Length
y <- dataset$Sepal.Width
z <- c(1,2,3,4,5,NA) 

# Basic Stats Function *Note: When there is a NA in the variable, the function will return NA
mean(dataset$Sepal.Length)
median(dataset$Sepal.Length)
sd(x)
var(y)
cor(x, y)
cov(x, y)
mean(z, na.rm = T)

