################################################################################
# Date: 05/04/2024
# Author: Martijn van 't Zelfden
# Project: Modeling time series data
#
# Description: Data and project preparation
################################################################################

library(tidyverse)

setwd("~/1_r/modelingtimeseries/code")

fulldf <- as_tibble(readRDS("../data/sales.RDS"))

soldMost <- names(which.max(table(fulldf$artikelcode)))

df <- fulldf |> 
  filter(artikelcode == soldMost
  ) |> 
  select(relatiecode:inflow)

data <- df |> 
  select(aantal, datum
  )|> 
  mutate(aantal = aantal * -1
  )|> 
  group_by(datum
  )|> 
  summarise(aantal = sum (aantal)
  )
