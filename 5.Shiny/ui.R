library(shiny)
library(DT)


#################################################
#ŠTEVILO MRTVIH
# 
shinyUI(fluidPage(

  titlePanel("Terrorist attacks in 2015"),
  
  tabsetPanel(
    
#############    
    tabPanel("Number of victims",
             h2("Details about attacks with selected casualties"),

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
      DT::dataTableOutput("attacks")
    )
  )
),
# ######################################################
# #APLIKACIJA 1
# #ŠTEVILO NAPADOV V POSAMEZNEM MESECU
# 
##############
    # Give the page a title
      tabPanel("Number of attacks",
               h2("Number of attacks by months"),
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
),
######################################################
#APLIKACIJA 2:SEZNAM NAPADOV IN NJIHOVE LASTNOSTI, GLEDE NA VRSTO CELINE, RELIGIJE, Ali glavno mesto napadeno


    tabPanel("List of attacks",
      h2("List of terrorist attacks in 2015"),
  sidebarLayout(
    sidebarPanel(
      uiOutput("kontinent1"),
      uiOutput("datum"),
      uiOutput("religije1"),
    #selectInput("mesec", "Choose a month:",
    #           choices=c("All" = 0, setNames(1:12, month.name))),
    selectInput("gl.mesto", "Show attacks that happened ONLY in the capital:",
                choices = c("No, show all attacks" = FALSE, "Yes, show attacks in capitals" = TRUE))
    #uiOutput("glmesto"),

  ),
  mainPanel(
    DT::dataTableOutput('napadi2')
  )
)





),


#############################################


  tabPanel("Map",
           h2("Number of attacks by country on a map"),
           sidebarLayout(
             sidebarPanel(
               p("Choose a continent you wish to see on the map more closely."),
               uiOutput("kontinent2"),
               p("Choose a date interval."),
               uiOutput("datum1")
             ),
             mainPanel(
               plotOutput("zemljevid"))
             
             
           ))

)
))
