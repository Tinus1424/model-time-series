################################################################################
# Date: 05/04/2024
# Author: Martijn van 't Zelfden
# Project: Modeling time series data
#
################################################################################

# 1. Importing libraries -------------------------------------------------------

library(tidyverse) # Foundational packages, such as dplyr and ggplot
library(tidymodels) # Package for modeling data
library(timetk)
library(lubridate)
library(modeltime)
tidymodels_prefer() # Prefers tidymodel function names over conflicting names

# 2. Importing the dataset -----------------------------------------------------
setwd("~/1_r/modelingtimeseries/code")

df <- as_tibble(readRDS("../data/sales.RDS"))

# 3. Exploratory data analysis -------------------------------------------------

soldMost <- names(which.max(table(df$artikelcode)))

df <- df |> 
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

splits <- time_series_split(
  data,
  assess = "3 months",
  cumulative = TRUE
)

splits |> 
  tk_time_series_cv_plan() |> 
  plot_time_series_cv_plan(datum, aantal)

model_prophet <- 
  prophet_reg(seasonality_yearly = TRUE
              ) |> 
  set_engine("prophet"
             ) |> 
  fit(aantal ~ datum, training(splits)
  )

model_glmnet <- linear_reg(penalty = 0.01) |> 
  set_engine("glmnet") |> 
  fit(
    aantal ~ wday(datum, label = TRUE)
    + month(datum, label = TRUE)
    + as.numeric(datum),
    training(splits)
  )

model_tbl <- modeltime_table(
  model_prophet,
  model_glmnet
)

