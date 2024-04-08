################################################################################
# Date: 08/04/2024
# Author: Martijn van 't Zelfden
# Project: Modeling time series data
#
# Description: Practicing and viewing the effect of splits
################################################################################

# Environment preparation ----
source("code/dataprep.R")
library(tidymodels)
library(timetk)
tidymodels_prefer()

# Exploring ----
ggplot(data, aes(x = aantal)) +
  geom_histogram()

# Splitting ----
splitweird <- initial_split(data)

# Splitting this way is not good because the training data does not replicate
# the original pattern, timeseries should be kept together in a split because
# of time itself is a component that captures information and spills to neighbors

splitweird |> 
  tk_time_series_cv_plan() |> 
  plot_time_series_cv_plan(datum, aantal)


split <- time_series_split(
  data,
  assess = "3 months",
  cumulative = TRUE
)


split |> 
  tk_time_series_cv_plan() |> 
  plot_time_series_cv_plan(datum, aantal)

?timetk
