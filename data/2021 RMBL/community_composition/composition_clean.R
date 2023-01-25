# script to clean & merge rmbl community composition data

library(dplyr)
library(tidyr)

almont_raw <- read.csv("PlantComposition_Almont.csv")
gothic_raw <- read.csv("PlantComposition_Gothic.csv")
cinnamon_raw <- read.csv("PlantComposition_Cinnamon.csv")
cc_06_21 <- read.csv("rmbl2021_community_composition.csv")

# remove "check" column
cc_06_21 <- select(cc_06_21, -check)
# rename sites with uppercase
cc_06_21$site[cc_06_21$site == "almont"] <- "Almont"
cc_06_21$site[cc_06_21$site == "gothic_camp"] <- "Gothic"
cc_06_21$code <- toupper(cc_06_21$code)

# rearrange into tidy format
almont <- gather(almont_raw, "code", "cover", -month & -day & -year & -site & - plot)
gothic <- gather(gothic_raw, "code", "cover", -month & -day & -year & -site & - plot)
cinnamon <- gather(cinnamon_raw, "code", "cover", -month & -day & -year & -site & - plot)

almont_gothic <- bind_rows(almont, gothic)
cc_07_21 <- bind_rows(almont_gothic, cinnamon)

# remove rows with 0 cover
cc_07_21 <- filter(cc_07_21, cover > 0)

cc_07_21$plot <- as.character(cc_07_21$plot)

cc_21 <- bind_rows(cc_06_21, cc_07_21)

# fix incorrect species codes
cc_21$code[cc_21$code == "ADDLEU"] <- "ADELEW"
cc_21$code[cc_21$code == "ALL.UUU."] <- "ALLUUU"
cc_21$code[cc_21$code == "POA1A"] <- "POASPP"
cc_21$code[cc_21$code == "Agulasha"] <- "AGULASHA" #check
cc_21$code[cc_21$code == "Bromopsis"] <- "BROINE"
cc_21$code[cc_21$code == "BUCKWHEAT"] <- "ERISPP"
cc_21$code[cc_21$code == "Delphinium"] <- "DELSPP"
cc_21$code[cc_21$code == "Frasera"] <- "FRASPE"
cc_21$code[cc_21$code == "Ger.like"] <- "GER?"
cc_21$code[cc_21$code == "Hairy.ester"] <- "HAIRYESTER" #check - hairy golden-aster?
cc_21$code[cc_21$code == "Hairy.ester..White."] <- "HAIRYESTER" #check
cc_21$code[cc_21$code == "HelQui"] <- "HELQUI"
cc_21$code[cc_21$code == "Heraculum"] <- "HERSPH"
cc_21$code[cc_21$code == "Hydrophylum"] <- "HYDFEN"
cc_21$code[cc_21$code == "LatLeu"] <- "LATLEU"
cc_21$code[cc_21$code == "Lig.Por"] <- "LIGPOR"
cc_21$code[cc_21$code == "Meadow.Rue"] <- "THAFEN"
cc_21$code[cc_21$code == "Mertensia"] <- "MERCIL"
cc_21$code[cc_21$code == "Senecio"] <- "SENCRA"
cc_21$code[cc_21$code == "Strawberries"] <- "FRAVIR"
cc_21$code[cc_21$code == "Tar.off."] <- "TAROFF"
cc_21$code[cc_21$code == "the.annual"] <- "ANNUAL" #check
cc_21$code[cc_21$code == "Toothed.Leaf"] <- "TOOTHEDLEAF" #check
cc_21$code[cc_21$code == "Valeriana"] <- "VALSPP"
cc_21$code[cc_21$code == "Veratrum"] <- "VERCAL"
cc_21$code[cc_21$code == "Bare.Ground"] <- "BARE"
cc_21$code[cc_21$code == "Litter"] <- "LITTER"

# assign species names by code
species_codes <- read.csv("../../analysis/species_codes.csv")
species_codes <- select(species_codes, -X)

community_composition <- left_join(cc_21, species_codes, by = c("code"))
community_composition <- select(community_composition, month, day, year, site, plot, code, genus_species, genus, species, everything())

write.csv(community_composition, 'community_composition_clean.csv', row.names = F)

