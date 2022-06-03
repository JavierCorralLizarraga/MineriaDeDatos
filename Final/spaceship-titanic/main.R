library(readr)
library(stringr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(VIM)
library(feather)

source("utils.r", encoding = "UTF-8")
source("clean.r", encoding = "UTF-8")

titanic_train <- loadTrain()

titanic_train <- clean(titanic_train)

titanic_train <- (kNN(titanic_train, k = 10))[1:19]

path <- "titanic_train.feather"
write_feather(titanic_train, path)

titanic_test <- loadTest()

titanic_test <- clean(titanic_test)

titanic_test <- (kNN(titanic_test, k = 10))[1:18]

path <- "titanic_test.feather"
write_feather(titanic_test, path)
