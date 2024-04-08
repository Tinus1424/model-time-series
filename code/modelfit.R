################################################################################
# Date: 05/04/2024
# Author: Martijn van 't Zelfden
# Project: Modeling time series data
#
# Description: Wholegame modeling time series data for practice
################################################################################

# Importing libraries ----

source("dataprep.R")

library(tidymodels) # Package for modeling data
library(timetk)
library(lubridate)
library(modeltime)

tidymodels_prefer() # Prefers tidymodel function names over conflicting names
# Splitting the data ----

splits <- time_series_split(
  data,
  assess = "3 months",
  cumulative = TRUE
)

splits |> 
  tk_time_series_cv_plan() |> 
  plot_time_series_cv_plan(datum, aantal)

# Training the prophet model -----

model_prophet <- 
  prophet_reg(seasonality_yearly = TRUE, 
              seasonality_daily = FALSE # Disabled because row is sum of day
              ) |> 
  set_engine("prophet"
             ) |> 
  fit(aantal ~ datum, training(splits)
  )

# Training the GLMNET model -----

model_glmnet <- linear_reg(penalty = 0.01) |> 
  set_engine("glmnet") |> 
  fit(
    aantal ~ wday(datum, label = TRUE) 
    + month(datum, label = TRUE), # Adding "month" as additional predictor
    training(splits)
  )

# Model time table ----
model_tbl <- modeltime_table(
  model_prophet,
  model_glmnet
)

# Predictions and residuals ----
calib_tbl <- model_tbl |> 
  modeltime_calibrate(testing(splits))

# Model Accuracy ----
calib_tbl |> modeltime_accuracy() # Truly terrible scores

# Visualization ----
calib_tbl |> 
  modeltime_forecast(
    new_data = testing(splits),
    actual_data = data
  ) |> 
  plot_modeltime_forecast()

# Forecasting ----
future_forecast_tbl <- calib_tbl |> 
  modeltime_refit(data) |> 
  modeltime_forecast(
    h = "6 months",
    actual_data = data
  )

# Plotting the forecast ----
future_forecast_tbl |> 
  plot_modeltime_forecast()
  