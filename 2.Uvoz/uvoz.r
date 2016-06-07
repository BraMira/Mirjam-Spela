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
  .[[1]] %>% html_table(fill=TRUE)
januar$month <- 1
februar <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[2]] %>% html_table(fill=TRUE)
februar$month <- 2
marec <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[3]] %>% html_table(fill=TRUE)
marec$month <- 3
april <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[4]] %>% html_table(fill=TRUE)
april$month <- 4
maj <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[5]] %>% html_table(fill=TRUE)
maj$month <- 5
junij <- stran %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[6]] %>% html_table(fill=TRUE)
junij$month <- 6
julij <- stran2 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[1]] %>% html_table(fill=TRUE)
julij$month <- 7
avgust <- stran2 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[2]] %>% html_table(fill=TRUE)
avgust$month <- 8
september <- stran2 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[3]] %>% html_table(fill=TRUE)
september$month <- 9
oktober <- stran2 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[4]] %>% html_table(fill=TRUE)
oktober$month <- 10
november <- stran2 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[5]] %>% html_table(fill=TRUE)
november$month <- 11
december <- stran2 %>% html_nodes(xpath="//table[@class='wikitable sortable']") %>%
  .[[6]] %>% html_table(fill=TRUE)
december$month <- 12

#Združimo tabele
napadi <- do.call("rbind", list(januar,februar, marec,april,maj,junij,julij,avgust,september,oktober,november,december))
napadi$Date1 <- `Encoding<-`(napadi$Date,"UTF-8")
napadi$Injured2 <- `Encoding<-`(napadi$Injured,"UTF-8")
napadi$Location1 <- `Encoding<-`(napadi$Location,"UTF-8")
napadi$Perpetrator1 <- `Encoding<-`(napadi$Perpetrator,"UTF-8")
napadi$`Part of1` <- `Encoding<-`(napadi$`Part of`,"UTF-8")

napadi$Dead[180]<-"8-10"
napadi$Dead[77]<-"10-20(+7)"

napadi$Injured1 <- napadi$Injured2 %>% strapplyc("^([0-9]+)") %>% as.numeric()
napadi$Injured1[is.na(napadi$Injured1)] <- 0
napadi$start<- napadi$Date1%>% strapplyc("^([0-9]+)") %>% as.numeric()
napadi$end <-  napadi$Date1%>% strapplyc("\\–([0-9]+)") %>% as.numeric()
napadi$end[is.na(napadi$end)]<-0

for(i in 1:length(napadi$Date1)){
  if(napadi$end[i] == 0){
    napadi$end[i]<-napadi$start[i];
  }
}
napadi$end[126]<-29;
napadi$start_date <- 0
napadi$end_date <- 0

for (i in 1:length(napadi$month)){
  napadi$start_date[i]<-paste("2015",as.character(napadi$month[i]),as.character(napadi$start[i]),sep="-")
  napadi$end_date[i]<-paste("2015",as.character(napadi$month[i]),as.character(napadi$end[i]),sep="-")
}

napadi$confirmed <- FALSE
#napadi$max_deaths <- napadi$Dead %>% strapplyc("\\-([0-9]+):") %>% as.numeric();#napadi$Dead %>% strapplyc("^([0-9]+)") %>% as.numeric()
napadi$max_deaths <- 0
napadi$max_deaths[c(1,226)]<-25
napadi$max_deaths[c(77,78)]<-20
napadi$max_deaths[128]<-233
napadi$max_deaths[173]<-15
napadi$max_deaths[c(180,182)]<-10
napadi$max_deaths[338]<-6
#napadi$max_deaths[is.na(napadi$max_deaths)]<-0
t<-napadi$Dead %>% strapplyc("^([0-9]+)") %>% as.numeric();
for (i in 1:length(napadi$Dead)){
  if(napadi$max_deaths[i]==0){
    napadi$confirmed[i]<-TRUE
    napadi$max_deaths[i]<-t[i]
  }
  # else{
  #   napadi$confirmed[i]<-"NO"
  # }
}
napadi$max_deaths[4]<-2000;
napadi$max_deaths[62]<-0;
#napadi$confirmed[c(4,27,30,42,65,88,175,190,196,198,201,208,214,217,219,304,328,374,385)]<-"NO";

napadi$dead_perpetrators <- napadi$Dead %>% strapplyc("\\(\\+([0-9]+)\\)") %>% as.numeric()
napadi$dead_perpetrators[is.na(napadi$dead_perpetrators)]<-0
napadi$city <- 0
napadi$country <-NA
for (i in 1:length(napadi$Location1)){
  napadi$city[i]<-trimws(strsplit(napadi$Location1,",")[[i]][1]); #trimws odstrani white space
  napadi$country[i]<-trimws(strsplit(napadi$Location1,",")[[i]][2]);
  
}

#Popravimo narobe izpisane podatke
napadi$country[napadi$city=="East Jerusalem"]<- "Israel" 
napadi$country[napadi$city=="West Bank"]<- "Israel" 
napadi$city[napadi$country=="Sydney"]<-"Sydney"
napadi$country[c(161,106)]<-"Afghanistan"
napadi$country[c(231,35,232)]<-"Philippines"
napadi$country[386]<-"Russia"
napadi$country[128]<-"Syria"
napadi$country[218]<-"Egypt"
napadi$country[195]<-"Mali"
napadi$city[194]<-NA
napadi$country[194]<-"Nigeria"
napadi$country[268]<-"Pakistan"
napadi$city[268]<-"Quetta"
napadi$city[269]<-NA
napadi$country[269]<-"Bhutan"
napadi$country[186]<-"Israel"
napadi$city[186]<-"Jerusalem"
napadi$country[206]<-"Thailand"
napadi$city[206]<-"Bangkok"
napadi$country[209]<-"France"
napadi$city[209]<-"Oignies"
napadi$city[371]<-"Abadam"
napadi$country[371]<-"Nigeria"

#spremenimo vrstni red
napadi1 <- napadi[,c("start_date","end_date","Type","max_deaths","confirmed",
                     "Injured1","dead_perpetrators","country","city","Perpetrator1","Part of1")] 

#Popravimo imena držav
napadi1$country[napadi1$country=="West Bank"]<-"Israel"
napadi1$country[napadi1$country=="Republic of Macedonia"]<-"Macedonia"
napadi1$country[napadi1$country=="Texas"]<-"United States"
napadi1$country[napadi1$country=="California"]<-"United States"
napadi1$country[napadi1$country=="South Carolina"]<-"United States"
napadi1$country[napadi1$country=="Colorado"]<-"United States"
napadi1$country[napadi1$country=="Sydney"]<-"Australia"
napadi1$country[napadi1$country=="Sinai"]<-"Egypt"
napadi1$country[napadi1$country=="Borno State"]<-"Nigeria"

#Popravimo imena perpetratorjev
napadi1$Perpetrator1[15] <- "al-Qaeda in the Arabian Peninsula"
napadi1$Perpetrator1[16] <- "ISIL"
napadi1$Perpetrator1[50] <- "Al-Mourabitoun"
napadi1$Perpetrator1[51] <- "Palestinian man (lone wolf)"
napadi1$Perpetrator1[186] <- "Islamic State affiliate"
napadi1$Perpetrator1[207] <- "Ayoub El Kahzani"
napadi1$Perpetrator1[282] <- "Ansar al-Islam claimed responsibility (not verified)"
napadi1$Perpetrator1[319] <- "Islamic State"

#napadi1$max_deaths[61]<-0

#spremenimo imena stolpcev
names(napadi1)[names(napadi1) %in% c("Type", "Injured1","city",
                                     "Perpetrator1","Part of1")]<-c("type","injured","place",
                                                                    "perpetrator","part_of") 
napadi2<-napadi1[, c("country","place")]
napadi1 <- subset(napadi1,select=-c(country,place))

# Zapišemo v datoteko CSV
write.csv(napadi1, "3.Podatki/napadi.csv")
write.csv(napadi2,"3.Podatki/napadi_drzave.csv")
