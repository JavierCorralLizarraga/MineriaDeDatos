
load <- function(){
  if(!file.exists('german.rds')){
    german_url <- paste('http://archive.ics.uci.edu/ml',
                        '/machine-learning-databases/statlog',
                        '/german/german.data',
                        sep='')
    german_data <- read_delim(german_url,
                              col_names = FALSE,
                              delim = " ",
                              col_types = cols(
                                .default = col_character(),
                                X2 = col_double(),
                                X5 = col_double(),
                                X8 = col_double(),
                                X11 = col_double(),
                                X13 = col_double(),
                                X16 = col_double(),
                                X18 = col_double(),
                                X21 = col_double()
                              ))
    saveRDS(german_data, "german.rds")
    print('german.rds se bajó y guardó\n')
  }
  else{
    warning('german.rds ya existe\n')
    german_data <- readRDS("german.rds")
  }
  
  return(german_data)
}

german_decode <- function(columna){
  if(is.character(columna)){
    unlist(german_codes[columna],use.names = F)
  }else{
    columna
  }
}

german_clean_colnames <- function(x){
  str_replace_all(tolower(x),"/| ",'_')
}