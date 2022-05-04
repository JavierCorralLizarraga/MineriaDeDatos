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

imputar_central<-function(data){
  clases=sapply(data,class)
  for(i in 1:ncol(data)){
    if(clases[i]=="numeric"){
      valor<-mean(t(data[,i]), na.rm = TRUE)
      data[is.na(data[,i]), i] <- valor
    }else if(clases[i]=="factor"){
      valor<-as.data.frame(table(data[,i]))[which.max(as.data.frame(table(data[,i]))[,2]),1]
      data[is.na(data[,i]), i] <- valor
    }
  }
  return(data)
}


a<-aggregate(algas_data[,1],FUN = function(x) length(unique(x)))

data1[1,3]<-NA
data1<-imputar_central(algas_data)





algas_central<-imputar_central(algas_data)

algas_data<-imputar_valor_lm("po4",modelo)


algas_data[which(is.na(algas_data["po4"])),"po4"]<-as_tibble(predict.lm(modelo,filas_con_na))


imputar_por_similitud<-function(data,num_vecinos){
  data$row_num <- seq.int(nrow(data))
  filas_con_na=data[!complete.cases(data),]
  num_vecinos=4
  for(row in rownames(filas_con_na)){
    data_sin_na<-data[complete.cases(data),]
    dist_num=0
    dist_fact=0
    dist=0
    fila=filas_con_na[row,]
    columnas_con_na=which(is.na(fila))
    data_sin_na<-subset(data_sin_na,select=-columnas_con_na)
    fila_sin_na<-subset(fila,select=-columnas_con_na)
    data_dist=rbind(fila_sin_na,data_sin_na)
    data_dist_num<-scale(data_dist[,unlist(lapply(data_dist,is.numeric))])
    dist_num<-as.matrix(dist(data_dist_num,method = "euclidean"))[2:nrow(data_dist_num),1]
    data_dist_factor<-data_dist[,unlist(lapply(data_dist,is.factor))]
    matriz_bool<-as.numeric(as.matrix(apply(data_dist_factor[2:nrow(data_dist_factor),],1,function(x) x==data_dist_factor[1,]),ncol=3))
    dim(matriz_bool)<-c(nrow(data_dist_factor)-1,3)
    dist_fact<-apply(as.data.frame(matriz_bool),1,function(x) sqrt(sum(x)))
    dist<-dist_num+dist_fact
    dim(dist)<-c(nrow(data_dist_factor)-1,1)
    dist<-as.data.frame(dist)
    dist$row_num <- seq.int(from=2,to=nrow(data_dist_factor))
    vecinos<-head(dist[order(-dist$V1),],n=num_vecinos)
    vecinos<-data_sin_na[vecinos$row_num,]
    vecinos<-data[vecinos$row_num,columnas_con_na]
    clases=sapply(vecinos,class)
    valores=c()
    for(i in 1:ncol(vecinos)){
      if(clases[i]=="numeric"){
        valor<-mean(t(vecinos[,i]), na.rm = TRUE)
        valores=cbind(valores,valor)
      }else if(clases[i]=="factor"){
        valor<-as.data.frame(table(data[,i]))[which.max(as.data.frame(table(data[,i]))[,2]),1]
        valores=cbind(valores,valor)
      }
    }
    filas_con_na[row,columnas_con_na]<-as_tibble(valores)
    data[fila$row_num,]<-filas_con_na[row,]
  }
  return(data)
}





