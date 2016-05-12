# Uvozimo potrebne knjižnice
library(rvest)
#library(dplyr) doma ne dela
library(gsubfn)

#########################################################################################

#RELIGIJE

link3 <- "https://en.wikipedia.org/wiki/Religions_by_country"
stran3 <- html_session(link3) %>% read_html()

religije <- stran3 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[1]] %>% html_table()                                        #RELIGIJE


#######################################################################################################

#KONTINENTI
uvozi1 <- function() {
  return(read.csv("Podatki/Kontinenti.csv", sep = ",", as.is = TRUE,
                  na.strings=c("-", "z") ,
                  fileEncoding = "Windows-1250"))
}

kontinenti <- uvozi1()
celine<- kontinenti[,0:2] #celine - polepšana tabela                #CELINE
############################################################################################

#GLAVNA MESTA

library(rvest)
library(dplyr)
url.mesta <- "http://www.go4quiz.com/1023/lworld-countries-and-their-capitals/"
stran <- html_session(url.mesta) %>% read_html()

gl.mesta <- stran %>% html_nodes(xpath="//table") %>%
  .[[1]] %>% html_table()

gl.mesta$"No." <- NULL              #GL.MESTA


##########################################################################################

#DRŽAVE - area, population 
library(XML)
ustvari_area<- function(){
  naslov <- "http://www.infoplease.com/ipa/A0004379.html"
  area <- readHTMLTable(naslov, which=2, skip.rows = 1, stringsAsFactors = FALSE)
}
area.pop <- ustvari_area()                                        #AREA.POP

############################################################################################


