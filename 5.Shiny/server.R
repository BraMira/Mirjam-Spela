library(shiny)
library(dplyr)
library(RPostgreSQL)
library(lubridate)

if ("server.R" %in% dir()) {
  setwd("..")
}
source("4.Baza/auth.R")

#########################################################
#ŠTEVILO MRTVIH

#ŠTEVILO MRTVIH
# 
# shinyServer(function(input, output) {
# #  Vzpostavimo povezavo
#   conn <- src_postgres(dbname = db, host = host,
#                        user = user, password = password)
# #  Pripravimo tabelo
#   tbl.attack <- tbl(conn, "attack")
# 
#   output$attacks <- renderTable({
#     # Naredimo poizvedbo
#     # x %>% f(y, ...) je ekvivalentno f(x, y, ...)
#     t <- tbl.attack %>% filter(max_deaths > input$min) %>%
#       arrange(max_deaths) %>% data.frame()
# #     # Čas izpišemo kot niz
# #     t$cas <- as.character(t$cas)
#     # Vrnemo dobljeno razpredelnico
#     t
#   })
# 
# })

##############################################################
#ŠTEVILO NAPADOV V POSAMEZNEM MESECU

shinyServer(function(input, output) {
  
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
  
  output$kontinent <- renderUI({
    celine <- data.frame(tbl.continent)
    selectInput("kontinent", "Choose continent:",
                choices = c("All" = 0, setNames(celine$continent_id,
                                                celine$name)))
  })
    output$religije <- renderUI({
      religije <- data.frame(tbl.religion)
      selectInput("religije", "Choose religion:",
                  choices = c("All" = 0, setNames(religion$name)))
  })
  # Pripravimo tabelo
    tbl.religion <- tbl(conn, "religion")
    tbl.country_religion <- tbl(conn, "country_religion")
    tbl.continent <- tbl(conn, "continent")
    tbl.attack <- tbl(conn, "attack")
    tbl.country <- tbl(conn, "country")
    tbl.in_country <- tbl(conn, "in_country")
    tbl.in_continent <- tbl(conn, "in_continent")
    tt <- inner_join(tbl.in_country,tbl.country,by=c("country"="name"),copy=TRUE)
    ttt <- inner_join(tbl.in_continent,tt,copy =TRUE)
    ttt1 <- inner_join(ttt,tbl.continent, by=c("continent"="continent_id"),copy=TRUE)
    ttt2 <- inner_join(ttt1,tbl.country_religion,copy=TRUE)
    ttt3 <- inner_join(ttt2,tbl.religion, by=c("main_religion"="religion_id"),copy=TRUE) 
    ttt4 <- inner_join(ttt3,tbl.attack %>% select(attack_id,start_date),
                       by=c("attack"="attack_id"),copy=TRUE) %>% select(name.y,country,place,capital,name,start_date)
    
    
  
  # Fill in the spot we created for a plot
  output$monthPlot <- renderPlot({
    
    # Render a barplot
    barplot(, 
            main=input$name,
            ylab="Number of attacks",
            xlab="Month")
  })
})
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
#APLIKACIJA 1

#SEZNAM NAPADOV IN NJIHOVE LASTNOSTI, GLEDE NA VRSTO CELINE, RELIGIJE, Ali glavno mesto napadeno
  
  output$kontinent <- renderUI({
    celine <- data.frame(tbl.continent)
    selectInput("kontinent", "Izberi celino:",
                choices = c("All" = 0, setNames(celine$continent_id,
                                                celine$name)))
  
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
    
  output$napadi1<-   renderTable({
    attack <- data.frame(tbl.napadi)
    nap <- tbl.attack %>% filter(input$kontinent & input$religije1 &input$datum & input$mesec & input$glmesto) %>%
    %>% data.frame()
  
  #gl.mesta
  #place_capital <- left_join(tbl.in_country,tbl.country, by=c("country"="name"),copy=TRUE) %>% select(place,capital)
########################################################################################################  
    
   
    

    
########################################################################################################  
    
  }))
  

