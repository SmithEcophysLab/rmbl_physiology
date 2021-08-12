# script to clean rmbl data

library(dplyr)
library(tidyr)

## read in data

# licor
almont_14 <- read.csv("licor/raw/2021-06-14-1405_logdata_almont.csv")
almont_15 <- read.csv("licor/raw/2021-06-15-0950_logdata_almont.csv")
gothiccamp_16 <- read.csv("licor/raw/2021-06-16-0948_logdata_gothiccamp.csv")

licor_clean <- bind_rows(almont_14, almont_15, gothiccamp_16) %>% 
  separate(individual, c("individual", "rep"))
write.csv(licor_clean, 'licor/licor_clean.csv', row.names = F)

# leaf area
leaf_area <- read.csv("leaf_scans/leaf_area_clean.csv")

# multispeq
multispeq <- read.csv("photosynq/multispeq_data.csv")
names(multispeq)[24] <- "plot"
names(multispeq)[25] <- "rep"
names(multispeq)[26] <- "site"
names(multispeq)[27] <- "individual"
multispeq$rep <- as.character(multispeq$rep)

# combine datasets
data_leafarea_licor <- full_join(leaf_area, licor_clean, by = c("site", "plot", "individual", "rep"))
data_all <- full_join(data_leafarea_licor, multispeq, by = c("site", "plot", "individual", "rep"))

write.csv(data_all, 'data_clean.csv', row.names = F)
