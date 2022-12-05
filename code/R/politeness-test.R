#### testing polineness package (Yeomans)

library(politeness)


library(peRspective)
library(tidyverse)
library(readr)
library(readxl)
library(xtable)
library(knitr)
library(kableExtra)
library(stargazer)
library(writexl)
library(psych)
library(gridExtra)
library(ggcorrplot)


comment_data <- read.csv( "data/final/comment_data_tox.csv")

names(comment_data)

polite.data<- politeness(comment_data$text_c, parser="none",drop_blank=FALSE)

colMeans(polite.data)

names(polite.data)

politeness::politenessPlot(polite.data,
                           split = comment_data$subreddit,
                           split_levels = c("climatechange","climateskeptics"),
                           split_name = "Subreddit",
                           top_title = "Average Feature Counts")


dim(polite.data)
dim(comment_data)

full_data <- cbind(comment_data, polite.data)

corr_data <- full_data%>%
  dplyr::select(gonzalez_width, max_thread_depth, 
                arg_l_coms, rec_n_coms, TOXICITY, 
                respect, argumentation, reciprocity, empathy, emotion, humor, 
                Hedges, Negative.Emotion, Positive.Emotion, Negation, Swearing, Reasoning)%>%
  mutate_all(~as.numeric(as.character(.)))%>%
  plyr::rename(c(
                 "gonzalez_width" = "Thread Width", 
                 "max_thread_depth" = "Thread Depth",
                 "arg_l_coms" = "Comment Length",
                 "rec_n_coms" = "Number of Replies",
                 "TOXICITY" = "Toxicity",
                 "respect" = "Respect", 
                 "argumentation" = "Argumentation",
                 "reciprocity"  = "Reciprocity",
                 "empathy" = "Empathy", 
                 "emotion" = "Emotion",
                 "humor" = "Humor"
                 
  ))

corr <- round(cor(corr_data, use = "pairwise.complete.obs"), 1)
p.mat <- cor_pmat(corr_data, use = "pairwise.complete.obs")

corr_c_plot <- ggcorrplot(corr, method = "circle", type = "upper", 
                          outline.col = "white",
                          title = "Bivariate Correlations - Comment Level Data", insig = "blank",
                          tl.cex = 8,
                          tl.srt = 90,
                          lab = T, lab_size = 3, show.legend = F)
corr_c_plot

