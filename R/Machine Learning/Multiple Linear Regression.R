#Multiple Linear Regression 

###################################################
# Plan & Key Terms:
###################################################
#Assumptions of Linear Regression
# 1. Linearity
# 2. Homoscedasticity
# 3. Multivariate normality
# 4. Independence of errror
# 5. Lack of multicollinearity - Dummy Variable Trap - Always omit 1 dummy variable - R stats package fixes the DVT automatically

#Building A Model
# 1. Backward Elimination
# 2. Select SL = .05
# 3. Add all variables in the model
# 4. Eliminate highest P value - If P value > SL ==> Remove Predictor - High P value menans its not significant 
# 5. Stop when you have highest adjusted R Squared
# 6. Explain in units ==> R&D Spend has a greater impact on profit per unit of R&D spend than marketing has per unit marketing spend.

#Summary
# 1. Is model Statistically Significant? Check F Statistic
# 2. Are Coefficient significant? Check coeficcient t-Statistic & p-value or check the C.I
# 3. Is Model Useful? Check the adjusted R^2
# 4. Does Model fit the data well? Plot the residuals and check regression diagnostics
# 5. Does data satisfy assumption behind linear regression?

#Tips
# F1 to get help
# t-value = std / error ==> Measures the size of the difference relative to the variation in your sample data


###################################################
# Libraries
###################################################
library(MASS)
library(ISLR)
library(ggplot2)
library(car) #For VIF

###################################################
# Set the WD - Macs: /  -  Windows: \\
###################################################
setwd("/Users/kevin8523/Desktop/Windows Stuff Moved Over/Software Tools (Python, R, Tableau,etc)/ML/Machine Learning A-Z Template Folder/Part 2 - Regression/Section 5 - Multiple Linear Regression")
getwd()


###################################################
# Import the dataset:
###################################################
#Import the dataset
#dataset = read.csv('50_Startups.csv')
dataset = Boston # Public / Practice Dataset from library(MASS)


###################################################
# Analyze the data: Data Prep & Data Cleanse - You should usually split the dataset 80/20 or 70/30
###################################################

#Explore
?Boston
names(dataset)
str(dataset)
summary(dataset)
dim(dataset)
head(dataset)


###################################################
# Simple Linear Regression
###################################################

#Simple Linear Regression
lm.fit = lm(medv ~ lstat, data = dataset)

#Explore Fit of linear regression
lm.fit
summary(lm.fit) #summary table

#Additional Exploration functions
names(lm.fit) #list of functions stored in lm.fit
coef(lm.fit)
confint(lm.fit)
predict(lm.fit,data.frame(lstat=(c(5,10,15))),interval = "confidence")
predict(lm.fit,data.frame(lstat=(c(5,10,15))),interval = "prediction")

#Plot Data 
plot(dataset$lstat,dataset$medv) #pch = 20
abline(lm.fit, lwd = 3, col ='red')  
par(mfrow=c(2,2)) # adjusts the windows
plot(lm.fit) #Plots multiple charts
par(mfrow=c(1,1))
plot(predict(lm.fit),residuals(lm.fit))
plot(hatvalues(lm.fit))
which.max(hatvalues(lm.fit))

#Alternate plot type
# ggplot(data = dataset) +
#   geom_point(aes(x = lstat, y = medv))+




###################################################
# Multiple Linear Regression
###################################################
#Call Individual Variables
lm.fit = lm(medv ~ lstat + age, data = Boston)
summary(lm.fit)

#All Variables
lm.fit = lm(medv ~ ., data = Boston)
summary(lm.fit)
summary(lm.fit)$r.sq
vif(lm.fit)

#All Variables minus age
lm.fit = lm(medv ~ .-age, data = Boston)
summary(lm.fit)
par(mfrow=c(1,1)) # adjusts the windows
plot(lm.fit) #Plots multiple charts

#Interaction Terms
lm.fit = lm(medv ~ lstat*age, data = Boston) #lstat*age includes lstat, age, lstat:age (interaction term)
anova(lm.fit)
vcov(lm.fit)

#Non-linear Transformation
lm.fit = lm(medv ~ lstat + I(lstat^2), data = Boston)
summary(lm.fit)

#Anova to compare two models
lm.fit = lm(medv ~ lstat, data = Boston)
lm.fit2 = lm(medv ~ lstat + I(lstat^2), data = Boston)
anova(lm.fit,lm.fit2) #F-Statistic is 135 & p value 0 ==> lm.fit2 Clearly better
plot(lm.fit2)

#Other / Polynomial Transformation
lm.fit5 = lm(medv ~ poly(lstat,5), data = Boston)
summary(lm.fit5)

lm.fit6 = lm(medv ~ log(rm), data = Boston)
summary(lm.fit6)


#Example on Cars Dataset
dataset = Carseats
names(dataset)
summary(dataset)
str(dataset) #Factor ==> Categorical ==> In R you don't need to create dummy variables.
lm.fit = lm(Sales ~ . + Income:Advertising+Price, data = dataset)
summary(lm.fit)
contrasts(dataset$ShelveLoc)

#Backward Stepwise Regression & Forward Stepwise Regression

#Backward Stepwise Regression
full.model <- lm(Sales ~ ., data = dataset)
reduced.model <- step(full.model, direction = "backward")
summary(reduced.model)

#Forward Stepwise Regression
min.model <- lm(Sales ~ 1, data = dataset)
names(dataset)
fwd.model <- step(min.model, direction = "forward", scope = ( ~ CompPrice + Income + Advertising +
                                                                Population + Price + ShelveLoc + Age +
                                                                Education + Urban + US))
summary(fwd.model)




###################################################
# Additional Data Prep
###################################################


# #Encoding categorical data
# dataset$State = factor(dataset$State,
#                        levels = c('New York', 'California', 'Florida'),
#                        labels = c(1,2,3))
# 
# #Splitting the dataset into the Training set and Test set
# set.seed(123)
# split = sample.split(dataset$Profit, SplitRatio = 0.8)
# training_set = subset(dataset, split == TRUE)
# test_set = subset(dataset, split == FALSE)
# 
# 
# # #Feature Scaling 
# # training_set[, 2:3] = scale(training_set[, 2:3])
# # test_set[, 2:3] = scale(test_set[, 2:3])


###################################################
# Data Exploration & Visualization - View the correlations/visualize the data
# Try to find out insightful information
###################################################

#Plot histogram
#Plot


###################################################
# BASELINE MULTIPLE REGRESSION MODEL: 
###################################################
#Fitting Multiple Linear Regression to the Training set
#Step 1 - Selecting all features
regressor = lm(formula = Profit ~ .,
               data = training_set)
summary(regressor)

#Step 2 - Backward Elimination - Features Selected
regressor = lm(formula = Profit ~ R.D.Spend + Marketing.Spend,
              data = training_set)

summary(regressor)

#Predicting the Test set result based on the Training set
y_pred = predict(regressor, newdata = test_set)
y_pred #Compare the prediction with the test_set actual results

#Visualize the data



