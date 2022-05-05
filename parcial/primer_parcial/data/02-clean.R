colnames(autos_data) <- autos_clean_colnames(autos_colnames)

problematic_rows <- problems(autos_data)$row

autos_data[problematic_rows,] <- autos_data %>% 
  slice(problematic_rows) %>% 
  unite(col="all", -seq(1:13), sep = "/", remove=TRUE) %>% 
  extract(all, into=c("curb-weight", "engine-type", "resto"), regex="(^[0-9]{4})([a-z]{3,5})/(.*)/NA", remove=TRUE) %>%
  separate(resto, into=names(autos_data)[16:26], sep="/", remove=TRUE)%>%
  mutate(across(.cols=19:26, .fns=as.numeric))


autos_data <- readr::type_convert(autos_data)