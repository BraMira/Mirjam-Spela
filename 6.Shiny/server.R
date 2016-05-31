library(shiny)
library(dplyr)
library(RPostgreSQL)

if ("server.R" %in% dir()) {
  setwd("..")
}
source("4.Baza/auth.R")


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
  
  ##############################################################################################
  #APLIKACIJA 2
  
  #SEZNAM NAPADOV IN NJIHOVE LASTNOSTI, GLEDE NA VRSTO CELINE, RELIGIJE, Ali glavno mesto napadeno
  
  output$kontinent <- renderUI({
    celine <- data.frame(tbl.continent)
    selectInput("kontinent", "Izberi celino:",
                choices = c("All" = 0, setNames(celine$continent_id,
                                                celine$name)))
  })
  output$datum <- renderUI({
    MAXdatum <- data.frame(summarize(select(tbl.attack,start_date),max(start_date)))
    MINdatum <- data.frame(summarize(select(tbl.attack,start_date),min(start_date)))
    dateRangeInput("datum",label="Izberi interval za datum začetka:",start=as.Date(MINdatum[1,1]),
                   end=as.Date(MAXdatum[1,1]),language="sl", separator = "do", weekstart = 1)
  })    
  
  
  output$religije1 <- renderUI({
    religije1 <- data.frame(tbl.religion)
    selectInput("religije", "Izberi religije:",
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
    if (input$mesec != 0) {
      nap <- nap %>% filter(month(start_date) == input$mesec)
    }
    if (input$gl.mesto) {
      nap <- nap %>% filter(place == capital)
    }
    nap %>% data.frame()
  })
  
  
  #gl.mesta
  #place_capital <- left_join(tbl.in_country,tbl.country, by=c("country"="name"),copy=TRUE) %>% select(place,capital)
  ########################################################################################################  
  
  
  
  
  
  ########################################################################################################  
  
})

