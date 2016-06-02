library(shiny)
library(dplyr)
library(RPostgreSQL)
library(ggplot2)
library(DT)
library(rworldmap)


if ("server.R" %in% dir()) {
  setwd("..")
}
#source("4.Baza/auth.R")
source("5.Shiny/auth-public.R")

#########################################################
#ŠTEVILO MRTVIH

shinyServer(function(input, output) {
#  Vzpostavimo povezavo
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
#  Pripravimo tabelo
  tbl.attack <- tbl(conn, "attack")
  tbl.religion <- tbl(conn, "religion")
  tbl.country_religion <- tbl(conn, "country_religion")
  tbl.continent <- tbl(conn, "continent")
  tbl.country <- tbl(conn, "country")
  tbl.in_country <- tbl(conn, "in_country")
  tbl.in_continent <- tbl(conn, "in_continent")

  output$attacks <- DT::renderDataTable({
    # Naredimo poizvedbo
    t <- tbl.attack %>% filter(max_deaths >= input$min[1] && max_deaths <= input$min[2]
                               && injured >= input$min2[1] && injured <= input$min2[2]
                               && dead_perpetrators >= input$min3[1]
                               && dead_perpetrators <= input$min3[2]) %>%
      arrange(max_deaths,injured, dead_perpetrators) %>% data.frame()
    # Vrnemo dobljeno razpredelnico
    d <-inner_join(t,tbl.in_country,by=c("attack_id"="attack"), copy=TRUE) %>% 
      select(Start=start_date, End = end_date, "Max. deaths"=max_deaths, Injured = injured,
             "Dead perpetrators"=dead_perpetrators, Type=type, Country=country, Location=place,
             Perpetrator = perpetrator, "Part of"=part_of)
                                                                                     
    d
  })


##############################################################
#APLIKACIJA 1: ŠTEVILO NAPADOV V POSAMEZNEM MESECU

  # Pripravimo tabelo
    tt <- inner_join(tbl.in_country,tbl.country,by=c("country"="name"))
    ttt <- inner_join(tbl.in_continent,tt)
    ttt1 <- inner_join(ttt,tbl.continent, by=c("continent"="continent_id"))
    ttt2 <- inner_join(ttt1,tbl.country_religion)
    ttt3 <- inner_join(ttt2,tbl.religion, by=c("main_religion"="religion_id")) 
    ttt4 <- inner_join(ttt3,tbl.attack, by=c("attack"="attack_id"))
    #%>% select(name.y=continent,country,place,capital,name,start_date)
    #dala vse podatke v data frame
    #ttt5 <- data.frame(ttt4)
    #prešteje št napadov vsak mesec
    #no_attacks <- count(ttt5,month(start_date))
    
    output$kontinent <- renderUI({
      celine <- data.frame(tbl.continent)
      selectInput("kontinent", "Choose a continent:",
                  choices = c("All" = 0, setNames(celine$continent_id,
                                                  celine$name)))
    })
    
    
    output$napadi1<-   renderTable({
      attack <- data.frame(tbl.attack)
      nap <- tbl.attack %>% filter(input$kontinent & input$religije1 &
                                     input$datum & input$mesec & input$glmesto) %>% data.frame()
    })
    
    output$religije <- renderUI({
      religije <- data.frame(tbl.religion)
      selectInput("religije", "Choose a religion:",
                  choices = c("All" = 0, setNames(religije$religion_id, religije$name )))
    })
    
    output$religije2 <- renderUI({
      religije <- data.frame(tbl.religion)
      selectInput("religije2", "Choose a religion:",
                  choices = c("All" = 0, setNames(religije$religion_id, religije$name )))
    })
  
  meseci <- factor(month.name, levels = month.name, ordered = TRUE)
  
  # Fill in the spot we created for a plot
  output$monthPlot <- renderPlot({
    nap <- ttt4
    if (!is.null(input$kontinent) && input$kontinent != 0) {
      nap <- nap %>% filter(continent_id == input$kontinent)
    }
    if (!is.null(input$religije) && input$religije != 0) {
      nap <- nap %>% filter(main_religion == input$religije)
    }
    nap <- nap %>% group_by(attack_id, mesec = month(start_date)) %>%
      summarise() %>% group_by(mesec) %>%
      summarise(stevilo = count(attack_id)) %>% data.frame()
    manjkajo <- which(! 1:12 %in% nap$mesec)
    nap <- rbind(nap, data.frame(mesec = manjkajo,
                                 stevilo = rep(0, length(manjkajo))))
    # Render a barplot
    ggplot(nap, aes(x = meseci[mesec], y = stevilo)) +
      geom_bar(stat = "identity", fill="#FF9999", colour="black") +
      xlab("Month") + ylab("Number of attacks") + theme_minimal()
  })
##############################################################################################
#APLIKACIJA 2: SEZNAM NAPADOV IN NJIHOVE LASTNOSTI, GLEDE NA VRSTO CELINE, RELIGIJE, Ali glavno mesto napadeno
  
<<<<<<< HEAD
=======
  output$kontinent1 <- renderUI({
    celine <- data.frame(tbl.continent)
    selectInput("kontinent", "Choose a continent:",
                choices = c("All" = 0, setNames(celine$continent_id,
                                                celine$name)))
  })
>>>>>>> 4f0207413b025fd5b821e324ac98d51f072a6d5a
  output$datum <- renderUI({
    MAXdatum <- data.frame(summarize(select(tbl.attack,start_date),max(start_date)))
    MINdatum <- data.frame(summarize(select(tbl.attack,start_date),min(start_date)))
    dateRangeInput("datum",label="Choose a start and end date:",start=as.Date(MINdatum[1,1]),
                   end=as.Date(MAXdatum[1,1]),language="sl", separator = "do", weekstart = 1)
  })    
  
<<<<<<< HEAD
=======
  
  output$religije1 <- renderUI({
    religije1 <- data.frame(tbl.religion)
    selectInput("religije", "Choose a religion:",
                choices = c("All" = 0, setNames(religije1$religion_id,
                                                religije1$name)))
  }) 
  
>>>>>>> 4f0207413b025fd5b821e324ac98d51f072a6d5a
  output$napadi2<-DT::renderDataTable({
    nap1 <- ttt4
    if (!is.null(input$kontinent) && input$kontinent != 0) {
      nap1 <- nap1 %>% filter(continent_id == input$kontinent)
    }
    if (!is.null(input$datum)) {
      nap1 <- nap1 %>% filter(start_date >= input$datum[1],
                            end_date <= input$datum[2])
    }
    if (!is.null(input$religije) && input$religije != 0) {
      nap1 <- nap1 %>% filter(main_religion == input$religije)
    }
    #if (input$mesec != 0) {
    #  nap <- nap %>% filter(month(start_date) == input$mesec)
    #}
    if (input$gl.mesto) {
      nap1 <- nap1 %>% filter(place == capital)
    }
    nap1 %>% select(Start=start_date, End=end_date, Location=place, Country=country,"Continent"=name.y,
                  Tpye= type, "Max. deaths"=max_deaths, "Confirmed victims"=confirmed, Injured=injured, "Dead perpetrators"=dead_perpetrators, Perpetrator=perpetrator, "Parto of"=part_of,
                  Population=population, Area=area,  "Main religion"=name, "Followers"=followers.x, "Proportion (in %)"=proportion.x
                  ) %>%data.frame()
  })
<<<<<<< HEAD

      
      
      
=======
#######################################################################
#APLIKACIJA 3: ZEMLJEVID
  
  output$kontinent2 <- renderUI({
    celine <- data.frame(tbl.continent)
    selectInput("kontinent", "Choose a continent:",
                choices = c("All" = 0, setNames(celine$continent_id,
                                                celine$name)))
  })
  output$datum1 <- renderUI({
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
>>>>>>> 4f0207413b025fd5b821e324ac98d51f072a6d5a
})
