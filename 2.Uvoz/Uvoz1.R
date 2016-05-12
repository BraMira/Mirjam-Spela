# Uvozimo potrebne knjižnice
library(rvest)
#library(dplyr) doma ne dela
library(gsubfn)

#########################################################################################

#RELIGIJE

link3 <- "https://en.wikipedia.org/wiki/Religions_by_country"
stran3 <- html_session(link3) %>% read_html()

religije <- stran3 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[1]] %>% html_table()           #RELIGIJE

names(religije)[1]<- c("Country")

# Zapišemo v datoteko CSV
write.csv(religije, "3.Podatki/religije.csv")
#######################################################################################################

#KONTINENTI
uvozi1 <- function() {
  return(read.csv("2.Uvoz/Kontinenti.csv", sep = ",", as.is = TRUE,
                  na.strings=c("-", "z") ,
                  fileEncoding = "Windows-1250"))
}

kontinenti <- uvozi1()
celine<- kontinenti[,0:2] #celine - polepšana tabela                #CELINE

# Zapišemo v datoteko CSV
write.csv(celine, "3.Podatki/celine.csv")
############################################################################################

#GLAVNA MESTA

library(rvest)
library(dplyr)
url.mesta <- "http://www.go4quiz.com/1023/lworld-countries-and-their-capitals/"
stran <- html_session(url.mesta) %>% read_html()

gl.mesta <- stran %>% html_nodes(xpath="//table") %>%
  .[[1]] %>% html_table()

gl.mesta$"No." <- NULL              #GL.MESTA
names(gl.mesta)<- c("Country","Capital")

##########################################################################################

#DRŽAVE - area, population 
library(XML)
ustvari_area<- function(){
  naslov <- "http://www.infoplease.com/ipa/A0004379.html"
  area <- readHTMLTable(naslov, which=2, stringsAsFactors = FALSE)
}
area.pop <- ustvari_area()                                        #AREA.POP
names(area.pop)<- c("Country", "Population","Area (in sq mi)")

############################################################################################

#UREJANJE PODATKOV - ISTA IMENA
anti_join(gl.mesta, area.pop)
anti_join(area.pop, gl.mesta)

#UREDITEV DRŽAV
gl.mesta$Country[187]<-c("United States")
gl.mesta$Country[63]<-c("Gambia")
gl.mesta$Country[42]<-c("Ivory Coast")
gl.mesta$Country[51]<-c("Timor-Leste")
gl.mesta$Country[126]<-c("Netherlands")
gl.mesta$Country[191]<-c("Vatican City")

area.pop$Country[12]<-c("The Bahamas")
area.pop$Country[42]<-c("Ivory Coast")
area.pop[-c(194),]

#ZDRUŽITEV gl-mest in area
drzave <- inner_join(area.pop, gl.mesta)

#UREDITEV GLAVNIH MEST
drzave$Capital[6]<- c("Saint John's")
drzave$Capital[34]<- c("N'Djamena")
drzave$Capital[67]<- c("Saint George's")
drzave$Capital[81]<- c("Jerusalem")
drzave$Capital[177]<- c("Nuku'alofa")
drzave$Capital[21]<- c("La Paz")
drzave$Capital[123]<- c("Yaren")
drzave$Capital[161]<- c("Cape Town")
drzave$Capital[164]<- c("Colombo")
drzave$Capital[167]<- c("Lobamba")
drzave$Capital[173]<- c("Dodoma")

# Zapišemo v datoteko CSV
write.csv(drzave, "3.Podatki/drzave.csv")

#UREDI ŠE Z CELINAMI
anti_join(drzave, celine)
anti_join(celine,drzave)

#UREDI ŠE Z RELIGIJAMI (pri religijah vsem odstrani prvo črko!!!)
anti_join(drzave, religije)
anti_join(religije,drzave)