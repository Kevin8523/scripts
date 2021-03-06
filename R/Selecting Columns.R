
###################################################
# Selecting Vector Elements / Selecting Columns
###################################################

# Loading Iris Dataset
dataset <- iris
x <- c(20:200)

#############################
# Selecting Columns by [ ] or Name
#############################
# By [ ] 
dataset[1]
dataset[1:3]
head(dataset[1],10)

x[1]

# By Column Name
names(x) <- c("One", "Two")

# Vectors can only use [ ]
x["One"]

# Dataframes can use either $ or [ ]
dataset$Sepal.Length 
dataset["Sepal.Length"] 


#############################
# Indexing Technique
#############################
x < 24 # Vector is true when x is greater than 24
x[x < 24] # Gives you every value in x that is less than 24

x %% 2 == 0 # Vector is true when x is even
x[x %% 2 == 0] # Returns all the even x values

#############################
# Indexing Technique 2
#############################
# Select all elements greater than the median
x[ x > median(x) ]

# Select all elements in the lower and upper 5%
x[ (x < quantile(x,0.05)) | (x > quantile(x,0.95)) ]

# Select all elements that exceed ±2 standard deviations from the mean
x[ abs(x-mean(x)) > 2*sd(x) ]

# Select all elements that are neither NA nor NULL
x[ !is.na(x) & !is.null(x) ] 

