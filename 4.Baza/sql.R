# Neposredno klicanje SQL ukazov v R
library(dplyr)
library(RPostgreSQL)

source("2.Uvoz/uvoz.r", encoding="UTF-8")
source("2.Uvoz/Uvoz1.R",encoding="UTF-8")
source("4.Baza/auth.R")

# Povežemo se z gonilnikom za PostgreSQL
drv <- dbDriver("PostgreSQL")  

#Funkcija, ki nam zbriše tabele, če jih že imamo
delete_table <- function(){
  tryCatch({
    conn <- dbConnect(drv, dbname = db, host = host,
                      user = user, password = password)
    
    #Če tabela obstaja jo zbrišemo, ter najprej zbrišemo tiste, 
    #ki se navezujejo na druge
    dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS country_religion"))
    dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS in_continent"))
    dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS in_country"))
    dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS religion"))
    dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS continent"))
    dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS country"))
    dbSendQuery(conn,build_sql("DROP TABLE IF EXISTS attack"))
    
    
  }, finally = {
    dbDisconnect(conn)
    
  })
}


#Funkcija, ki ustvari tabele
create_table <- function(){
# Uporabimo tryCatch,(da se povežemo in bazo in odvežemo)
# da prisilimo prekinitev povezave v primeru napake
tryCatch({
  # Vzpostavimo povezavo
  conn <- dbConnect(drv, dbname = db, host = host,#drv=s čim se povezujemo
                    user = user, password = password)
  
  #Glavne tabele
  attack <- dbSendQuery(conn,build_sql("CREATE TABLE attack (
                                       attack_id SERIAL PRIMARY KEY,
                                       start_date DATE NOT NULL,
                                       end_date DATE NOT NULL,
                                       type TEXT NOT NULL,
                                       max_deaths INTEGER,
                                       confirmed BOOLEAN NOT NULL,
                                       injured INTEGER,
                                       dead_perpetrators INTEGER,
                                       perpetrator TEXT,
                                       part_of TEXT)"))
  
  dbSendQuery(conn, build_sql("GRANT SELECT ON attack TO javnost"))
  country <- dbSendQuery(conn,build_sql("CREATE TABLE country (
                                        name TEXT PRIMARY KEY NOT NULL,
                                        population INTEGER NOT NULL,
                                        area DECIMAL NOT NULL,
                                        capital TEXT NOT NULL)"))
  dbSendQuery(conn, build_sql("GRANT SELECT ON country TO javnost"))
  continent <- dbSendQuery(conn,build_sql("CREATE TABLE continent (
                                        continent_id SERIAL PRIMARY KEY,
                                        name TEXT NOT NULL)")) 
  dbSendQuery(conn, build_sql("GRANT SELECT ON continent TO javnost"))
  religion <- dbSendQuery(conn,build_sql("CREATE TABLE religion (
                                       religion_id SERIAL PRIMARY KEY,
                                       name TEXT NOT NULL,
                                       followers BIGINT,
                                       proportion DECIMAL)"))
  dbSendQuery(conn, build_sql("GRANT SELECT ON religion TO javnost"))
  in_country <- dbSendQuery(conn, build_sql("CREATE TABLE in_country (
                                          attack INTEGER REFERENCES attack(attack_id),
                                          country TEXT REFERENCES country(name),
                                            place TEXT)"))
  dbSendQuery(conn, build_sql("GRANT SELECT ON in_country TO javnost"))
  in_continent <- dbSendQuery(conn, build_sql("CREATE TABLE in_continent (
                                            continent INTEGER REFERENCES continent(continent_id),
                                            country TEXT REFERENCES country(name))"))
  dbSendQuery(conn, build_sql("GRANT SELECT ON in_continent TO javnost"))
  country_religion <- dbSendQuery(conn, build_sql("CREATE TABLE country_religion ( 
                                                country TEXT REFERENCES country(name),
                                                main_religion INTEGER REFERENCES religion(religion_id),
                                                followers BIGINT,
                                                proportion DECIMAL)"))
  dbSendQuery(conn, build_sql("GRANT SELECT ON country_religion TO javnost"))
  
  
}, finally = {
  # Na koncu nujno prekinemo povezavo z bazo,
  # saj preveč odprtih povezav ne smemo imeti
  dbDisconnect(conn) #PREKINEMO POVEZAVO
  # Koda v finally bloku se izvede, preden program konča z napako
})
}

#Uvoz podatkov
#1. napadi
napad<-read.csv("3.Podatki/napadi.csv",fileEncoding = "Windows-1250")

#2. vsi kontinenti
vsi_kont <- read.csv("3.Podatki/vsi_kont.csv",fileEncoding = "Windows-1250")

#3. vse države
drzave<-read.csv("3.Podatki/drzave.csv",fileEncoding = "Windows-1250",stringsAsFactors=FALSE)
#Uredimo
drzave$population<-as.numeric(gsub(",","",drzave$population))
drzave$area<-as.numeric(gsub(",","",drzave$area))
drzave$country[drzave$country=="Korea, South"] <- "South Korea"
drzave$country[drzave$country=="Korea, North"] <- "North Korea"
drzave$country[drzave$country=="The Bahamas"] <- "Bahamas"
drzave$country[drzave$country=="Micronesia, Federated States of"] <- "Micronesia"
drzave$country[drzave$country=="Myanmar (Burma)"]<- "Burma"
drzave$country[drzave$country=="Timor-Leste"]<- "Timor-Leste"

#4. vse religije
glavne_religije<- read.csv("3.Podatki/glavne_religije.csv",fileEncoding = "Windows-1250")
#religije<-read.csv("3.Podatki/religije.csv",fileEncoding = "Windows-1250")
#religije_relacija <- read.csv("3.Podatki/religije_relacija.csv")

#Funcija, ki vstavi podatke
insert_data <- function(){
  tryCatch({
    conn <- dbConnect(drv, dbname = db, host = host,
                      user = user, password = password)
    
    dbWriteTable(conn, name="attack", napad, append=T, row.names=FALSE)
    dbWriteTable(conn, name="continent",vsi_kont,append=T, row.names=FALSE)
    dbWriteTable(conn, name="country", subset(drzave, select=-X), append=T, row.names=FALSE) 
    dbWriteTable(conn, name="religion", glavne_religije, append=T, row.names=FALSE) 

  }, finally = {
    dbDisconnect(conn) 
    
  })
}

delete_table()
create_table()
insert_data()

con <- src_postgres(dbname = db, host = host, user = user, password = password)

#relacija country_religion
tbl.religion <- tbl(con, "religion")
data.country_religion <- inner_join(religion,
                                    tbl.religion %>% select(religion_id, name),
                                    copy = TRUE) %>%
  select(country, main_religion = religion_id, followers, proportion)

#relacija in_continent
#celine<-read.csv("3.Podatki/celine.csv",fileEncoding = "Windows-1250")

tbl.continent <- tbl(con,"continent")
data.in_continent <- inner_join(celine,
                                tbl.continent %>% select(continent_id, name),
                                copy=TRUE) %>%
  select(continent = continent_id, country)

#relacija in_country
napadi2 <-read.csv("3.Podatki/napadi_drzave.csv",fileEncoding = "Windows-1250")
names(napadi2)<-c("attack_id","country","place")
tbl.attack <-tbl(con,"attack")
data.in_country <- inner_join(napadi2,
                              tbl.attack %>% select(attack_id),
                              copy=TRUE) %>%
  select(attack_id,country,place)

#Funkcija, ki vstavi relacije
insert_relation_data <- function(){
  tryCatch({
    conn <- dbConnect(drv, dbname = db, host = host,
                      user = user, password = password)
    dbWriteTable(conn, name="country_religion", data.country_religion, append=T, row.names=FALSE)
    dbWriteTable(conn, name="in_continent", data.in_continent, append=T, row.names=FALSE)
    dbWriteTable(conn, name="in_country", data.in_country, append=T, row.names=FALSE)

    
  }, finally = {
    dbDisconnect(conn) 
    
  })
}

insert_relation_data()