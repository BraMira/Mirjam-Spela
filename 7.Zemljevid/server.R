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
  tt <- inner_join(tbl.in_country,tbl.country,by=c("country"="name"))
  ttt <- inner_join(tbl.in_continent,tt)
  ttt1 <- inner_join(ttt,tbl.continent, by=c("continent"="continent_id"))
  ttt2 <- inner_join(ttt1,tbl.country_religion)
  ttt3 <- inner_join(ttt2,tbl.religion, by=c("main_religion"="religion_id")) 
  ttt4 <- inner_join(ttt3,tbl.attack, by=c("attack"="attack_id"))
  
  output$kontinent <- renderUI({
    celine <- data.frame(tbl.continent)
    selectInput("kontinent", "Choose a continent:",
                choices = c("All" = 0, setNames(celine$continent_id,
                                                celine$name)))
  })
  output$datum <- renderUI({
    MAXdatum <- data.frame(summarize(select(tbl.attack,start_date),max(start_date)))
    MINdatum <- data.frame(summarize(select(tbl.attack,start_date),min(start_date)))
    dateRangeInput("datum",label="Choose a start and end date:",start=as.Date(MINdatum[1,1]),
                   end=as.Date(MAXdatum[1,1]),language="sl", separator = "do", weekstart = 1)
  })    
  
#   output$napadi3<-   renderTable({
#     attack <- data.frame(tbl.attack)
#     nap <- tbl.attack %>% filter(input$kontinent & input$religije1 &
#                                    input$datum & input$mesec & input$glmesto) %>% data.frame()
#   
  
  output$zemljevid <- renderPlot({
    nap3 <- ttt4 %>% select(attack,country,continent_id,start_date,end_date)
    world_map <- map_data(map="world")
    world_map <- subset(world_map, region!="Antarctica")
    HH <- nap3 %>% group_by(attack,region=country) %>% summarise() %>% 
      group_by(region) %>% summarise(stevilo=count(attack))%>%data.frame
    
    if (!is.null(input$kontinent) && input$kontinent != 0) {
      HH <- nap3 %>% filter(continent_id == input$kontinent)%>% group_by(attack,region=country) %>% 
        summarise() %>% group_by(region) %>% summarise(stevilo=count(attack))%>%data.frame
    }
    if (!is.null(input$datum)) {
      HH <- nap3 %>% filter(start_date >= input$datum[1],
                            end_date <= input$datum[2])%>% group_by(attack,region=country) %>% summarise() %>% 
        group_by(region) %>% summarise(stevilo=count(attack))%>%data.frame
    }
    #prešeteje v vsaki državi kolko napadov
    #HH <- nap3 %>% group_by(attack,region=country) %>% summarise() %>% 
     # group_by(region) %>% summarise(stevilo=count(attack))%>%data.frame
    HH$region[HH$region=="United States"]<- "USA"
    HH$region[HH$region=="United Kingdom"]<- "UK"
    HHH <- merge(world_map,HH, sort =FALSE, by="region")
    HHH <- HHH[order(HHH$order),]
    
    #grdo
    # qplot(long,lat, data = HHH, group=group, fill=stevilo, geom = "polygon")

    g <- ggplot(HHH)
    g <- g + geom_map(dat=world_map, map=world_map, aes(map_id=region),fill="white", color="#7f7f7f",size=0.25)
    g <- g+ geom_map(map=world_map, aes(map_id=region,fill=HHH$stevilo),size=0.25)
    g <- g+scale_fill_gradient(low="yellow",high="red",name="Number of attacks",guide="colourbar")
    g <- g+expand_limits(x=world_map$long,y=world_map$lat)
    g <- g + labs(x="",y="")
    g <- g+ theme(panel.grid=element_blank(), panel.border=element_blank(),axis.ticks=element_blank(), axis.text=element_blank(),legend.position="top")
#       geom_map(data=HHH, map = world_map, aes(map_id=region, x = long, y=lat, fill=HHH$stevilo))+
#       scale_fill_gradient(low="yellow",high="red",name ="Number of attacks",guide = "colourbar")+ 
#       theme(panel.grid=element_blank(), panel.border=element_blank(),axis.ticks=element_blank(), axis.text=element_blank(),legend.position="top")
    if (input$kontinent==1){
      g <- g+coord_cartesian(xlim=c(-25,60),ylim=c(37,-40))
    }
    if (input$kontinent==2){
      g <- g+coord_cartesian(xlim=c(20,200),ylim=c(-10,80))
    }
    if (input$kontinent==3){
      g<- g+coord_cartesian(xlim=c(-20,59),ylim=c(35,71))
    }
    if (input$kontinent==4){
      g <- g+coord_cartesian(xlim=c(-20,-170),ylim=c(10,80))
    }
    if (input$kontinent==6){
      g <- g+coord_cartesian(xlim=c(-20,-120),ylim=c(-70,20))
    }
    if (input$kontinent==5){
      g <- g+coord_cartesian(xlim=c(80,190),ylim=c(-50,10))
    }
    g
    
  })
  
  
  #europe
  #ggplot() + geom_map(data=world_map, map=world_map, aes(map_id=region, x=long, y=lat))+coord_cartesian(xlim=c(-20,59),ylim=c(35,71))
  
  
})