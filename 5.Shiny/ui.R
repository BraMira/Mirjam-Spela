library(shiny)


#################################################
#ŠTEVILO MRTVIH
# 
shinyUI(fluidPage(

  titlePanel("Details about attacks with selected casualties"),
  tabsetPanel(
    tabPanel("Number of victims",

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
# ######################################################
# #APLIKACIJA 1
# #ŠTEVILO NAPADOV V POSAMEZNEM MESECU
# 
    # Give the page a title
    titlePanel("Number of attacks by months"),
      tabPanel("Number of attacks",
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
)
######################################################
#APLIKACIJA 2:SEZNAM NAPADOV IN NJIHOVE LASTNOSTI, GLEDE NA VRSTO CELINE, RELIGIJE, Ali glavno mesto napadeno

#   titlePanel('List of terrorist attacks in 2015'),
#     tabPanel("List of attacks",
#   sidebarLayout(
#     sidebarPanel(
#       uiOutput("kontinent"),
#       uiOutput("datum"),
#       uiOutput("religije1"),
#     #selectInput("mesec", "Choose a month:",
#     #           choices=c("All" = 0, setNames(1:12, month.name))),
#     selectInput("gl.mesto", "Show attacks that happened ONLY in the capital:",
#                 choices = c("No, show all attacks" = FALSE, "Yes, show attacks in capitals" = TRUE))
#     #uiOutput("glmesto"),
#   ),
#   mainPanel(
#     tableOutput('napadi2')
#   )
# )
# )
)
))
