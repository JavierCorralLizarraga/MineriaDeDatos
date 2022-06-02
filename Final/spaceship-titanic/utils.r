loadTrain <- function(){
  if(!file.exists('titanicTrain.rds')){
    train_loc <- 'train.csv'
    
    titanic_train <- read_csv(train_loc, 
                           na = '')
    saveRDS(titanic_train, "titanicTrain.rds")
    print('titanicTrain.rds se bajo y guardo\n')
  }
  else{
    warning('titanicTrain.rds ya existe\n')
    titanic_train <- readRDS("titanicTrain.rds")
  }
  
  return(titanic_train)
}

loadTest <- function(){
  if(!file.exists('titanicTest.rds')){
    test_loc <- 'test.csv'
    
    titanic_test <- read_csv(test_loc, 
                              na = '')
    saveRDS(titanic_test, "titanicTest.rds")
    print('titanicTest.rds se bajo y guardo\n')
  }
  else{
    warning('titanicTest.rds ya existe\n')
    titanic_train <- readRDS("titanicTest.rds")
  }
  
  return(titanic_train)
}

autos_clean_colnames <- function(x){
  str_replace_all(tolower(x),'-','_')
}

tipos_de_graficas <- function(datos, todas=TRUE, lista){
  if(todas == TRUE && missing(lista)) {
    ggpairs(datos)
  }else{
    ggpairs(datos[lista])
  }
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


imputar_por_similitud<-function(data,num_vecinos){
  data$row_num <- seq.int(nrow(data))
  filas_con_na=data[!complete.cases(data),]
  for(row in 1:nrow(filas_con_na)){
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
    matriz_bool<-as.numeric(as.matrix(apply(data_dist_factor[2:nrow(data_dist_factor),],1,function(x) x==data_dist_factor[1,]),ncol=ncol(data_dist_factor)))
    dim(matriz_bool)<-c(nrow(data_dist_factor)-1,ncol(data_dist_factor))
    dist_fact<-apply(as.data.frame(matriz_bool),1,function(x) sqrt(sum(x)))
    dist<-dist_num+dist_fact
    dim(dist)<-c(nrow(data_dist_factor)-1,1)
    dist<-as.data.frame(dist)
    dist$row_num <- seq.int(from=2,to=nrow(data_dist_factor))
    vecinos<-head(dist[order(-dist$V1),],n=num_vecinos)
    vecinos<-data_sin_na[vecinos$row_num,]
    vecinos<-data[vecinos$row_num,columnas_con_na]
    clases=sapply(vecinos,class)
    valores=list()
    for(i in 1:ncol(vecinos)){
      if(clases[i]=="numeric"){
        valor<-mean(t(vecinos[,i]), na.rm = TRUE)
        valores=append(valores,valor)
      }else if(clases[i]=="factor"){
        ren<-which.max(as.data.frame(table(vecinos[,i]))[,2])
        valor<-as.data.frame(table(vecinos[,i]))[which.max(as.data.frame(table(vecinos[,i]))[,2]),1]
        valor<-as.character(valor)
        valores=append(valores,valor)
      }
    }
    filas_con_na[row,columnas_con_na]<-as.data.frame(valores)
    data[fila$row_num,]<-filas_con_na[row,]
  }
  return(data)
}