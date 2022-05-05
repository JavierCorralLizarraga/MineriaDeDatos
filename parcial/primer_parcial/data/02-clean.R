colnames(autos_data) <- autos_clean_colnames(autos_colnames)

problematic_rows <- problems(autos_data)$row

autos_data[problematic_rows,] <- autos_data %>% 
  slice(problematic_rows) %>% 
  unite(col="all", -seq(1:6), sep = "/", remove=TRUE) %>% 
  extract(all, into=c("NO3", "NH4", "resto"), regex="([0-9]*.[0-9]{5})([0-9]*.[0-9]*)/(.*)/NA", remove=TRUE) %>% 
  separate(resto, into=names(autos_data)[9:18], sep="/", remove=TRUE) %>% 
  readr::type_convert() %>% 
  mutate(NO3=as.character(NO3))

autos_data <- autos_data %>% mutate_at(c(2,3), list(autos_clean_data))

autos_data <- readr::type_convert(autos_data)
