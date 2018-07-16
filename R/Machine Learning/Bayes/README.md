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

## Credible Intervals:
Gives some percetage (e.g 95%) of the posterior distribution lies within a particular region <br/>
The Credible Interval: An interval of θ that has a 95% chance (or other) of containing the true value of θ given the several assumptions underlying the problem.

* Point estimate -  New estimate using prior information
* alpha1 & beta1: The posterior shape parameters for each player's distribution
* Peak of beta distribution: (alpha - 1) / (alpha + beta - 2); In emprical bayes estimate its alpha / (alpha + beta), but they become indistinguishable for a large alpha and beta
* Credible interval, Clopper-Pearson interval, and Jeffreys interval all start looking identical when:
	+ the evidence is more informative (large n), or
	+ the prior is less informative (small alpha0, small beta0)


