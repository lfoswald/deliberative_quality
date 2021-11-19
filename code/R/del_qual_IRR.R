##### Automating the Assessment of Online Deliberation? ####

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

data_coded <- read_excel("../../data/temp/data_qual_allthreads_LO.xlsx")

############ GET SAMPLE ######
data_coded <- data.frame(data_coded)
data_coded[23:59][is.na(data_coded[23:59])] <- 0
data_final <- data_coded %>% 
  filter(type_sub != 2)%>% # unrelated threads
  filter(!is.na(type_sub)) # drop those where submissions was deleted 

### Checking Inter Coder Agreement

# sample full threads
sample_n_groups <- function(tbl, size, replace = FALSE, weight = NULL) {
  # regroup when done
  grps = tbl %>% groups %>% lapply(as.character) %>% unlist
  # check length of groups non-zero
  keep = tbl %>% summarise() %>% ungroup() %>% sample_n(size, replace, weight)
  # keep only selected groups, regroup because joins change count.
  # regrouping may be unnecessary but joins do something funky to grouping variable
  tbl %>% right_join(keep, by=grps) %>% group_by_(.dots = grps)
}

# sample about 500 comments / third of sample 
data_IRR <- data_coded%>%
  filter(type_sub != 2)%>%
  group_by(id_sub)%>%
  sample_n_groups(40)

#data_IRR%>%
#  group_by(subreddit,wave,opposing)%>%
#  summarize(n())%>%
#  xtable()

#write_xlsx(data_IRR, "data_IRR.xlsx")

data_training <- data_coded%>%
  filter(type_sub != 2)%>%
  group_by(id_sub)%>%
  sample_n_groups(3)

# data_training%>%
#  group_by(subreddit,wave,opposing)%>%
#  summarize(n())%>%
#  xtable()

#write_xlsx(data_training, "data_training.xlsx")

########## CODE CODE CODE #######

IRR_sample_LO <- read_excel("../../data/temp/data_qual_allthreads_LO.xlsx")
IRR_sample_C1 <- read_excel("../../data/temp/Coding_Grace_31.03.21.xlsx")

IRR_sample_C1_coded <- IRR_sample_C1%>%
  filter(!is.na(IRR_sample_C1$civ_rac))

IRR_sample_LO_coded <- IRR_sample_LO%>%
  dplyr::filter(id_c %in% IRR_sample_C1_coded$id_c)%>%
  # replace NAs with 0
  mutate_if(is.numeric, ~replace_na(., 0))

var_names <- c("civ_cap",  "civ_ins"  ,        
               "civ_sar"  ,  "civ_ste"  ,    "civ_sex",  "civ_rac",          
               "civ_vul"  ,  "civ_lie"  ,    "civ_thr",  "civ_pat",          
               "humor"    ,  "rat_que" ,     "rat_top",  "rat_arg",          
               "rat_rat"  ,  "rat_mor"  ,    "rat_bal",  "rat_del",          
               "rat_kno"  ,  "rat_exp"  ,    "rec_use",  "rec_all",          
               "rec_med"  ,  "rec_pos"  ,    "rec_neg",  "emp_emo",          
               "emp_cog"  ,  "emo_ang"  ,    "emo_fea",  "emo_hap",          
               "emo_sad"  ,  "emo_sur"  ,    "emo_dis",  "appeal" )


guilford.g <- function(df){
  po <- agree(df)
  G <- (po$value/100 - 0.5)/0.5 #https://doi.apa.org/doiLanding?doi=10.1037%2Fa0037489
  G
}

perc_agree <- c()
base_rate <- c()
krip_alpha <- c()
guilford_g <- c()

for(var in var_names) {
  dat = cbind(IRR_sample_LO_coded[var],IRR_sample_C1_coded[var])
  
  agree = agree(dat)
  perc_agree = c(perc_agree, agree$value)
  
  base = table(dat)[1]/sum(table(dat))
  base_rate = c(base_rate, base)
  
  krip = kripp.alpha(t(dat))
  krip_alpha = c(krip_alpha, krip$value)
  
  G = guilford.g(dat)
  guilford_g = c(guilford_g, G)
  
}

IRR_summary <- data.frame(var_names, perc_agree, base_rate, guilhermes_g)

IRR_summary%>%
  mutate(across(where(is.numeric), round, 2))%>%
  xtable()%>%
  kable("latex")%>% 
  kable_styling(bootstrap_options = "striped",
                full_width = FALSE,
                position = "center")

