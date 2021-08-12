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

leaf_area_clean <- separate(leaf_area, sample, c("site", "plot", "individual", "rep"))
leaf_area_clean$weight <- NA
  
write.csv(leaf_area_clean, 'leaf_area_clean.csv', row.names = F)
