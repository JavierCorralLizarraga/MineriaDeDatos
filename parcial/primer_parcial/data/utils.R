
load <- function(){
  if(!file.exists('autos.rds')){
    autos_loc <- 'imports-85.csv'
    
    autos_data <- read_csv(algas_url, 
                      col_names = autos_colnames,
                      na = 'XXXXXXX')
    saveRDS(autos_data, "autos.rds")
    print('autos.rds se bajó guardó\n')
  }
  else{
    warning('autos.rds ya existe\n')
    autos_data <- readRDS("autos.rds")
  }
  
  return(autos_data)
}

autos_clean_colnames <- function(x){
  str_replace_all(tolower(x),"/| ",'_')
}

autoss_clean_data <- function(x){
  str_replace_all(tolower(x),"_",'')
}
