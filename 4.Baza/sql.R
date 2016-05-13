# Neposredno klicanje SQL ukazov v R
library(dplyr)
library(RPostgreSQL)

source("4.baza/auth.R")

#Vstavi funkcijo za brisanje tabel

# Povežemo se z gonilnikom za PostgreSQL
drv <- dbDriver("PostgreSQL")      

# Uporabimo tryCatch,(da se povežemo in bazo in odvežemo)
# da prisilimo prekinitev povezave v primeru napake
tryCatch({
  # Vzpostavimo povezavo
  conn <- dbConnect(drv, dbname = db, host = host,#drv=s čim se povezujemo
                    user = user, password = password)
  
  #Glavne tabele
  attack <- dbSendQuery(conn,build_sql("CREATE TABLE attack (
                                       attack_id SERIAL PRIMARY KEY,
                                       start_date INTEGER NOT NULL,
                                       end_date INTEGER NOT NULL,
                                       month INTEGER NOT NULL,
                                       type TEXT NOT NULL,
                                       max_deaths INTEGER,
                                       confirmed TEXT NOT NULL,
                                       injured TEXT,
                                       dead_perpetrators INTEGER,
                                       country TEXT NOT NULL,
                                       place TEXT,
                                       perpetrator TEXT,
                                       part_of TEXT)"))
  country <- dbSendQuery(conn,build_sql("CREATE TABLE country (
                                        name TEXT PRIMARY KEY NOT NULL,
                                        capital TEXT NOT NULL,
                                        population INTEGER NOT NULL,
                                        area INTEGER NOT NULL)"))
continent <- dbSendQuery(conn,build_sql("CREATE TABLE continent (
                                        continent_id SERIAL PRIMARY KEY,
                                        name TEXT NOT NULL)")) #mogoče tu še REFERENCES/FOREIGN KEY?
religion <- dbSendQuery(conn,build_sql("CREATE TABLE religion (
                                       religion_id SERIAL PRIMARY KEY,
                                       name TEXT NOT NULL,
                                       followers INTEGER,
                                       proportion INTEGER)"))
  
  
}, finally = {
  # Na koncu nujno prekinemo povezavo z bazo,
  # saj preveč odprtih povezav ne smemo imeti
  dbDisconnect(conn) #PREKINEMO POVEZAVO
  # Koda v finally bloku se izvede, preden program konča z napako
})