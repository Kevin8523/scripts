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
