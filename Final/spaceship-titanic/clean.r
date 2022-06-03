clean <- function(titanic){
  titanic <- extract(titanic, 1, into=c("grupo", "id"), regex="([0-9]{4})_([0-9]{2})", remove=TRUE) 
  
  titanic <- extract(titanic, "Cabin", into=c("deck", "room_num", "side"), regex="(.)/(.)/(.)", remove=TRUE) 
  
  titanic <- extract(titanic, "Name", into=c("fname", "lname"), regex="(.*) (.*)", remove=TRUE) 
  
  titanic <- titanic %>% mutate(grupo=as.numeric(grupo)) %>% 
    mutate(id=as.numeric(id)) %>%
    mutate(room_num=as.numeric(room_num)) %>%
    mutate(HomePlanet=as.factor(HomePlanet)) %>%
    mutate(Destination=as.factor(Destination)) %>%
    mutate(deck=as.factor(deck)) %>%
    mutate(side=as.factor(side)) %>%
    mutate(fname=as.factor(fname)) %>%
    mutate(lname=as.factor(lname))
  
  glimpse(titanic)
  
  titanic <- titanic %>% mutate(gastos = RoomService + FoodCourt + ShoppingMall + Spa + VRDeck)
  
  return(titanic)
}
