#Uvozimo napade

# Uvozimo potrebne knjižnice
library(rvest)
library(dplyr) 
library(gsubfn)

#Prvi link
link <- "https://en.wikipedia.org/wiki/List_of_terrorist_incidents,_January%E2%80%93June_2015"
stran <- html_session(link) %>% read_html()
#Drugi link
link2 <- "https://en.wikipedia.org/wiki/List_of_terrorist_incidents,_July%E2%80%93December_2015"
stran2 <- html_session(link2) %>% read_html()

# Shranimo tabele
januar <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[1]] %>% html_table()
januar$month <- 1
februar <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[2]] %>% html_table()
februar$month <- 2
marec <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[3]] %>% html_table()
marec$month <- 3
april <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[4]] %>% html_table()
april$month <- 4
maj <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[5]] %>% html_table()
maj$month <- 5
junij <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[6]] %>% html_table()
junij$month <- 6
julij <- stran2 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[1]] %>% html_table()
julij$month <- 7
avgust <- stran2 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[2]] %>% html_table()
avgust$month <- 8
september <- stran2 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[3]] %>% html_table()
september$month <- 9
oktober <- stran2 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[4]] %>% html_table()
oktober$month <- 10
november <- stran2 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[5]] %>% html_table()
november$month <- 11
december <- stran2 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[6]] %>% html_table()
december$month <- 12

#Združimo tabele
napadi <- do.call("rbind", list(januar,februar, marec,april,maj,junij,julij,avgust,september,oktober,november,december))
napadi$Date1 <- `Encoding<-`(napadi$Date,"UTF-8")
napadi$Injured1 <- `Encoding<-`(napadi$Injured,"UTF-8")
napadi$Location1 <- `Encoding<-`(napadi$Location,"UTF-8")
napadi$Dead[180]<-"8-10"
napadi$Dead[77]<-"10-20(+7)"

napadi$start_date <- napadi$Date1%>% strapplyc("^([0-9]+)") %>% as.numeric()
napadi$end_date <-  napadi$Date1%>% strapplyc("\\–([0-9]+)") %>% as.numeric()
napadi$end_date[is.na(napadi$end_date)]<-0

for(i in 1:length(napadi$Date1)){
  if(napadi$end_date[i] == 0){
    napadi$end_date[i]<-napadi$start_date[i];
  }
}
napadi$end_date[126]<-29;
napadi$confirmed <- NA
napadi$max_deaths <- napadi$Dead %>% strapplyc("\\-([0-9]+)") %>% as.numeric()#napadi$Dead %>% strapplyc("^([0-9]+)") %>% as.numeric()
napadi$max_deaths[is.na(napadi$max_deaths)]<-0
t<-napadi$Dead %>% strapplyc("^([0-9]+)") %>% as.numeric();
for (i in 1:length(napadi$Dead)){
  if(napadi$max_deaths[i]==0){
    napadi$confirmed[i]<-"YES"
    napadi$max_deaths[i]<-t[i]
  }
  else{
    napadi$confirmed[i]<-"NO"
  }
}
napadi$max_deaths[4]<-2000;
napadi$confirmed[c(4,27,30,42,65,88,175,190,196,198,201,208,214,217,219,304,328,374,385)]<-"NO";

napadi$dead_perpetrators <- napadi$Dead %>% strapplyc("\\(\\+([0-9]+)\\)") %>% as.numeric()
napadi$dead_perpetrators[is.na(napadi$dead_perpetrators)]<-0
napadi$city <- 0
napadi$country <-0
for (i in 1:length(napadi$Location1)){
  napadi$city[i]<-strsplit(napadi$Location1,",")[[i]][1];
  napadi$country[i]<-strsplit(napadi$Location1,",")[[i]][2];
  
}
napadi$country[napadi$city=="East Jerusalem"]<- "Jerusalem" 
napadi$country[192]<-"Nigeria"
napadi$city[192]<-NA
napadi$country[266]<-"Pakistan"
napadi$city[266]<-"Quetta"
napadi$city[267]<-"NA"
napadi$country[267]<-"Bhutan"
napadi$country[207]<-"France"
napadi$city[207]<-"Oignies"
napadi$city[369]<-"Abadam"
napadi$country[369]<-"Nigeria"
#spremenimo vrstni red
napadi1 <- napadi[,c("start_date","end_date","month","Type","max_deaths","confirmed","Injured1","dead_perpetrators","country","city","Perpetrator","Part of")] 

#spremenimo imena
names(napadi1)[names(napadi1) %in% c("Type", "Injured1","city","Perpetrator","Part of")]<-c("type","injured","place","perpetrator","part_of") 


# Zapišemo v datoteko CSV
write.csv(napadi1, "Podatki/napadi.csv")