
########################################################
shinyUI(fluidPage(
  
  #########################################################
  #APLIKACIJA 2
  
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
