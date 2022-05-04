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

summary(algas_data)

glimpse(algas_data)

apply(algas_data, 1, function(x) sum(is.na(x)))

algas_data[apply(algas_data, 1, function(x) sum(is.na(x))) > 2,]


library(mice)
md.pattern(algas_data)

library("VIM")
aggr(algas_data, prop=FALSE, numbers=TRUE)

algas_data<-algas_data %>% mutate_at(c(1,2,3),list(as.factor))

matrixplot(algas_data)

x <- as.data.frame(abs(is.na(algas_data))) # df es un data.frame

head(algas_data)

head(x)

# Extrae las variables que tienen algunas celdas con NAs
y <- x[which(sapply(x, sd) > 0)] 

# Da la correación un valor alto positivo significa que desaparecen juntas.
cor(y) 

summary(algas_data[-grep(colnames(algas_data),pattern = "^a[1-9]")])

algas_con_NAs <- algas_data[!complete.cases(algas_data),]

algas_con_NAs[c('max_ph', 'min_o2', 'cl', 'no3', 'nh4', 'opo4', 'po4', 'chla')]  %>%
  print(n = 33)


algas_data %>%
  select(-c(1:3)) %>%
  cor(use="complete.obs") %>%
  symnum()

ggplot(data=algas_data) + 
  aes(x=opo4, y=po4) + 
  geom_point(shape=0) + # Usamos una bolita para los puntos
  geom_smooth(method=lm, se=FALSE) +
  theme_hc()
# Mostramos la linea de la regresión y no mostramos la región de confianza

modelo <- lm(po4 ~ opo4, data=algas_data)

summary(modelo)

imputar_valor_lm<- function(var_independiente,modelo){
  filas_con_na=algas_data[!complete.cases(algas_data[var_independiente]),]
  algas_data[which(is.na(algas_data[var_independiente])),var_independiente]<-as_tibble(predict.lm(modelo,filas_con_na))
  return(algas_data)
}

algas_data_nuevo<-" "

algas_data<-imputar_valor_lm("po4",modelo)


algas_data[which(is.na(algas_data["po4"])),"po4"]<-as_tibble(predict.lm(modelo,filas_con_na))


imputar_por_similitud<-function(data,num_vecinos){
  filas_con_na=data[!complete.cases(data),]
  for(row in rownames(filas_con_na)){
    fila=filas_con_na[row,]
    columnas_con_na=which(is.na(fila))
    for(col in columnas_con_na){
      if(is.factor(data[,col])){
        
      }else if(is.numeric(data[,col])){
        apply(data[,col],1,function(x) sqrt(sum((a - b)^2)))
      }
    }
  }
}

imputar_por_similitud(algas_data,2)
