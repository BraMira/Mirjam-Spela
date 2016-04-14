# Uvozimo potrebne knjižnice
library(rvest)
#library(dplyr) ta package ne deluje
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
