######### Automating the Analysis of Online Deliberation #############

#devtools::install_github("favstats/peRspective")
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

comment_data <- read.csv( "data/final/comment_data_preprocessed.csv")
thread_data <- read.csv("data/final/thread_data_preprocessed.csv")

# Level of analysis: Threads
# Adding alternative measures for 

# 1. Argumentation (length comments)
comment_data$arg_l_coms <- nchar(comment_data$text_c)
hist(comment_data$arg_l_coms)
mean(comment_data$arg_l_coms)

# 2. Reciprocity (N comments)
comment_data$rec_n_coms <- comment_data$n_comments_sub
hist(comment_data$rec_n_coms)
mean(comment_data$rec_n_coms)

# 3. Respect (Toxicity) using Perspective API (Google)
# https://github.com/favstats/peRspective

#usethis::edit_r_environ()
# add:  perspective_api_key="AIzaSyB0dABPIS0t0GkVKJM7mZlG8n4HDmtCcs8"

#test
prsp_score(comment_data$text_c[1], languages = "en",
           score_model = "TOXICITY", doNotStore = TRUE)

#big run
tox_data <- comment_data%>%
  prsp_stream(text = text_c,
              text_id = id_c,
              score_model = c("TOXICITY", "SEVERE_TOXICITY"),
              safe_output = T,
              languages = "en",
              doNotStore = TRUE)

head(tox_data)

comment_data <- left_join(comment_data, tox_data, by = "id_c")

# add scores to thread data
thread_data <- comment_data%>%
  dplyr::group_by(id_sub) %>% 
  mutate(toxicity_a = mean(toxicity),
         argumentation_a = mean(arg_l_coms),
         reciprocity_a = mean(rec_n_coms))%>%
  slice(1)


write.csv(comment_data, file = "data/final/comment_data_tox.csv")
write.csv(thread_data, file = "data/final/thread_data_tox.csv")

### Try to ameliorate automated analysis 
mod1 <- lm(deliberation ~ del_complexity_G, data = data)
mod2 <- lm(deliberation ~ del_complexity, data = data)
mod3 <- lm(deliberation ~ del_complexity_G, data = thread_data)
mod4 <- lm(deliberation ~ del_complexity, data = thread_data)

stargazer(mod1, mod2, mod3, mod4, type = "text", omit = "Constant")

  
  
  
