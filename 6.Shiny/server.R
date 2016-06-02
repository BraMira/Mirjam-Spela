library(shiny)
library(dplyr)
library(RPostgreSQL)

if ("server.R" %in% dir()) {
  setwd("..")
}
#source("4.Baza/auth.R")
source("5.Shiny/auth-public.R")
############################################################
shinyServer(function(input, output) { 
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
  
  # # Pripravimo tabelo
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
  religije <- tbl.religion 
  
  ##############################################################################################
  #APLIKACIJA 2
  
  #SEZNAM NAPADOV IN NJIHOVE LASTNOSTI, GLEDE NA VRSTO CELINE, RELIGIJE, Ali glavno mesto napadeno
  
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
  
  
  output$religije1 <- renderUI({
    religije1 <- data.frame(tbl.religion)
    selectInput("religije", "Choose a religion:",
                choices = c("All" = 0, setNames(religije1$religion_id,
                                                religije1$name)))
  })
  
  output$napadi1<-   renderTable({
    nap <- ttt4
    if (!is.null(input$kontinent) && input$kontinent != 0) {
      nap <- nap %>% filter(continent_id == input$kontinent)
    }
    if (!is.null(input$datum)) {
      nap <- nap %>% filter(start_date >= input$datum[1],
                            end_date <= input$datum[2])
    }
    if (!is.null(input$religije) && input$religije != 0) {
      nap <- nap %>% filter(main_religion == input$religije)
    }
    #if (input$mesec != 0) {
    #  nap <- nap %>% filter(month(start_date) == input$mesec)
    #}
    if (input$gl.mesto) {
      nap <- nap %>% filter(place == capital)
    }
    nap %>% select(start_date, end_date, place, country,name.y,
                   type, max_deaths, confirmed, injured, dead_perpetrators, perpetrator, part_of,
                   population, area,  name, followers.x, proportion.x
                   ) %>%data.frame()
  })
  
  
  #gl.mesta
  #place_capital <- left_join(tbl.in_country,tbl.country, by=c("country"="name"),copy=TRUE) %>% select(place,capital)
  ########################################################################################################  
  
  #stevilo napadov za posamezno religijo - na x osi religije, na y št napadov
  religije <- tbl.religion 
  output$religionPlot1 <- renderPlot({
    nap <- ttt4
    if (!is.null(input$kontinent) && input$kontinent != 0) {
      nap <- nap %>% filter(continent_id == input$kontinent)
    }
    if (input$mesec != 0) {
      nap <- nap %>% filter(month(start_date) == input$mesec)}
    
    nap <- nap %>% group_by(attack_id, religion_id, religija = name) %>% 
      summarise() %>% group_by(religion_id, religija) %>%
      summarise(stevilo = count(religija)) %>% data.frame()
        manjkajo <- which(! 1:8 %in% religije$name)
        nap <- rbind(nap, data.frame(religija = manjkajo, stevilo = rep(0, length(manjkajo))))
    # Render a barplot
    ggplot(nap, aes(x = religija, y = stevilo)) +
      geom_bar(stat = "identity", fill="#FF9999", colour="black") +
      xlab("Religion") + ylab("Number of attacks") + theme_minimal()
  })
  
      
  #max_deaths + injured : - na x osi religije, na y max_deaths + injured
  output$religionPlot2 <- renderPlot({
    nap <- ttt4
    if (!is.null(input$kontinent) && input$kontinent != 0) {
      nap <- nap %>% filter(continent_id == input$kontinent)
    }
    if (input$mesec != 0) {
      nap <- nap %>% filter(month(start_date) == input$mesec)}
    
    nap <- nap %>% group_by(religion_id, religija = name, max_deaths,injured) %>% 
      summarise() %>% group_by(religion_id, religija) %>%
      summarise(stevilo = sum(max_deaths,injured)) %>% data.frame()
    manjkajo <- which(! 1:12 %in% nap$mesec)
    nap <- rbind(nap, data.frame(mesec = manjkajo,
                                 stevilo = rep(0, length(manjkajo))))
    # Render a barplot
    ggplot(nap, aes(x = religija2[religija2], y = stevilo)) +
      geom_bar(stat = "identity", fill="#FF9999", colour="black") +
      xlab("Religion") + ylab("Number of attacks") + theme_minimal()
  })
  
  
  ########################################################################################################  
  
})

