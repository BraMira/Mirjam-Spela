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
      dateRangeInput("dates", label = h3("Date range")),
      selectInput("kontinent", "Izberi celino:",
                  choices = c("All",tbl.continent$name),
      selectInput("glmesto", "Prikaži samo napade, ki so bili v glavnih mestih:",
                  choices = c("Da","Ne")
    ),
    mainPanel(
      tableOutput('napadi')
    )
  )
))
)
