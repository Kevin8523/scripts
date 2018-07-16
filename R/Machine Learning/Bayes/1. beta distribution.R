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
