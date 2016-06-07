library(shiny)
library(leaflet)
library(DT)


#################################################
#ŠTEVILO MRTVIH
# 
shinyUI(fluidPage(

  titlePanel("Terrorist attacks in 2015"),
  
  tabsetPanel(
    
# ######################################################
    tabPanel("List attacks",
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

# ######################################################

    # Give the page a title
      tabPanel("Attacks by month",
               h2("Number of attacks by month"),
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
  tabPanel("Attacks by religion", h2("Number of attacks by religion"),
           sidebarLayout(
             sidebarPanel(
               p("Choose which continent and/or month you wish to see plotted."),
               uiOutput("kontinent3"),
               selectInput("mesec", "Choose a month:",choices=c("All" = 0, setNames(1:12, month.name)))
             ),
             mainPanel(
               plotOutput('religionPlot1')
             )
           )),
# ######################################################
tabPanel("List victims",
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
  tabPanel("Victims by religion",h2("Number of victims by religion"),
           sidebarLayout(
             sidebarPanel(
               p("Choose which continent and/or month you wish to see plotted."),
               uiOutput("kontinentA"),
               selectInput("mesec1", "Choose a month:",choices=c("All" = 0, setNames(1:12, month.name)))
             ),
             mainPanel(
               plotOutput('religionPlot2')
             )
           )),
#############################################


  # tabPanel("Attacks by country map",
  #          h2("Number of attacks by country on a map"),
  #          sidebarLayout(
  #            sidebarPanel(
  #              p("Choose a continent you wish to see on the map more closely."),
  #              uiOutput("kontinent2"),
  #              #p("Choose a date interval."),
  #              uiOutput("datum1")
  #            ),
  #            mainPanel(
  #              plotOutput("zemljevid"))
  #            
  #            
  #          )),

tabPanel("Attacks by country map",
         h2("Number of attacks by country on map"),
         sidebarLayout(
           sidebarPanel(
             #p("Choose a continent you wish to see on the map more closely."),
             #uiOutput("kontinent2"),
             p("Choose a date interval."),
             uiOutput("datum1")
           ),
           mainPanel(
             leafletOutput("map"))


         ))

)
))
