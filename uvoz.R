library(rvest)
library(dplyr) #ta package ne deluje
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

napadi <- do.call("rbind", list(januar,februar, marec,april,maj,junij,julij,avgust,september,oktober,november,december))

napadi$end_date <- 0
napadi$confirmed <- NA
napadi$max_deaths <- 0
napadi$dead_perpetrators <- 0
napadi$city <- NA
napadi1 <- napadi[,c("Date","end_date","month","Type","max_deaths","confirmed","Injured","dead_perpetrators","Location","city","Perpetrator","Part of","Details","Dead")]

names(napadi1)[names(napadi1) %in% c("Date","Type", "Injured","Location","Perpetrator","Part of")]<-c("start_date","type","injured","country","perpetrator","part_of")
# Zapišemo v datoteko CSV
write.csv(napadi, "napadi.csv")