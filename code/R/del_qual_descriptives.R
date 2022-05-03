#### Automating the Assessment of Deliberative Quality? ######

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


comment_data <- read.csv( "data/final/comment_data_preprocessed.csv")
thread_data <- read.csv("data/final/thread_data_preprocessed.csv")

# date range
comment_data%>%
  group_by(wave)%>%
  summarize(start = min(date),
            end = max(date))

# comment in-degree range 
comment_data%>%
  group_by(subreddit)%>%
  summarize(mean = min(in_degree_com),
            max = max(in_degree_com))


# N comments
comment_data%>%
  group_by(subreddit, wave)%>%
  summarise(n())%>%
  xtable()%>%
  kable()%>% 
  kable_styling(bootstrap_options = "striped",
                full_width = FALSE,
                position = "center")

# N threads
thread_data%>%
  group_by(subreddit, wave)%>%
  summarise(n())%>%
  xtable()%>%
  kable()%>% 
  kable_styling(bootstrap_options = "striped",
                full_width = FALSE,
                position = "center")


#### Depth x Max Width scatter  ####
q <- ggplot(thread_data, aes(max_thread_depth, gonzalez_width))+
  geom_point(aes(colour = as.factor(opposing), size = n_comments_sub), 
             position = position_jitter(width = 2, height = 0),
             alpha = 0.5)+
  theme_bw()+
  facet_grid(vars(wave), vars(subreddit))+
  xlab("Maximum Depth")+
  ylab("Maximum Width")+
  scale_colour_manual(name="Submission Content",
                      labels=c("congruent", "opposing"),
                      values=c("blue","red")) +
  scale_size_continuous(name="Number of Comments")
q
#ggsave(file="output/G_width_depth.pdf",width = 8, height = 6, dpi = 500, q)


