library(readr)
library(stringr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(VIM)
library(feather)

titanic_train = loadTrain()

source("utils.r", encoding = "UTF-8")
source("clean.r", encoding = "UTF-8")


titanic_train <- (kNN(titanic_train, k = 10))[1:19]

path <- "titanic_train.feather"
df <- titanic_train
write_feather(df, path)

