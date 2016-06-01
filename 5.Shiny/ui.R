library(shiny)


#################################################
#ŠTEVILO MRTVIH
# 
shinyUI(fluidPage(

  titlePanel("Details about attacks with selected casualties"),
  tabsetPanel(
    tabPanel("Info dead",

  sidebarLayout(
    sidebarPanel(
      p("Select the range of dead from which you wish to see the details about."),
      sliderInput("min",
                  "Number of dead:",
                  min = 0,
                  max = 250,
                  value = c(0,233) ),
      p("Select the range of injured from which you wish to see the details about."),
      sliderInput("min2", "Number of injured:",
                  min = 0,
                  max = 510,
                  value = c(0,508)),
      p("Select the range of dead perpetrators from which you wish to see the details about."),
      sliderInput("min3", "Number of dead perpetrators:",
                  min = 0,
                  max = 110,
                  value = c(0,109))
    ),

    mainPanel(
      tableOutput("attacks")
    )
  )
),
######################################################
#APLIKACIJA 1
#ŠTEVILO NAPADOV V POSAMEZNEM MESECU

    # Give the page a title
    titlePanel("Number of attacks by months"),
      tabPanel("Barplot",
    # Generate a row with a sidebar
    sidebarLayout(      
      
      # Define the sidebar with one input
      sidebarPanel(
        p("Choose which continent and/or religion you wish to see plotted."),
        
        uiOutput("kontinent"),
        uiOutput("religije")
    ),
    # Create a spot for the barplot
    mainPanel(
      plotOutput("monthPlot")  
    )
  )
))))
