titanic_train = loadTrain()

titanic_train <- extract(titanic_train, 1, into=c("grupo", "id"), regex="([0-9]{4})_([0-9]{2})", remove=TRUE) 

titanic_train <- extract(titanic_train, "Cabin", into=c("deck", "room_num", "side"), regex="(.)/(.)/(.)", remove=TRUE) 

titanic_train <- extract(titanic_train, "Name", into=c("fname", "lname"), regex="(.*) (.*)", remove=TRUE) 

titanic_train <- titanic_train %>% mutate(grupo=as.numeric(grupo)) %>% 
  mutate(id=as.numeric(id)) %>%
  mutate(room_num=as.numeric(room_num)) %>%
  mutate(HomePlanet=as.factor(HomePlanet)) %>%
  mutate(Destination=as.factor(Destination)) %>%
  mutate(deck=as.factor(deck)) %>%
  mutate(side=as.factor(side)) %>%
  mutate(fname=as.factor(fname)) %>%
  mutate(lname=as.factor(lname))
