library(readr)
library(stringr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(VIM)

source("utils.r", encoding = "UTF-8")
source("clean.r", encoding = "UTF-8")

titanic_train = loadTrain()

titanic_train <- (kNN(titanic_train, k = 10))[1:19]
