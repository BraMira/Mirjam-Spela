library(shiny)
shinyUI(fluidPage(
  tabsetPanel(
    tabPanel("Map",
             h2("Map of the world"),
             sidebarLayout(
               sidebarPanel(
                 uiOutput("kontinent"),
                 uiOutput("datum")
               ),
                 mainPanel(
                   plotOutput("zemljevid"))
      
    
             )))
  
))