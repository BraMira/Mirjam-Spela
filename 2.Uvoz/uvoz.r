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
napadi$Perpetrator1 <- `Encoding<-`(napadi$Perpetrator,"UTF-8")
napadi$`Part of1` <- `Encoding<-`(napadi$`Part of`,"UTF-8")
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
  napadi$city[i]<-trimws(strsplit(napadi$Location1,",")[[i]][1]); #trimws odstrani white space
  napadi$country[i]<-trimws(strsplit(napadi$Location1,",")[[i]][2]);
  
}

napadi$country[napadi$city=="East Jerusalem"]<- "Israel" 
napadi$country[napadi$city=="West Bank"]<- "Palestine" 
napadi$country[napadi$country==" West Bank"]<- "Palestine" 
for (i in 1:length(napadi$country)){
  if (napadi$country[i]==" West Bank" && is.na(napadi$country[i])!=TRUE){
    napadi$country[i]<- "Palestine"
  }
  
}
napadi$country[c(82,91)]<-"Macedonia"
napadi$country[c(159,104)]<-"Afghanistan"
napadi$country[napadi$country==" Borno State"] <- "Nigeria"
napadi$country[c(87,337,329)]<- "United States"
napadi$country[c(230,34,229)]<-"Philippines"
napadi$country[233]<-"Australia"
napadi$city[233]<-"Sydney"
napadi$country[384]<-"Russia"
napadi$country[126]<-"Syria"
napadi$country[c(225,74,75,216)]<-"Egypt"
napadi$country[193]<-"Mali"
napadi$city[192]<-NA
napadi$country[266]<-"Pakistan"
napadi$city[266]<-"Quetta"
napadi$city[267]<-"NA"
napadi$country[184]<-"Israel"
napadi$city[184]<-"Jerusalem"
napadi$country[267]<-"Bhutan"
napadi$country[204]<-"Thailand"
napadi$city[207]<-"Bangkok"
napadi$country[207]<-"France"
napadi$city[207]<-"Oignies"
napadi$city[369]<-"Abadam"
napadi$country[c(369,192)]<-"Nigeria"
#napadi$country[napadi$country=="Borno State"]<-"Nigeria"
#spremenimo vrstni red
napadi1 <- napadi[,c("start_date","end_date","month","Type","max_deaths","confirmed","Injured1","dead_perpetrators","country","city","Perpetrator1","Part of1")] 

#spremenimo imena
names(napadi1)[names(napadi1) %in% c("Type", "Injured1","city","Perpetrator1","Part of1")]<-c("type","injured","place","perpetrator","part_of") 


# Zapišemo v datoteko CSV
write.csv(napadi1, "3.Podatki/napadi.csv")