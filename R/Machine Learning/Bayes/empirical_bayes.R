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


####################
# Credible Intervals
####################
library(dplyr)
library(tidyr)
library(Lahman)

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
  inner_join(career, by = "playerID")

# values estimated by maximum likelihood above
alpha0 <- 101.4
beta0 <- 287.3

# Create Emprical Bayes Estiamte
# Uses the alpha0 and beta0 and applies to dataset
career_eb <- career %>%
  mutate(eb_estimate = (H + alpha0) / (AB + alpha0 + beta0))
#----------------------------------------------------

#----------------------------------------------------
# Step1:
# Posterior Distribution - Getting the alpha1 & beta1
career_eb <- career_eb %>%
  mutate(alpha1 = alpha0 + H,
         beta1 = beta0 + AB - H)
#----------------------------------------------------

# Setup data for visualization
yankee_1998 <- c("brosisc01", "jeterde01", "knoblch01", "martiti02", "posadjo01", "strawda01", "willibe02")

yankee_1998_career <- career_eb %>%
  filter(playerID %in% yankee_1998)

library(broom) # inflate
library(ggplot2)

# inflate = gives the range for the batting avg (tails)
yankee_beta <- yankee_1998_career %>%
  inflate(x = seq(.18, .33, .0002)) %>%
  ungroup() %>%
  mutate(density = dbeta(x, alpha1, beta1))

# Visualize Posterior of 1998 Yankee
ggplot(yankee_beta, aes(x, density, color = name)) +
  geom_line() +
  stat_function(fun = function(x) dbeta(x, alpha0, beta0),
                lty = 2, color = "black")


# 95% Credible interval for Derek Jeter
jeter <- yankee_beta %>% filter(name == "Derek Jeter")

jeter_pred <- jeter %>%
  mutate(cumulative = pbeta(x, alpha1, beta1)) %>%
  filter(cumulative > .025, cumulative < .975)

jeter_low <- qbeta(.025, jeter$alpha1[1], jeter$beta1[1])
jeter_high <- qbeta(.975, jeter$alpha1[1], jeter$beta1[1])

jeter %>%
  ggplot(aes(x, density)) +
  geom_line() +
  geom_ribbon(aes(ymin = 0, ymax = density), data = jeter_pred,
              alpha = .25, fill = "red") +
  stat_function(fun = function(x) dbeta(x, alpha0, beta0),
                lty = 2, color = "black") +
  geom_errorbarh(aes(xmin = jeter_low, xmax = jeter_high, y = 0), height = 3.5, color = "red") +
  xlim(.18, .34)

# Table of the 95% Credible Interval
yankee_1998_career <- yankee_1998_career %>%
  mutate(low = qbeta(.025, alpha1, beta1),
         high = qbeta(.975, alpha1, beta1))

# Box plot of 95% credible interval for 1998 Yankees
yankee_1998_career %>%
  mutate(name = reorder(name, eb_estimate)) %>%
  ggplot(aes(eb_estimate, name)) +
  geom_point() +
  geom_errorbarh(aes(xmin = low, xmax = high)) +
  geom_vline(xintercept = alpha0 / (alpha0 + beta0), color = "red", lty = 2) +
  xlab("Estimated batting average (w/ 95% interval)") +
  ylab("Player")

#----------------------------------------------------
# Confidence Interval vs Credible Interval
career_eb <- career_eb %>%
  mutate(low = qbeta(.025, alpha1, beta1),
         high = qbeta(.975, alpha1, beta1))

set.seed(2015)

some <- career_eb %>%
  sample_n(20) %>%
  mutate(name = paste0(name, " (", H, "/", AB, ")"))

frequentist <- some %>%
  group_by(playerID, name, AB) %>%
  do(tidy(binom.test(.$H, .$AB))) %>%
  select(playerID, name, estimate, low = conf.low, high = conf.high) %>%
  mutate(method = "Confidence")

bayesian <- some %>%
  select(playerID, name, AB, estimate = eb_estimate,
         low = low, high = high) %>%
  mutate(method = "Credible")

combined <- bind_rows(frequentist, bayesian)

combined %>%
  # mutate(name = reorder(name, -AB)) %>%
  ggplot(aes(estimate, name, color = method, group = method)) +
  geom_point() +
  geom_errorbarh(aes(xmin = low, xmax = high)) +
  geom_vline(xintercept = alpha0 / (alpha0 + beta0), color = "red", lty = 2) +
  xlab("Estimated batting average") +
  ylab("Player") +
  labs(color = "")
#----------------------------------------------------



####################
# Hypothesis Testing
####################
library(dplyr)
library(tidyr)
library(Lahman)
library(ggplot2)

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
  inner_join(career, by = "playerID")

# values estimated by maximum likelihood 
alpha0 <- 101.4
beta0 <- 287.3

# Posterior Distribution - Getting the alpha1 & beta1
career_eb <- career %>%
  mutate(eb_estimate = (H + alpha0) / (AB + alpha0 + beta0),
         alpha1 = H + alpha0,
         beta1 = AB - H + beta0)
#----------------------------------------------------

#----------------------------------------------------
# Step1: PEP
# Posterior Error Probabilities (PEP)
career_eb %>%
  filter(name == "Hank Aaron")

# Hank Aaron 
career_eb %>%
  filter(name == "Hank Aaron") %>%
  do(data_frame(x = seq(.27, .33, .0002),
                density = dbeta(x, .$alpha1, .$beta1))) %>%
  ggplot(aes(x, density)) +
  geom_line() +
  geom_ribbon(aes(ymin = 0, ymax = density * (x < .3)),
              alpha = .1, fill = "red") +
  geom_vline(color = "red", lty = 2, xintercept = .3)

pbeta(.3, 3850, 8818)

# PEP for all players
career_eb <- career_eb %>%
  mutate(PEP = pbeta(.3, alpha1, beta1))

# Visual of PEP for all players
ggplot(career_eb, aes(PEP)) +
  geom_histogram(binwidth = .02) +
  xlab("Posterior Error Probability (PEP)") +
  xlim(0, 1)

# Visual of relationship of the shrunked batting avg & pep
career_eb %>%
  ggplot(aes(eb_estimate, PEP, color = AB)) +
  geom_point(size = 1) +
  xlab("(Shrunken) batting average estimate") +
  ylab("Posterior Error Probability (PEP)") +
  geom_vline(color = "red", lty = 2, xintercept = .3) +
  scale_colour_gradient(trans = "log", breaks = 10 ^ (1:5))
#----------------------------------------------------

#----------------------------------------------------
# Step1: False Discovery Rate
# Include as many sucess as possible, while ensuring
# that no more than 5% error

# False discovery rate control
by_PEP <- career_eb %>%
  arrange(PEP) %>%
  mutate(rank = row_number()) %>%
  select(rank, name, H, AB, eb_estimate, PEP)

# Top 10 loweset PEP
by_PEP %>%
  head(10) %>%
  knitr::kable()

# Bottom 10 that ARE included 
by_PEP %>%
  slice(90:100) %>%
  knitr::kable()

top_players <- career_eb %>%
  arrange(PEP) %>%
  head(100)

# expected value (the average) of the total number of false positives
# Expect of the 100 top players, 5.8 False Discoveries
sum(top_players$PEP)

# Average PEP
# Same thing as above, expect an error 5.8% of the time
mean(top_players$PEP)

# Sort dataset by PEP
sorted_PEP <- career_eb %>%
  arrange(PEP)

# Average PEP for top 50
# Same process as above but for 50
mean(head(sorted_PEP$PEP, 50))

# Average PEP for top 200
# Same process as above but for 200
mean(head(sorted_PEP$PEP, 200))

# cumulative mean of all the (sorted) posterior error probabilities
career_eb <- career_eb %>%
  arrange(PEP) %>%
  mutate(qvalue = cummean(PEP))
#----------------------------------------------------

#----------------------------------------------------
# Step2: Q-Values
# Control FDR at X%, collect only hypothesis where q < X

# Only add where we stay below the 5% threshold
hall_of_fame <- career_eb %>%
  filter(qvalue < .05)

# Only add where we stay below the 1% threshold
strict_hall_of_fame <- career_eb %>%
  filter(qvalue < .01)

# q-value vs. # of players included
career_eb %>%
  filter(qvalue < .25) %>%
  ggplot(aes(qvalue, rank(PEP))) +
  geom_line() +
  xlab("q-value cutoff") +
  ylab("Number of players included")
#----------------------------------------------------

######################
# Bayesian A/B Testing
######################

library(dplyr)
library(tidyr)
library(Lahman)
library(ggplot2)

#----------------------------------------------------
# Step0: Setup dataset for analysis

# Grab career batting average of non-pitchers
# (allow players that have pitched <= 3 games, like Ty Cobb)
pitchers <- Pitching %>%
  group_by(playerID) %>%
  summarize(gamesPitched = sum(G)) %>%
  filter(gamesPitched > 3)

# Filter out pitchers (Just want batters)
career <- Batting %>%
  filter(AB > 0) %>%
  anti_join(pitchers, by = "playerID") %>%
  group_by(playerID) %>%
  summarize(H = sum(H), AB = sum(AB)) %>%
  mutate(average = H / AB)

# Include names along with the player IDs
career <- Master %>%
  tbl_df() %>%
  dplyr::select(playerID, nameFirst, nameLast) %>%
  unite(name, nameFirst, nameLast, sep = " ") %>%
  inner_join(career, by = "playerID")

# values estimated by maximum likelihood 
alpha0 <- 101.4
beta0 <- 287.3

# Posterior Distribution - Getting the alpha1 & beta1
career_eb <- career %>%
  mutate(eb_estimate = (H + alpha0) / (AB + alpha0 + beta0),
         alpha1 = H + alpha0,
         beta1 = AB - H + beta0)
#----------------------------------------------------



