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
leaf_area <- read.csv("leaf_area_raw.csv")[ , 2:3]

leaf_area_clean <- separate(leaf_area, sample, c("site", "treatment", "plot", "species_code", "individual", 
                                                 "type"))

leaf_area_clean$weight <- NA
leaf_area_clean$species <- NA

names(leaf_area_clean)[7] <- c("leaf_area")

leaf_area_clean <- subset(leaf_area_clean, select = c(1, 3, 2, 4, 9, 5, 6, 7, 8))

leaf_area_clean$site[leaf_area_clean$site == "almont"] <- "Almont"
leaf_area_clean$site[leaf_area_clean$site == "gothiccamp"] <- "Gothic"
leaf_area_clean$treatment[leaf_area_clean$treatment == "control"] <- "Control"
leaf_area_clean$treatment[leaf_area_clean$treatment == "warming"] <- "Warming"
leaf_area_clean$treatment[leaf_area_clean$treatment == "outside"] <- "Outside"

write.csv(leaf_area_clean, 'leaf_area_1.csv', row.names = F)

