# Uvoz s spletne strani

library(XML)

stripByPath <- function(x, path) {
  unlist(xpathApply(x, path,
                    function(y) gsub("^\\s*(.*?)\\s*$", "\\1", xmlValue(y))))
}

#1. države - area, population ****
library(XML)
ustvari_area<- function(){
  naslov <- "http://www.infoplease.com/ipa/A0004379.html"
  area <- readHTMLTable(naslov, which=2, skip.rows = 1, stringsAsFactors = FALSE)
}
area.pop <- ustvari_area() 


#2. države - glavna mesta (NE DELAAAA)
uvozi.mesta <- function() {
  url.mesta <- "http://www.go4quiz.com/1023/lworld-countries-and-their-capitals/"
  doc.mesta <- htmlTreeParse(url.mesta, useInternalNodes=TRUE)
  
  tabele.mesta <- getNodeSet(doc.mesta, "//table")
  
  vrstice <- getNodeSet(tabele.area[[1]], "./tr") #NE DELA OD TU NAPREJ
  
  seznam <- lapply(vrstice[0:length(vrstice)], stripByPath, "./td")
  
  matrika <- matrix(unlist(seznam), nrow=length(seznam), byrow=TRUE)
  
  r <- data.frame(apply(gsub(",", "", matrika[,0:1]), as.numeric), row.names=matrika[,1])
  return(r)
}

library(XML)
ustvari_mesto<- function(){
  naslov <- "http://www.go4quiz.com/1023/lworld-countries-and-their-capitals/"
  mesto <- readHTMLTable(naslov, which=2, skip.rows = 1, stringsAsFactors = FALSE)
}
mesta<- ustvari_mesto() 