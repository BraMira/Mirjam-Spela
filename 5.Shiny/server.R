library(shiny)
library(dplyr)
library(RPostgreSQL)
library(lubridate)
library(ggplot2)

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
#APLIKACIJA 1


#ŠTEVILO NAPADOV V POSAMEZNEM MESECU

shinyServer(function(input, output) {
  
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
  
  # Pripravimo tabelo
    tbl.religion <- tbl(conn, "religion")
    tbl.country_religion <- tbl(conn, "country_religion")
    tbl.continent <- tbl(conn, "continent")
    tbl.attack <- tbl(conn, "attack")
    tbl.country <- tbl(conn, "country")
    tbl.in_country <- tbl(conn, "in_country")
    tbl.in_continent <- tbl(conn, "in_continent")
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
      selectInput("religije", "Choose religion:",
                  choices = c("All" = 0, setNames(religije$name, religije$religion_id)))
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
      geom_bar(stat = "identity") + xlab("Mesec") + ylab("Število napadov")
  })
})
