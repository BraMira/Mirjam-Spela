library(shiny)
library(dplyr)
library(RPostgreSQL)
library(ggplot2)
library(DT)

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
  
  # output$datum <- renderUI({
  #   MAXdatum <- data.frame(summarize(select(tbl.attack,start_date),max(start_date)))
  #   MINdatum <- data.frame(summarize(select(tbl.attack,start_date),min(start_date)))
  #   dateRangeInput("datum",label="Choose a start and end date:",start=as.Date(MINdatum[1,1]),
  #                  end=as.Date(MAXdatum[1,1]),language="sl", separator = "do", weekstart = 1)
  # })    
  # 
  # output$napadi2<-DT::renderDataTable({
  #   nap1 <- ttt4
  #   if (!is.null(input$kontinent) && input$kontinent != 0) {
  #     nap1 <- nap1 %>% filter(continent_id == input$kontinent)
  #   }
  #   if (!is.null(input$datum)) {
  #     nap1 <- nap1 %>% filter(start_date >= input$datum[1],
  #                           end_date <= input$datum[2])
  #   }
  #   if (!is.null(input$religije) && input$religije != 0) {
  #     nap1 <- nap1 %>% filter(main_religion == input$religije)
  #   }
  #   #if (input$mesec != 0) {
  #   #  nap <- nap %>% filter(month(start_date) == input$mesec)
  #   #}
  #   if (input$gl.mesto) {
  #     nap1 <- nap1 %>% filter(place == capital)
  #   }
  #   nap1 %>% select("start date"=start_date, "end date"=end_date, place, country,"continent"=name.y,
  #                 type, "max deaths"=max_deaths, "confirmed victims"=confirmed, injured, "dead perpetrators"=dead_perpetrators, perpetrator, part_of,
  #                 population, area,  "main religion"=name, "followers"=followers.x, "proportion"=proportion.x
  #                 ) %>%data.frame()
  # })
})
