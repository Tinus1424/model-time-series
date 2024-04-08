################################################################################
# Date: 08/04/2024
# Author: Martijn van 't Zelfden
# Project: Modeling time series data
#
# Description: Practicing and viewing the effect of splits
################################################################################

setwd("~/1_r/modelingtimeseries/code")

library(tidyverse)
library(tidymodels)
library(timetk)

df <- as_tibble(readRDS("../data/sales.RDS"))

?source("modelfit.R")
