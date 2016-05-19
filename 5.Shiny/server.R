library(shiny)
library(dplyr)
library(RPostgreSQL)

source("../auth.R")

#########################################################
#ŠTEVILO MRTVIH

shinyServer(function(input, output) {
  # Vzpostavimo povezavo
  conn <- src_postgres(dbname = db, host = host,
                       user = user, password = password)
  # Pripravimo tabelo
  tbl.attack <- tbl(conn, "attack")
  
  output$attacks <- renderTable({
    # Naredimo poizvedbo
    # x %>% f(y, ...) je ekvivalentno f(x, y, ...)
    t <- tbl.attack %>% filter(max_deaths > input$min) %>%
      arrange(max_deaths) %>% data.frame()
#     # Čas izpišemo kot niz
#     t$cas <- as.character(t$cas)
    # Vrnemo dobljeno razpredelnico
    t
  })
  
})

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


