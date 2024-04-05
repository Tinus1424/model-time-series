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



