# script to clean rmbl data

library(dplyr)
library(tidyr)
library(lubridate)

# licor
almont_0614 <- read.csv("licor/raw/2021-06-14-1405_logdata_almont.csv")
almont_0615 <- read.csv("licor/raw/2021-06-15-0950_logdata_almont.csv")
gothic_0616 <- read.csv("licor/raw/2021-06-16-0948_logdata_gothiccamp.csv")
almont_0623 <- read.csv("licor/raw/2021-06-23-1130_Almont.csv")
gothic_0701 <- read.csv("licor/raw/2021-07-01-1017_gothiccamp.csv")
almont_0705 <- read.csv("licor/raw/2021-07-05-Almont.csv")
cinnamon_0709 <- read.csv("licor/raw/2021-07-09-cinnamon.csv")


licor <- bind_rows(almont_0614, almont_0615, gothic_0616, almont_0623, gothic_0701, almont_0705, 
                   cinnamon_0709) %>% 
  separate(individual, c("code", "individual"))

licor$code[licor$code == "delphinium"] <- "DELSPP"
licor$code[licor$code == "elymus"] <- "ELYSPP"
licor$code[licor$code == "maple"] <- "HERSPH"
licor$code[licor$code == "poa"] <- "POASPP"
licor$code[licor$code == "valeriana"] <- "VALSPP"
licor$code[licor$code == "veratrum"] <- "VERCAL"
licor$code[licor$code == "ger"] <- "GERVIS"
licor$code[licor$code == "ery"] <- "ERYGRA"
licor$code[licor$code == "sen"] <- "SENCRA"
licor$code[licor$code == "heraclum"] <- "HERSPH"
licor$code[licor$code == "veratrum"] <- "VERCAL"

licor$code <- toupper(licor$code)

licor <- licor %>% separate(col = date, into = "date", sep = "[[:space:]]")
licor$date <- parse_date_time(licor$date, "Ymd")

write.csv(licor, 'licor/licor.csv', row.names = F)

# leaf area
leaf_area_1 <- read.csv("leaf_scans/leaf_area_clean.csv")
leaf_area_2 <- read.csv("leaf_scans/RMBL2021_Leaf AreasPhotosynthesis.csv")
names(leaf_area_2)[1:9] <- c("site", "plot", "treatment", "code", "species",  "individual", 
                       "type", "leaf_area", "weight")
# leaf_area_2$plot <- as.character(leaf_area_2$plot)

leaf_area <- bind_rows(leaf_area_1, leaf_area_2)
leaf_area$type[leaf_area$type == "Photosyn"] <- "p"

leaf_area$code[leaf_area$species == "Delphinium"] <- "DELSPP"
leaf_area$code[leaf_area$species == "Erythronium grandiflorum"] <- "ERYGRA"
leaf_area$code[leaf_area$species == "Ger"] <- "GERVIS"
leaf_area$code[leaf_area$species == "Heraclum"] <- "HERSPH"
leaf_area$code[leaf_area$species == "Senecio crassulus"] <- "SENCRA"
leaf_area$code[leaf_area$species == "Veratrum"] <- "VERCAL"
leaf_area$code[leaf_area$species == "Wyethia"] <- "WYEAMP"
leaf_area$code[leaf_area$code == "delphinium"] <- "DELSPP"
leaf_area$code[leaf_area$code == "elymus"] <- "ELYSPP"
leaf_area$code[leaf_area$code == "maple"] <- "HERSPH"
leaf_area$code[leaf_area$code == "poa"] <- "POASPP"
leaf_area$code[leaf_area$code == "valeriana"] <- "VALSPP"
leaf_area$code[leaf_area$code == "veratrum"] <- "VERCAL"

leaf_area$code <- toupper(leaf_area$code)

leaf_area <- select(leaf_area, -species)

write.csv(leaf_area, 'leaf_scans/leaf_area.csv', row.names = F)

# multispeq
multispeq <- read.csv("photosynq/multispeq_data_clean.csv")
multispeq$type <- rep("ms")

multispeq$code[multispeq$code == "delphinium"] <- "DELSPP"
multispeq$code[multispeq$code == "elymus"] <- "ELYSPP"
multispeq$code[multispeq$code == "maple"] <- "HERSPH"
multispeq$code[multispeq$code == "poa"] <- "POASPP"
multispeq$code[multispeq$code == "valeriana"] <- "VALSPP"
multispeq$code[multispeq$code == "veratrum"] <- "VERCAL"

multispeq$code <- toupper(multispeq$code)

multispeq <- multispeq %>% separate(col = time, into = "date_ms", sep = "[[:space:]]")
multispeq$date <- parse_date_time(multispeq$date, "mdy")

# combine datasets
leaf_area$individual <- as.character(leaf_area$individual)
licor$individual <- as.character(licor$individual)
multispeq$individual <- as.character(multispeq$individual)

data_multispeq_licor <- full_join(licor, multispeq, 
                                 by = c("site", "treatment", "plot", "code", "individual", "type", "date"))
data_leafarea_licor_multispeq <- full_join(leaf_area, data_multispeq_licor, 
                      by = c("site", "treatment", "plot", "code", "individual", "type"))

# species codes
species_codes <- read.csv("../analysis/species_codes.csv")
species_codes <- select(species_codes, -X)

data_all <- left_join(data_leafarea_licor_multispeq, species_codes, by = c("code"))

# date
data_all$year <- year(data_all$date)
data_all$month <- month(data_all$date)
data_all$day <- day(data_all$date)
data_all$doy <- yday(data_all$date)

data_all <- select(data_all, site, plot, treatment, code, genus_species, genus, species, individual, type, 
                   date, year, month, day, doy, everything())

write.csv(data_all, 'data_clean.csv', row.names = F)
 
data_p <- subset(data_all, type == "p")
photo_avg <- data_p %>% group_by(site, treatment, plot, code, genus_species, genus, species, individual, type) %>%
  summarise_all(mean, na.rm = T)

write.csv(photo_avg, 'average_photosynthesis.csv', row.names = F)
