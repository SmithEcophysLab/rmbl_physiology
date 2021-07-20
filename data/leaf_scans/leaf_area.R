library(LeafArea)
library(dplyr)

imagej_path <- "/Applications/ImageJ.app"
leafimage_path <- "~/Git/rmbl_physiology/data/leaf_scans/cropped"
leaf_area <- run.ij(path.imagej = imagej_path, set.directory = leafimage_path,
                        distance.pixel = 1166.496, known.distance = 10, set.memory = 10)

write.csv(leaf_area, file = "leaf_area_raw.csv")
