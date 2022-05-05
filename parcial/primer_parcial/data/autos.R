library(readr)
library(stringr)
library(tidyr)
library(dplyr)
library(ggplot2)
library(ggthemes)

source("metadata.R"  , encoding = 'UTF-8')
source("utils.R"     , encoding = 'UTF-8')
source("00-load.R"   , encoding = 'UTF-8')
source("01-prepare.R", encoding = 'UTF-8')
source("02-clean.R",   encoding = 'UTF-8')

summary(autos_data)

autos_data<-autos_data %>% mutate_at(c(3,4,5,6,7,8,9,10,15,16,18),list(as.factor))

glimpse(autos_data)

graficar_por_tipo <- function(var1, var2){
  if (is.factor(var1) && is.factor(var2)){
    plot(var1, var2)
  }else if(is.numeric(var1) && is.numeric(var2)){
    plot(var1, var2)
  } else { # numeric y factor
    plot(var1, var2)
  }
}

tipos_de_graficas <- function(datos, todas=FALSE, lista){
  if(todas == TRUE && missing(lista)) {
    combn(datos, 2, FUN = graficar_por_tipo)
  }else{
    comb(datos[lista], 2, FUN = graficar_por_tipo)
  }
}

tipos_de_graficas(autos_data,todas = TRUE)
dev.off()
par(mfrow = c(4, 4))
for(col in colnames(select_if(autos_data,is.numeric))){
  hist(t(autos_data[col]),main = sprintf("Histogram of %s",col), xlab =sprintf("%s",col))
}

for(col in colnames(select_if(autos_data,is.numeric))){
  hist(t(autos_data[col]),main = sprintf("Histogram of %s",col), xlab =sprintf("%s",col))
}

hist(autos_data["symboling"])

ggplot(autos_data,aes("symboling"))+
  geom_histogram()

