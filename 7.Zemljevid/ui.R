library(shiny)
shinyUI(fluidPage(
  tabsetPanel(
    tabPanel("Map",
             h2("Map of the world"),
             sidebarLayout(
               sidebarPanel(
                 p("miau")
               ),
                 mainPanel(
                   plotOutput("zemljevid"))
      
    
             )))
  
))