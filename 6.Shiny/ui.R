
########################################################
shinyUI(fluidPage(
  
  #########################################################
  #APLIKACIJA 2
  
  #SEZNAM NAPADOV IN NJIHOVE LASTNOSTI, GLEDE NA VRSTO CELINE, RELIGIJE, Ali glavno mesto napadeno
  titlePanel('List of terrorist attacks in 2015'),
  sidebarLayout(
    sidebarPanel(
      uiOutput("kontinent"),
      uiOutput("datum"),
      uiOutput("religije1"),
      #selectInput("mesec", "Choose a month:",
       #           choices=c("All" = 0, setNames(1:12, month.name))),
      selectInput("gl.mesto", "Show attacks that happened ONLY in the capital:",
                  choices = c("No, show all attacks" = FALSE, "Yes, show attacks in capitals" = TRUE))
      #uiOutput("glmesto"),
    ),
    mainPanel(
      tableOutput('napadi1')
    )
  )
  ####################################################################
  
  
  #Start_date, end_date ne izpiše lepo v tabeli nakoncu
  #ali se lahko spremenijo naslovčki v tabelah? oznake
  #nakoncu v seznamu tudi nekaj o državi - splošne stvari, ali ok 
  
  
  
  #####################################################################
))
