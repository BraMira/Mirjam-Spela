library(shiny)
library(dplyr)
library(RPostgreSQL)
library(rworldmap)
library(ggplot2)
# map.world <- map_data(map="world")
# map.world$name_len <- nchar(map.world$region) + sample(nrow(map.world))
# gg <- ggplot()
# gg <- gg+ geom_map(data=map.world, map=map.world, aes(map_id=region, x=long, y=lat, fill=name_len))
# gg <- gg + scale_fill_gradient(low = "green", high = "brown3", guide = "colourbar")
# gg <- gg + coord_equal()
# gg
if ("server.R" %in% dir()) {
  setwd("..")
}
#source("4.Baza/auth.R")
source("5.Shiny/auth-public.R")

shinyServer(function(input, output) { 
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
  tbl.continent <- tbl(conn, "continent")
  tbl.attack <- tbl(conn, "attack")
  tbl.country <- tbl(conn, "country")
  tbl.country_religion <- tbl(conn, "country_religion")
  tbl.in_country <- tbl(conn, "in_country")
  tbl.in_continent <- tbl(conn, "in_continent")
  tbl.religion <- tbl(conn, "religion")
  
  world_map <- map_data(map="world")
  #prešeteje v vsaki državi kolko napadov
  HH <- tbl.in_country %>% group_by(attack,region=country) %>% summarise() %>% 
    group_by(region) %>% summarise(stevilo=count(attack))%>%data.frame
  HH$region[HH$region=="United States"]<- "USA"
  HH$region[HH$region=="United Kingdom"]<- "UK"
  HHH <- HHH[order(HHH$order),]
  
  output$zemljevid <- renderPlot({
    #grdo
    # qplot(long,lat, data = HHH, group=group, fill=stevilo, geom = "polygon")
    ggplot()+geom_map(data=HHH, map = world_map, aes(map_id=region, x = long, y=lat,fill=HHH$stevilo))+
      scale_fill_gradient2(low="green",mid="yellow",high="red", guide = "colourbar")+
      theme_bw()
  })
  
  
  
  
  
  
})