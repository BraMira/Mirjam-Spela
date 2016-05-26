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
# shinyUI(
#   
#   # Use a fluid Bootstrap layout
#   fluidPage(    
#     
#     # Give the page a title
#     titlePanel("Število napadov po kontinentih"),
#     
#     # Generate a row with a sidebar
#     sidebarLayout(      
#       
#       # Define the sidebar with one input
#       sidebarPanel(
#         selectInput("continent", "Kontinenti:", 
#                     choices=rownames(continent$name),
#         hr()
#       ),
#       
#       # Create a spot for the barplot
#       mainPanel(
#         plotOutput("meseci")  
#       )
#       
#     )
#   )
# )
# )

########################################################
#SEZNAM NAPADOV IN NJIHOVE LASTNOSTI, GLEDE NA VRSTO CELINE, RELIGIJE, Ali glavno mesto napadeno
shinyUI(fluidPage(
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
#     mainPanel(
#       tableOutput('napadi')
    )
  )
)
