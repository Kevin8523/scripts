'''
###################################################
title: Empirical Bayes
author: Kevin Huang
date: 20180715
output: Baseball Example Code
Notes: Example from D.Robinson
R version: 3.5.1: Feather spray # version
###################################################
'''

############################
# Empirical Bayes Estimation
############################
library(dplyr)
library(tidyr)
library(Lahman) # Baseball dataset
library(ggplot2)

# Dataset: AB = At bats , H = Hits, antijoin to remove pitchers

#----------------------------------------------------
# Step0: Setup dataset for analysis
# Filter out pitchers (Just want batters)
career <- Batting %>%
  filter(AB > 0) %>%
  anti_join(Pitching, by = "playerID") %>%
  group_by(playerID) %>%
  summarize(H = sum(H), AB = sum(AB)) %>%
  mutate(average = H / AB)

# Include names along with the player IDs
career <- Master %>%
  tbl_df() %>%
  dplyr::select(playerID, nameFirst, nameLast) %>%
  unite(name, nameFirst, nameLast, sep = " ") %>%
  inner_join(career, by = "playerID") %>%
  dplyr::select(-playerID)
#----------------------------------------------------

#----------------------------------------------------
# Step1: Estimate a prior from all your data
# Histogram of batting averages of all players > 500 AB
career %>%
  filter(AB > 500) %>%
  ggplot(aes(average)) +
  geom_histogram() +
  labs(x = "Average")


library(stats4)

career_filtered <- career %>%
  filter(AB > 500)

# log-likelihood function
# dbetabinom.ab(x, size(trial), alpha, beta, log = )
ll <- function(alpha, beta) {
  x <- career_filtered$H 
  total <- career_filtered$AB
  -sum(VGAM::dbetabinom.ab(x, total, alpha, beta, log = TRUE))
}

# maximum likelihood estimation: mle
# You can use many functions for the fitting: optim, mle, bbmle, etc:
# Finds the alpha and beta
m <- mle(ll, start = list(alpha = 1, beta = 10), method = "L-BFGS-B",
         lower = c(0.0001, .1))

# m <- MASS::fitdistr(career_filtered$average, dbeta,
#                     start = list(shape1 = 1, shape2 = 10))

ab <- coef(m)

alpha0 <- ab[1]
beta0 <- ab[2]

# Visualization of the fit
ggplot(career_filtered) +
  geom_histogram(aes(average, y = ..density..), binwidth = .005) +
  stat_function(fun = function(x) dbeta(x, alpha0, beta0), color = "red",
                size = 1) +
  xlab("Batting average")
#----------------------------------------------------

#----------------------------------------------------
# Step2: Use that distribution as a prior for each indvidiual estimate
# Create Emprical Bayes Estiamte
# Uses the alpha0 and beta0 and applies to dataset
career_eb <- career %>%
  mutate(eb_estimate = (H + alpha0) / (AB + alpha0 + beta0))

# Visual of how Empirical Bayes changed all of the batting avg estimates
# Shrinking torwards the Avg
ggplot(career_eb, aes(x=average, y=eb_estimate, color = AB)) +
  geom_hline(yintercept = alpha0 / (alpha0 + beta0), color = "red", lty = 2) +
  geom_point() +
  geom_abline(color = "red") +
  scale_colour_gradient(trans = "log", breaks = 10 ^ (1:5)) +
  xlab("Batting average") +
  ylab("Empirical Bayes batting average")
#----------------------------------------------------
