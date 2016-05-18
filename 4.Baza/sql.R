# Neposredno klicanje SQL ukazov v R
library(dplyr)
library(RPostgreSQL)

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
                                       country TEXT NOT NULL,
                                       place TEXT,
                                       perpetrator TEXT,
                                       part_of TEXT)"))
  country <- dbSendQuery(conn,build_sql("CREATE TABLE country (
                                        name TEXT PRIMARY KEY NOT NULL,
                                        population INTEGER NOT NULL,
                                        area DECIMAL NOT NULL,
                                        capital TEXT NOT NULL)"))
  continent <- dbSendQuery(conn,build_sql("CREATE TABLE continent (
                                        continent_id SERIAL PRIMARY KEY,
                                        name TEXT NOT NULL)")) #mogoče tu še REFERENCES/FOREIGN KEY?
  religion <- dbSendQuery(conn,build_sql("CREATE TABLE religion (
                                       religion_id SERIAL PRIMARY KEY,
                                       name TEXT NOT NULL,
                                       followers BIGINT,
                                       proportion DECIMAL)"))
  in_country <- dbSendQuery(conn, build_sql("CREATE TABLE in_country (
                                          attack INTEGER REFERENCES attack(attack_id),
                                          country TEXT REFERENCES country(name))"))
  in_continent <- dbSendQuery(conn, build_sql("CREATE TABLE in_continent (
                                            continent INTEGER REFERENCES continent(continent_id),
                                            country TEXT REFERENCES country(name))"))
  country_religion <- dbSendQuery(conn, build_sql("CREATE TABLE country_religion ( 
                                                country TEXT REFERENCES country(name),
                                                main_religion INTEGER REFERENCES religion(religion_id))"))#mogoče bi tu dodale še dva stolpca followers in proportions?
  
  
}, finally = {
  # Na koncu nujno prekinemo povezavo z bazo,
  # saj preveč odprtih povezav ne smemo imeti
  dbDisconnect(conn) #PREKINEMO POVEZAVO
  # Koda v finally bloku se izvede, preden program konča z napako
})
}

#Uvoz podatkov
napad<-read.csv("3.Podatki/napadi.csv",fileEncoding = "Windows-1250")
celine<-read.csv("3.Podatki/celine.csv",fileEncoding = "Windows-1250")
drzave<-read.csv("3.Podatki/drzave.csv",fileEncoding = "Windows-1250")
drzave$population<-as.numeric(gsub(",","",drzave$population))
drzave$area<-as.numeric(gsub(",","",drzave$area))
glavne_religije<- read.csv("3.Podatki/glavne_religije.csv",fileEncoding = "Windows-1250")
#religije<-read.csv("3.Podatki/religije.csv",fileEncoding = "Windows-1250")
#religije_relacija <- read.csv("3.Podatki/religije_relacija.csv")
vsi_kont <- read.csv("3.Podatki/vsi_kont.csv",fileEncoding = "Windows-1250")
#Funcija, ki vstavi podatke
insert_data <- function(){
  tryCatch({
    conn <- dbConnect(drv, dbname = db, host = host,
                      user = user, password = password)
    
    dbWriteTable(conn, name="attack",napad,append=T,row.names=FALSE)
    dbWriteTable(conn, name="continent",vsi_kont,append=T,row.names=FALSE)
    dbWriteTable(conn, name="country",subset(drzave, select=-X),append=T,row.names=FALSE) 
    dbWriteTable(conn, name="religion",glavne_religije,append=T,row.names=FALSE) 
    
  }, finally = {
    dbDisconnect(conn) 
    
  })
}

delete_table()
create_table()
insert_data()