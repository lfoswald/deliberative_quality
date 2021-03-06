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

`del_qual_IRR.R`
* drawing cross-coding sample
* calculation of interrater agreement scores

`del_qual_preprocessing.R`
* exclusion of off-topic discussions
* recoding of some variable (e.g. civility)
* construction of scales 

`del_qual_descriptives.R`
* sample descriptives
* depth x width scatter plot

`del_qual_extension.R`
* calculation of comment length, comment number per thread 
* calculation of toxicity of comments using Google's perspectives API
* multiple models for contstruct validation 
* correlation plot
* method comparison scatter plots

