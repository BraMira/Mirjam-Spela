
########################################################
shinyUI(fluidPage(
  
  #########################################################

titlePanel('Religije1'),
 tabsetPanel(
sidebarLayout(
  sidebarPanel(
    uiOutput("kontinent"),
    selectInput("mesec", "Choose a month:",choices=c("All" = 0, setNames(1:12, month.name)))
  ),
  mainPanel(
    plotOutput('religionPlot1')
  )
)),
 tabsetPanel(
sidebarLayout(
  sidebarPanel(
    uiOutput("kontinentA"),
    selectInput("mesec", "Choose a month:",choices=c("All" = 0, setNames(1:12, month.name)))
  ),
  mainPanel(
    plotOutput('religionPlot2')
  )
))
  
  
  #####################################################################
))
