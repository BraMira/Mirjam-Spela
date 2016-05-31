
########################################################
shinyUI(fluidPage(
  
  #########################################################
  #APLIKACIJA 2
  
  #SEZNAM NAPADOV IN NJIHOVE LASTNOSTI, GLEDE NA VRSTO CELINE, RELIGIJE, Ali glavno mesto napadeno
  titlePanel('SEZNAM TERORISTIČNIH NAPADOV v letu 2015'),
  sidebarLayout(
    sidebarPanel(
      uiOutput("kontinent"),
      uiOutput("datum"),
      uiOutput("religije1"),
      #selectInput("mesec", "Choose month:",
       #           choices=c("All" = 0, setNames(1:12, month.name))),
      selectInput("gl.mesto", "Pokaži SAMO napade, ki so se zgodili v glavnem mestu:",
                  choices = c("Ne, pokaži vse napade" = FALSE, "Da, samo v glavnih mestih" = TRUE))
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
