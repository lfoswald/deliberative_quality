#### Automating Deliberative Quality Assessment? #######

library(tidyverse)
library(ggplot2)
library(readr)
library(dplyr)
library(readxl)
library(xtable)
library(knitr)
library(kableExtra)
library(stargazer)
library(writexl)
library(irr)
library(psych)

data_coded <- read_excel("data/temp/data_qual_allthreads_LO.xlsx")

############ FULL SAMPLE ######
data_coded <- data.frame(data_coded)
which(colnames(data_coded)=="conspiracy") #59

# replace NAs with 0
data_coded[23:59][is.na(data_coded[23:59])] <- 0

length(unique(data_coded$id_c)) # 1543 comments
length(unique(data_coded$author_c)) # written by 572 unique authors
length(unique(data_coded$thread_id)) # 524 sub-threads
length(unique(data_coded$id_sub)) # 115 threads
length(unique(data_coded$author_sub)) # 62 unique authors writing the submissions

#### opposing content #####
opposing_data <- data_coded%>%
  filter(opposing == 1)

length(unique(opposing_data$id_c)) # 167 / 1543 opposing comments
length(unique(opposing_data$author_c)) # written by 92 authors
length(unique(opposing_data$thread_id)) # 85 / 524 sub-threads
length(unique(opposing_data$id_sub)) # 20 / 115 threads
length(unique(opposing_data$author_sub)) # written by 15 authors

# unrelated comments 
table(data_coded$type_sub)

thread <- data_coded %>% 
  group_by(id_sub) %>% slice(1)
table(is.na(thread$type_sub))

######## FINAL SAMPLE - DROP UNRELATED THREADS ################

data_final <- data_coded %>% 
  filter(type_sub != 2)%>% # unrelated threads
  filter(!is.na(type_sub)) # drop those where submissions was deleted (we don't have structural information about the thread then!)

length(unique(data_final$id_c)) # 1442 comments
length(unique(data_final$author_c)) # written by 539 unique authors
length(unique(data_final$thread_id)) # 476 sub-threads
length(unique(data_final$id_sub)) # 107 threads
length(unique(data_final$author_sub)) # 58 unique authors writing the submissions

#### opposing content #####
opposing_data <- data_final%>%
  filter(opposing == 1)

length(unique(opposing_data$id_c)) # 167 / 1442 opposing comments
length(unique(opposing_data$author_c)) # written by 92 authors
length(unique(opposing_data$thread_id)) # 85 / 476 sub-threads
length(unique(opposing_data$id_sub)) # 20 / 107 threads
length(unique(opposing_data$author_sub)) # written by 15 authors


##### CONSTRUCT SCALES ################################
# Drop variables with low agreement
# Use mean scores when disagreement for those values in variables with generally high agreement
# Scale variables to make them comparable (substract mean, divide by standard deviation)

# recode respect / civility variables
data_final <- data_final %>% 
  mutate_at(c("civ_cap","civ_ins","civ_sar","civ_lie","civ_ste",
              "civ_sex","civ_rac","civ_pat","civ_thr","civ_vul"), 
            funs(recode(., `1`=0, `0`=1, .default = NaN)))


# summary (mean) value for respect, reciprocity, argumentation,...
data_final <- data_final%>%
  mutate(respect = (civ_cap+civ_ins+civ_sar+civ_lie+civ_ste+civ_sex+civ_vul+
                      civ_rac+civ_pat+civ_thr)/10,
         argumentation = (rat_arg+rat_que+rat_top+rat_rat+rat_mor+rat_bal+
                            rat_del+rat_kno+rat_exp)/9,
         reciprocity = ifelse(rec_use == 1 | rec_pos == 1 | rec_neg == 1, 1, 0),
         deliberation = (respect+argumentation+reciprocity)/3,
         empathy = (emp_cog+emp_emo)/2,
         emotion = (emo_ang+emo_fea+emo_sad)/3)


# add structural information
# Unique authors
data <- data_final%>%
  dplyr::group_by(id_sub)%>%
  dplyr::mutate(unique_authors = n_distinct(author_c))

# Both other width metrics
data1 <- data%>%
  group_by(id_sub, depth_c)%>%
  mutate(width_values = sum(in_degree_com))%>%
  group_by(id_sub)%>%
  mutate(gonzalez_width = max(width_values))

data <- data1%>%
  mutate(del_structure = max_thread_depth*mean_thread_width)%>%
  mutate(del_complexity = max_thread_depth*unique_authors)%>%
  mutate(del_complexity_G = max_thread_depth*gonzalez_width)

# THREAD DATA
thread_data <- data%>%
  dplyr::group_by(id_sub) %>% 
  mutate(respect = mean(respect),
         argumentation = mean(argumentation),
         reciprocity = mean(reciprocity),
         deliberation = mean(deliberation),
         empathy = mean(empathy),
         emotion = mean(emotion),
         humor = mean(humor),
         moderate = mean(moderate))%>%
  slice(1)



write.csv(data, file = "data/final/comment_data_preprocessed.csv")
write.csv(thread_data, file = "data/final/thread_data_preprocessed.csv")






