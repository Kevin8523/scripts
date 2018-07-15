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
###################
# Beta Distribution
###################
library(dplyr)
library(ggplot2)

# 1,000,000 Trials
num_trials <- 10e6

# Simulation of million with:
# alpha = 81 , beta = 219 (.21-35 with likelihood of .27)
# size of trials 300
simulations <- data_frame(
  true_average = rbeta(num_trials, 81, 219),
  hits = rbinom(num_trials, 300, true_average)
)

# View simulations
simulations


# Filter to hits = 100
hit_100 <- simulations %>%
  filter(hits == 100)

hit_100


# Filter to hits of 60, 80, 100 and plot the distribution
# Shows the True avg with Hits / 300 at bats & probability density
simulations %>%
  filter(hits %in% c(60, 80, 100)) %>%
  ggplot(aes(true_average, color = factor(hits))) +
  geom_density() +
  labs(x = "True average of players with H hits / 300 at-bats",
       color = "H")



############################
# Empirical Bayes Estimation
############################
library(dplyr)
library(tidyr)
library(Lahman) # Baseball dataset
library(ggplot2)

# Dataset: AB = At bats , H = Hits, antijoin to remove pitchers

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



####################
# Credible Intervals
####################
library(dplyr)
library(tidyr)
library(Lahman)

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
  inner_join(career, by = "playerID")

# values estimated by maximum likelihood above
alpha0 <- 101.4
beta0 <- 287.3

career_eb <- career %>%
  mutate(eb_estimate = (H + alpha0) / (AB + alpha0 + beta0))
















library(dplyr)
library(tidyr)
library(Lahman)

# Grab career batting average of non-pitchers
# (allow players that have pitched <= 3 games, like Ty Cobb)
pitchers <- Pitching %>%
  group_by(playerID) %>%
  summarize(gamesPitched = sum(G)) %>%
  filter(gamesPitched > 3)

career <- Batting %>%
  filter(AB > 0) %>%
  anti_join(pitchers, by = "playerID") %>%
  group_by(playerID) %>%
  summarize(H = sum(H), AB = sum(AB)) %>%
  mutate(average = H / AB)

# Add player names
career <- Master %>%
  tbl_df() %>%
  dplyr::select(playerID, nameFirst, nameLast) %>%
  unite(name, nameFirst, nameLast, sep = " ") %>%
  inner_join(career, by = "playerID")

# values estimated by maximum likelihood in Chapter 3
alpha0 <- 101.4
beta0 <- 287.3

# For each player, update the beta prior based on the evidence
# to get posterior parameters alpha1 and beta1
career_eb <- career %>%
  mutate(eb_estimate = (H + alpha0) / (AB + alpha0 + beta0)) %>%
  mutate(alpha1 = H + alpha0,
         beta1 = AB - H + beta0) %>%
  arrange(desc(eb_estimate))
