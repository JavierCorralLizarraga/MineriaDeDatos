loadTrain <- function(){
  if(!file.exists('titanicTrain.rds')){
    train_loc <- 'data/train.csv'
    
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
    test_loc <- 'data/test.csv'
    
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
