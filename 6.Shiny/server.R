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
    attack <- data.frame(tbl.attack)
    nap <- tbl.attack %>% filter(input$kontinent & input$religije1 &
                                   input$datum & input$mesec & input$glmesto) %>% data.frame()
  })
  
  
  #gl.mesta
  #place_capital <- left_join(tbl.in_country,tbl.country, by=c("country"="name"),copy=TRUE) %>% select(place,capital)
  ########################################################################################################  
  
  
  
  
  
  ########################################################################################################  
  
})

