library(readr)
library(stringr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(VIM)

source('utils.R')

kNN(titanicTrain, k=10)
