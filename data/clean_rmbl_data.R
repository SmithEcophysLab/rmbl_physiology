# script to clean rmbl data

library(dplyr)
library(tidyr)

## read in data

# licor
almont_14 <- read.csv("licor/raw/2021-06-14-1405_logdata_almont.csv")
almont_15 <- read.csv("licor/raw/2021-06-15-0950_logdata_almont.csv")
gothiccamp_16 <- read.csv("licor/raw/2021-06-16-0948_logdata_gothiccamp.csv")

licor <- bind_rows(almont_14, almont_15, gothiccamp_16) %>% 
  separate(individual, c("code", "individual"))

write.csv(licor, 'licor/licor.csv', row.names = F)

# leaf area
leaf_area_1 <- read.csv("leaf_scans/leaf_area_1.csv")
leaf_area_2 <- read.csv("leaf_scans/RMBL2021_Leaf AreasPhotosynthesis.csv")
names(leaf_area_2)[1:9] <- c("site", "plot", "treatment", "code", "species",  "individual", 
                       "type", "leaf_area", "weight")

leaf_area <- bind_rows(leaf_area_1, leaf_area_2)
leaf_area$type[leaf_area$type == "Photosyn"] <- "p"

leaf_area$code[leaf_area$species == "Delphinium"] <- "delphinium"
leaf_area$code[leaf_area$species == "Erythronium grandiflorum"] <- "erygra"
leaf_area$code[leaf_area$species == "Ger"] <- "gervis"
leaf_area$code[leaf_area$species == "Heraclum"] <- "hersph"
leaf_area$code[leaf_area$species == "Senecio crassulus"] <- "sencra"
leaf_area$code[leaf_area$species == "Veratrum"] <- "veratrum"
leaf_area$code[leaf_area$species == "Wyethia"] <- "wyeamp"

write.csv(leaf_area, 'leaf_scans/leaf_area.csv', row.names = F)

# multispeq
multispeq <- read.csv("photosynq/multispeq_data_clean.csv")
multispeq$type <- rep("ms")

# combine datasets
leaf_area$individual <-as.character(leaf_area$individual)
licor$individual <-as.character(licor$individual)
multispeq$individual <-as.character(multispeq$individual)

data_leafarea_licor <- full_join(leaf_area, licor, 
                                 by = c("site", "treatment", "plot", "code", "individual", "type"))
data_all <- full_join(data_leafarea_licor, multispeq, 
                      by = c("site", "treatment", "plot", "code", "individual", "type"))

data_all$code[data_all$code == "delphinium"] <- "delspp"
data_all$code[data_all$code == "elymus"] <- "elyspp"
data_all$code[data_all$code == "maple"] <- "hersph"
data_all$code[data_all$code == "poa"] <- "poaspp"
data_all$code[data_all$code == "valeriana"] <- "valspp"
data_all$code[data_all$code == "veratrum"] <- "vercal"

data_all$species[data_all$code == "achmil"] <- "Achillea millefolium"
data_all$species[data_all$code == "adelew"] <- "Adenolinum lewisii"
data_all$species[data_all$code == "arttri"] <- "Artemisia tridentata"
data_all$species[data_all$code == "chrvis"] <- "Chrysothamnus viscidiflorus"
data_all$species[data_all$code == "delspp"] <- "Delphinium spp."
data_all$species[data_all$code == "delbar"] <- "Delphinium barbeyi"
data_all$species[data_all$code == "delnut"] <- "Delphinium nuttallianum"
data_all$species[data_all$code == "elyspp"] <- "Elymus spp."
data_all$species[data_all$code == "erifla"] <- "Erigeron flagellaris"
data_all$species[data_all$code == "eriumb"] <- "Eriogonum umbellatum"
data_all$species[data_all$code == "erygra"] <- "Erythronium grandiflorum"
data_all$species[data_all$code == "festhu"] <- "Festuca thurberi"
data_all$species[data_all$code == "gervis"] <- "Geranium viscosissimum"
data_all$species[data_all$code == "geutri"] <- "Geum triflorum"
data_all$species[data_all$code == "helqui"] <- "Helianthella quinquenervis"
data_all$species[data_all$code == "hersph"] <- "Heracleum sphondylium"
data_all$species[data_all$code == "irimis"] <- "Iris missouriensis"
data_all$species[data_all$code == "latleu"] <- "Lathyrus leucanthus"
data_all$species[data_all$code == "mercil"] <- "Mertensia ciliata"
data_all$species[data_all$code == "poaspp"] <- "Poa spp."
data_all$species[data_all$code == "potgra"] <- "Potentilla gracilis"
data_all$species[data_all$code == "roswoo"] <- "Rosa woodsii"
data_all$species[data_all$code == "sencra"] <- "Senecio crassulus"
data_all$species[data_all$code == "taroff"] <- "Taraxacum officinale"
data_all$species[data_all$code == "thafen"] <- "Thalictrum fendleri"
data_all$species[data_all$code == "vercal"] <- "Veratrum californicum"
data_all$species[data_all$code == "valspp"] <- "Valeriana spp."
data_all$species[data_all$code == "wyeamp"] <- "Wyethia amplexicaulis"
data_all$species[data_all$code == "bare"] <- "bareground"

write.csv(data_all, 'data_clean.csv', row.names = F)
 
