library(shiny)
library(dplyr)
library(RPostgreSQL)
library(ggplot2)

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
  religije <- tbl.religion %>%
    transmute(religion_id, religija = name, stevilo = 0) %>% data.frame()
  
  ##############################################################################################
  
  output$kontinent <- renderUI({
    celine <- data.frame(tbl.continent)
    selectInput("kontinent", "Choose a continent:",
                choices = c("All" = 0, setNames(celine$continent_id,
                                                celine$name)))
  })

  #stevilo napadov za posamezno religijo - na x osi religije, na y št napadov
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

    # vse <- tbl.religion %>% select(religion_id)
    # tiste<- nap %>% select(religion_id)
    # manjkajo <- which(! tiste %in% vse)
    # nap <- rbind(nap, data.frame(religija = manjkajo, stevilo = rep(0, length(manjkajo))))
    if (nrow(nap) > 0) {
      manjkajo <- which(! religije$religion_id %in% nap$religion_id)
      nap <- rbind(nap, religije[manjkajo,])
    } else {
      nap <- religije
    }
    # Render a barplot
    ggplot(nap, aes(x = religija, y = stevilo)) +
      geom_bar(stat = "identity", fill="#FF9999", colour="black") +
      xlab("Religion") + ylab("Number of attacks") + theme_minimal()
  })
  ########################################################################################################  
  output$kontinentA <- renderUI({
    celine <- data.frame(tbl.continent)
    selectInput("kontinent", "Choose a continent:",
                choices = c("All" = 0, setNames(celine$continent_id,
                                                celine$name)))
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
      summarise(stevilo = sum(max_deaths+injured)) %>% data.frame()
    # manjkajo <- which(! 1:12 %in% nap$mesec)
    # nap <- rbind(nap, data.frame(mesec = manjkajo,
    #                              stevilo = rep(0, length(manjkajo))))
    if (nrow(nap) > 0) {
      manjkajo <- which(! religije$religion_id %in% nap$religion_id)
      nap <- rbind(nap, religije[manjkajo,])
    } else {
      nap <- religije
    }
    # Render a barplot
    ggplot(nap, aes(x = religija, y = stevilo)) +
      geom_bar(stat = "identity", fill="#FF9999", colour="black") +
      xlab("Religion") + ylab("Number of dead and injured") + theme_minimal()
  })
  
  
  ########################################################################################################  
  
})

