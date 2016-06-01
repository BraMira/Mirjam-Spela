library("ggmap")
library(maptools)
library(maps)
library(rworldmap)
library(ggplot2)
visited <- c("Slovenia","Australia")
ll.visited <- geocode(visited)
visit.x <- ll.visited$lon
visit.y <- ll.visited$lat
mp <- NULL
mapWorld <- borders("world", colour="gray50", fill="gray50") # create a layer of borders
mp <- ggplot() +   mapWorld
mp <- mp+ geom_point(aes(x=visit.x, y=visit.y) ,color="blue", size=3) 
mp
map.world <- map_data(map="world")
map.world$name_len <- nchar(map.world$region) + sample(nrow(map.world))
gg <- ggplot()
gg <- gg+ geom_map(data=map.world, map=map.world, aes(map_id=region, x=long, y=lat, fill=name_len))
gg <- gg + scale_fill_gradient(low = "green", high = "brown3", guide = "colourbar")
gg <- gg + coord_equal()
gg