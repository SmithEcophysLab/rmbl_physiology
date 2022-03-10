# script to calculate rmbl leaf area data

library(LeafArea)
library(dplyr)
library(tidyr)

imagej_path <- "/Applications/ImageJ.app"
leafimage_path <- "~/Git/rmbl_physiology/data/leaf_scans/cropped"
leaf_area <- run.ij(path.imagej = imagej_path, set.directory = leafimage_path,
                        distance.pixel = 1166.496, known.distance = 10, set.memory = 10)

write.csv(leaf_area, file = "leaf_area_raw.csv")

# clean leaf area data

## read in data
leaf_area_raw <- read.csv("leaf_area_raw.csv")[ , 2:3]
leaf_weights <- read.csv("leaf_weights.csv")

leaf_area_clean <- separate(leaf_area_raw, sample, c("site", "treatment", "plot", "code", "individual", 
                                                 "type"))
leaf_weights$individual <- as.character(leaf_weights$individual)
leaf_weights$plot <- as.character(leaf_weights$plot)

leaf_area_clean_w <- full_join(leaf_area_clean, leaf_weights, 
                                   by = c("site", "treatment", "plot", "code", "individual", "type"))
leaf_area_clean_w$species <- NA

names(leaf_area_clean_w)[7] <- c("leaf_area")

leaf_area_clean_w <- subset(leaf_area_clean_w, select = c("site", "plot", "treatment", "species", "code", "individual", 
                                                          "type", "leaf_area", "weight"))

leaf_area_clean_w$site[leaf_area_clean_w$site == "almont"] <- "Almont"
leaf_area_clean_w$site[leaf_area_clean_w$site == "gothiccamp"] <- "Gothic"
leaf_area_clean_w$treatment[leaf_area_clean_w$treatment == "control"] <- "Control"
leaf_area_clean_w$treatment[leaf_area_clean_w$treatment == "warming"] <- "Warming"
leaf_area_clean_w$treatment[leaf_area_clean_w$treatment == "outside"] <- "Outside"


write.csv(leaf_area_clean_w, 'leaf_area_clean.csv', row.names = F)

