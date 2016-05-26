library(shiny)


#################################################
#ŠTEVILO MRTVIH
# 
# shinyUI(fluidPage(
# 
#   titlePanel("Napadi - žrtve"),
# 
#   sidebarLayout(
#     sidebarPanel(
#       sliderInput("min",
#                   "Število mrtvih:",
#                   min = 0,
#                   max = 2000,
#                   value = 0 )
#     ),
# 
#     mainPanel(
#       tableOutput("attacks")
#     )
#   )
# ))


######################################################
#ŠTEVILO NAPADOV V POSAMEZNEM MESECU

# Define the overall UI
shinyUI(
  
  # Use a fluid Bootstrap layout
  fluidPage(    
    
    # Give the page a title
    titlePanel("Number of attacks by months"),
    
    # Generate a row with a sidebar
    sidebarLayout(      
      
      # Define the sidebar with one input
      sidebarPanel(
        uiOutput("kontinent"),
        uiOutput("religije"),
        selectInput("continent", "Continents:", 
                    choices=c("Africa","Asia","Europe","North America","Oceania","South America"),
        hr()
      ),
      selectInput("religije", "Religions:", 
                  choices=c("Christian", "Muslim", "Unaffiliated","Hindu","Buddhist","Folk Religion","Other Religion","Jewish"),
                  hr()
      ),
      
      # Create a spot for the barplot
      mainPanel(
        plotOutput("monthPlot")  
      )
      
    )
  )
)
)

########################################################
shinyUI(fluidPage(
  
#########################################################
#APLIKACIJA 1

#SEZNAM NAPADOV IN NJIHOVE LASTNOSTI, GLEDE NA VRSTO CELINE, RELIGIJE, Ali glavno mesto napadeno
  titlePanel('NAPADI'),
  sidebarLayout(
    sidebarPanel(
      uiOutput("kontinent"),
      uiOutput("datum"),
      uiOutput("religije1"),
      SelectInput("mesec", "Choose month:",
                  choices=c("All","January","February", "March", "April"
                                                     , "May", "June", "July", "August", "September",
                                                     "October", "November", "December")),
      SelectInput("gl.mesto", "Pokaži SAMO napade, ki so se zgodili v glavnem mestu:",
                                choices = c("Da" = 1, "Ne" = 0))
      #uiOutput("glmesto"),
    ),
    mainPanel(
      h4("Napadi"),
      tableOutput('napadi1')
    )
  )
####################################################################






#####################################################################
))
