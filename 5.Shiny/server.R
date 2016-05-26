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

# shinyServer(function(input, output) {
#   
#   conn <- src_postgres(dbname = db, host = host,
#                        user = user, password = password)
#   
#   # Pripravimo tabelo
#   tbl.attack <- tbl(conn, "attack")
#   
#   # Fill in the spot we created for a plot
#   output$meseci <- renderPlot({
#     
#     # Render a barplot
#     barplot(attack[,input$mesec??], 
#             main=input$name,
#             ylab="Število napadov",
#             xlab="Mesec")
#   })
# })
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
    
    
  }))
  
########################################################################################################  
  
