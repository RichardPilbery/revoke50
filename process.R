# Mapping fun!

library(jsonlite)
library(tidyverse)


file_name <- basename("https://petition.parliament.uk/petitions/241584.json")
download.file(url = "https://petition.parliament.uk/petitions/241584.json", destfile = file_name, mode="wb")

df <- fromJSON(file_name)
str(df$data)

countrydf <- df$data$attributes$signatures_by_country
constitdf <- df$data$attributes$signatures_by_constituency

world <- map_data("world") 

countrydf2 <- countrydf %>%
  rename(region = name) %>%
  mutate(
    region = case_when(
      region == "United States" ~ "USA",
      region == "United Kingdom" ~ "UK",
      region == "Congo (Democratic Republic)" ~ "Democratic Republic of the Congo",
      region == "Congo" ~ "Republic of Congo",
      TRUE ~ region
    )
  )

my_breaks = c(0, 1, 10, 100, 1000, 10000, 100000, 1000000)
options(scipen = 999)

unique(world$region)
unique(countrydf2$region)

# https://ggplot2.tidyverse.org/reference/map_data.html

gg <- ggplot() +
  geom_map(data=countrydf2, map=world, aes(map_id = region, fill=signature_count), color='grey', size=0.3) +
  scale_fill_gradient(trans="log", breaks = my_breaks, labels = my_breaks) +
  expand_limits(x = world$long, y = world$lat) 


