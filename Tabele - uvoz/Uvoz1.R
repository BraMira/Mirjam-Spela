# Uvozimo potrebne knji≈ænice
library(rvest)
#library(dplyr) 
library(gsubfn)

# LINKI
#Prvi link - januar -junij **
link <- "https://en.wikipedia.org/wiki/List_of_terrorist_incidents,_January%E2%80%93June_2015"
stran <- html_session(link) %>% read_html()
#Drugi link - julij - december**
link2 <- "https://en.wikipedia.org/wiki/List_of_terrorist_incidents,_July%E2%80%93December_2015"
stran2 <- html_session(link2) %>% read_html()
#3.link religije ****
link3 <- "https://en.wikipedia.org/wiki/Religions_by_country"
stran3 <- html_session(link3) %>% read_html()


#4.link drûave - glavna mesta
link4 <- "http://www.go4quiz.com/1023/lworld-countries-and-their-capitals/"
stran4 <- html_session(link4) %>% read_html()



###########################################################################
# TABELE wiki
#MESECI
januar <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[1]] %>% html_table()
februar <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[2]] %>% html_table()
marec <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[3]] %>% html_table()
april <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[4]] %>% html_table()
maj <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[5]] %>% html_table()
junij <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[6]] %>% html_table()
julij <- stran2 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[1]] %>% html_table()
avgust <- stran2 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[2]] %>% html_table()
september <- stran2 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[3]] %>% html_table()
oktober <- stran2 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[4]] %>% html_table()
november <- stran2 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[5]] %>% html_table()
december <- stran2 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[6]] %>% html_table()

#RELIGIJE
religije <- stran3 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[1]] %>% html_table()


#######################################################################################################
#AREA in POPULATION
source("Tabele - uvoz/xml.r", encoding="UTF-8")
cat("Uvaûam podatke")
area <- uvozi.area()

#KONTINENTI
uvozi1 <- function() {
  return(read.csv("Tabele - uvoz/Kontinenti.csv", sep = ";", as.is = TRUE,
                  row.names = 1, na.strings=c("-", "z") ,
                  fileEncoding = "Windows-1250"))
}

cat("Uvaûam podatke ")
kontinenti <- uvozi1()

