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


