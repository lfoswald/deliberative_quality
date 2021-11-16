# Automating the Assessment of Deliberative Quality?

This repository contains supplementary material related to a project to aims to complement the assessment of the deliberative quality of online communication with computational approaches.


## 1. Data collection and preprocessing `python`

`data_cc_networks.ipynb`
* Connects to API and collects Reddit data (no not re-run, event specific collection period)
* Constructs comment tree (acyclic graph) structure for each subreddit
* Locates original submission that triggered comment threads/trees

`analysis_cc_networks.ipynb`
* Descriptive exploration and visualization of graph structures
* Combination of structural information with trigger submissions, for all subreddits
* Calculation of maximum in-degree per depth level
* Creation of dataset for further analyses in R

## 2. Analysis `R`

