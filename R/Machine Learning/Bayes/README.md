# Empirical Bayes

## Overview:
	
	* Bayes Theorem
	* Beta Distribution

## Bayes Theorem:

* P(H/E) = P(E/H) x P(H)  /  P(E)
* P(H/E) = Posterior
* P(H) = Prior
* P(E/H) = Likelihood
* P(E) = Normalizer 

## Beta Distribution:

Using the Beta Distribution to represent a probability distribution of probabilities. <br/>
Formula: Beta(alpha + success, Beta + failure)  <br/>
Expected Value (mean): alpha / ( alpha + beta )

* Based on prior information what kind of player would end up like this (i.e: .27 career battier)
* Uses prior information to form a posterior
* Has 2 parameters alpha beta
* Good to model a count of success out of a total

## Empirical Bayes Estimation:

An Approximation to Bayesian methods, if you have alot of data it is a very good approximation <br/>
Using a beta distribution to fit on all observation to improve each individually 

* Typical Bayesian approach is to decide on your priors ahead of time
* Hyperparameters - alpha0 beta0
* Goal: Select parameters to maximize the probability of generating the distribution we see.
* Goes through shrinkage process, Empirical Bayesian Shrinkage towards a Beta prior

Step by Step Guide
1. Estimate a prior from all your data
	* Pick alpha0 and beta0 to mimic the distribution of the historical data
2. Use that distribution as a prior for each individual estimate


