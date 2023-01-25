# load libraries
library(ggplot2)
library(rockchalk)
library(lme4)
library(lmerTest)
library(emmeans)
library(broom)
library(wesanderson)
library(Hmisc)
library(corrplot)
library(ggpubr)
library(ggsci)
library(Rmisc)
library(agricolae)
library(arsenal)
library(plantecophys)
library(LeafArea)
library(dplyr)
library(tidyr)
library(readr)

##### combine raw Licor files into one csv file ####
cbt.path <- "~/Documents/rmbl_physiology/data/rmbl_2022_licor_data_copy/Enquist_RMBL/cbt.test"
cbt.licor.all <- "~/Documents/rmbl_physiology/data/rmbl_2022_licor_data_copy/Enquist_RMBL//cbt.licor.all.xlsx"

filenames_list <- list.files(path = cbt.path, full.names=TRUE)

All <- lapply(filenames_list,function(filename){
  print(paste("Merging",filename,sep = " "))
  read.xlsx(filename)
})

df <- do.call(rbind.data.frame, All)
write.xlsx(df,cbt.licor.all)


# calculate leaf area from scans

imagej_path <- "/Applications/ImageJ.app"
leafimage_path <- "~/Documents/rmbl_physiology/data/rmbl_2022_leafscans/Aimee_sites_cropped"
leaf_area_aimee <- run.ij(path.imagej = imagej_path, set.directory = leafimage_path,
                    distance.pixel = 1180, known.distance = 10, set.memory = 10)

write.csv(leaf_area_aimee, file = "~/Documents/rmbl_physiology/data/rmbl_2022_leafscans/leaf_areas_aimee.csv")


###############################################################################
## Load readLicorData package
###############################################################################
library(readLicorData)
library(dplyr)

###############################################################################
## Set working directory
###############################################################################
setwd("~/Documents/rmbl_physiology/data/rmbl_2022_licor_data_copy/Enquist_RMBL_textfiles")

###############################################################################
## Load pre heatwave measurements. Adding column to indicate whether
## curves were done before or after heat stress event
###############################################################################
# NOTE: All files from first week of measurements were concatenated,
#       ("appended" on the machine). Object (e.g., "preHeat_alb") should
#       therefore contain data from both Sept. 7 and 8

# almont
almont_d1_stan <- licorData(location = "almont/2022-06-24-0927_almont_enquist_stan") %>%
  mutate(site = "almont")
write.csv(almont_d1_stan, "cleaned/almont_d1_stan.csv")

almont_d2_stan <- licorData(location = "almont/2022-06-25-0926_almont_enq_stan") %>%
  mutate(site = "almont")
write.csv(almont_d1_stan, "cleaned/almont_d2_stan.csv")

almont_d1_oz <- licorData(location = "almont/2022-06-24-0931_logdata_almont_enq_ozzie") %>%
  mutate(site = "almont")
write.csv(almont_d1_stan, "cleaned/almont_d1_oz.csv")

almont_d2_oz <- licorData(location = "almont/2022-06-25-almont day2_ozzie") %>%
  mutate(site = "almont")
write.csv(almont_d1_stan, "cleaned/almont_d2_oz.csv")

almont_d1_gib <- licorData(location = "almont/2022-06-24-almont_enq_gibson") %>%
  mutate(site = "almont")
write.csv(almont_d1_stan, "cleaned/almont_d1_gib.csv")

almont_d2_gib <- licorData(location = "almont/2022-06-25-0929_almont_enq_day2_gibson") %>%
  mutate(site = "almont")
write.csv(almont_d1_stan, "cleaned/almont_d2_gib.csv")

# cbt
cbt_d1_stan <- licorData(location = "cbt/2022-07-08-0938_cbt_enquist_stan") %>%
  mutate(site = "cbt")
write.csv(cbt_d1_stan, "cleaned/cbt_d1_stan.csv")

cbt_d2_stan <- licorData(location = "cbt/2022-07-11-0858_cbt_day2_stan") %>%
  mutate(site = "cbt")
write.csv(cbt_d2_stan, "cleaned/cbt_d2_stan.csv")

cbt_d1_oz <- licorData(location = "cbt/2022-07-08_cbt_oz") %>%
  mutate(site = "cbt")
write.csv(cbt_d1_oz, "cleaned/cbt_d1_oz.csv")

cbt_d2_oz <- licorData(location = "cbt/2022-07-11_cbt_oz") %>%
  mutate(site = "cbt")
write.csv(cbt_d2_oz, "cleaned/cbt_d2_oz.csv")

cbt_d1_gib <- licorData(location = "cbt/2022-07-08_cbt_gibson") %>%
  mutate(site = "cbt")
write.csv(cbt_d1_gib, "cleaned/cbt_d1_gib.csv")

cbt_d2_gib <- licorData(location = "cbt/2022-07-11_cbt_gibson") %>%
  mutate(site = "cbt")
write.csv(cbt_d2_gib, "cleaned/cbt_d2_gib.csv")

# cinnamon
cinnamon_d1_stan <- licorData(location = "cinnamon/2022-07-09-1356_cinnamon_stan") %>%
  mutate(site = "cinnamon")
write.csv(cinnamon_d1_stan, "cleaned/cinnamon_d1_stan.csv")

cinnamon_d1_oz <- licorData(location = "cinnamon/2022-07-09_cinnamon_oz") %>%
  mutate(site = "cinnamon")
write.csv(cinnamon_d1_oz, "cleaned/cinnamon_d1_oz.csv")

cinnamon_d1_gib <- licorData(location = "cinnamon/2022-07-09_Cinamon_gibson") %>%
  mutate(site = "cinnamon")
write.csv(cinnamon_d1_gib, "cleaned/cinnamon_d1_gib.csv")

# painterboy
painterboy_d1_stan <- licorData(location = "painterboy/2022-07-08-1412_painterboy_enq_stan") %>%
  mutate(site = "painterboy")
write.csv(painterboy_d1_stan, "cleaned/painterboy_d1_stan.csv")

painterboy_d1_oz <- licorData(location = "painterboy/2022-07-08-1436_panterboy_oz") %>%
  mutate(site = "painterboy")
write.csv(painterboy_d1_oz, "cleaned/painterboy_d1_oz.csv")

painterboy_d1_gib <- licorData(location = "painterboy/2022-07-08_painterboymt_gibson") %>%
  mutate(site = "painterboy")
write.csv(painterboy_d1_gib, "cleaned/painterboy_d1_gib.csv")

# pfeiler
pfeiler_d1_stan <- licorData(location = "pfeiler/2022-07-10-1415_pfeiler_stan") %>%
  mutate(site = "pfeiler")
write.csv(pfeiler_d1_stan, "cleaned/pfeiler_d1_stan.csv")

pfeiler_d2_stan <- licorData(location = "pfeiler/2022-07-11-1039_pfeier_day2_stan") %>%
  mutate(site = "pfeiler")
write.csv(pfeiler_d2_stan, "cleaned/pfeiler_d2_stan.csv")

pfeiler_d1_oz <- licorData(location = "pfeiler/2022-07-10_pfeiler_oz") %>%
  mutate(site = "pfeiler")
write.csv(pfeiler_d1_oz, "cleaned/pfeiler_d1_oz.csv")

pfeiler_d2_oz <- licorData(location = "pfeiler/2022-07-11_pfeiler_oz") %>%
  mutate(site = "pfeiler")
write.csv(pfeiler_d2_oz, "cleaned/pfeiler_d2_oz.csv")

pfeiler_d1_gib <- licorData(location = "pfeiler/2022-07-10_pfeiler_gibson") %>%
  mutate(site = "pfeiler")
write.csv(pfeiler_d1_gib, "cleaned/pfeiler_d1_gib.csv")

pfeiler_d2_gib <- licorData(location = "pfeiler/2022-07-11_pfeiler_gibson") %>%
  mutate(site = "pfeiler")
write.csv(pfeiler_d2_gib, "cleaned/pfeiler_d2_gib.csv")

# road
road_d1_stan <- licorData(location = "road/2022-07-09-0903_road_enquist_stan") %>%
  mutate(site = "road")
write.csv(road_d1_stan, "cleaned/road_d1_stan.csv")

road_d2_stan <- licorData(location = "road/2022-07-11-1326_road_day2_stan") %>%
  mutate(site = "road")
write.csv(road_d2_stan, "cleaned/road_d2_stan.csv")

road_d1_oz <- licorData(location = "road/2022-07-09_road_oz") %>%
  mutate(site = "road")
write.csv(road_d1_oz, "cleaned/road_d1_oz.csv")

road_d2_oz <- licorData(location = "road/2022-07-11_road_oz") %>%
  mutate(site = "road")
write.csv(road_d2_oz, "cleaned/road_d2_oz.csv")

road_d1_gib <- licorData(location = "road/2022-07-09_Road_gibson") %>%
  mutate(site = "road")
write.csv(road_d1_gib, "cleaned/road_d1_gib.csv")

road_d2_gib <- licorData(location = "road/2022-07-11_road_gibson") %>%
  mutate(site = "road")
write.csv(road_d2_gib, "cleaned/road_d2_gib.csv")

###############################################################################
## Merge files into central file. Useful for 'fitacis' when fitting multiple
## curves
###############################################################################
# NOTE: Using list.files notation to avoid common merge conflict with 
# readLicorData package. Cols seem to be assigned different classes when
# cleaned through 'licorData', which makes merging files difficult/unnecessarily
# time consuming. Reloading files into list of data frames, them merging through
# reshape::merge_all() seems to do the trick.

# List files
file.list <- list.files("cleaned",
                        recursive = TRUE,
                        pattern = "\\.csv$",
                        full.names = TRUE)
file.list <- setNames(file.list, stringr::str_extract(basename(file.list), 
                                                      '.*(?=\\.csv)'))

# Merge list of data frames, arrange by machine, measurement type, id, and time elapsed
merged_licor_files <- lapply(file.list, read.csv) %>%
  reshape::merge_all() %>%
  arrange(site, machine, id, obs)
write.csv(merged_licor_files, "./rmbl_licor_enquistsites_alldata.csv")

## End of data cleaning, ready for curve fitting ##


################ Fit ACi curves #################

# set working directory and load data
setwd("~/Documents/rmbl_physiology/data/rmbl_2022_licor_data_copy/Enquist_RMBL_textfiles")
rmbl.enq.clean.2 <- read.csv("rmbl_licor_enquistsites_alldata_cleaned_NoOutliers.csv")

# subset data to only multi-site species
rmbl.enq.aci.subset <- rmbl.enq.aci[which(rmbl.enq.aci$species == "hymhoo" 
                                          | rmbl.enq.aci$species == "vercal" 
                                          | rmbl.enq.aci$species == "lupbak" 
                                          | rmbl.enq.aci$species == "mercil" 
                                          | rmbl.enq.aci$species == "erygra"
                                          | rmbl.enq.aci$species == "taroff" ),]

vercal.aci <- rmbl.enq.aci[which(rmbl.enq.aci$species == "vercal"),] 

# fit ACi curves
rmbl.enq.clean.2.fits <- fitacis(rmbl.enq.clean.2, "id", fitmethod="bilinear", fitTPU = TRUE, id = c("rep", "elevation", "species")) 

# fit ACi curves (species pooled)
rmbl.enq.clean.2.pooled.species <- fitacis(rmbl.enq.clean.2, "id", fitmethod="bilinear", fitTPU = FALSE, id = c("rep", "elevation")) 

plot(rmbl.enq.clean.2.fits, how = "manyplots")

# plot vcmax vs jmax
with(coef(rmbl.enq.clean.2.pooled.species), plot(Vcmax, Jmax))

rmbl.enq.clean.2.pooled.species.parameters <- coef(rmbl.enq.clean.2.pooled.species)
rmbl.enq.clean.2.pooled.species.parameters$elevation <- as.numeric(rmbl.enq.clean.2.pooled.species.parameters$elevation)
str(rmbl.enq.pooled.species.parameters)

rmbl.enq.clean.2.parameters <- coef(rmbl.enq.clean.2.fits)
rmbl.enq.clean.2.parameters$elevation <- as.numeric(rmbl.enq.clean.2.parameters$elevation)
str(rmbl.enq.clean.2.parameters)
write.csv(rmbl.enq.clean.2.parameters, '~/Documents/rmbl_physiology/data/rmbl_2022_licor_data_copy/Enquist_RMBL_textfiles/aci.coef.tpu.csv', row.names = F)

# Add column with Jmax:Vcmax ratio
rmbl.enq.clean.2.pooled.species.parameters <- rmbl.enq.clean.2.pooled.species.parameters %>%
  mutate(JVratio = Jmax/Vcmax)

rmbl.enq.clean <- rmbl.enq.clean.2.parameters %>%
  mutate(JVratio = Jmax/Vcmax)

# Plot with species noted by colour
ggplot(rmbl.enq.clean, aes(elevation, Jmax, colour = species)) +
  geom_point(position = position_jitter(width = 10), alpha = .5) +
  stat_summary(fun = "mean", geom = "point", 
               size = 5, shape = "diamond",
               position = position_dodge(width = 30)) +
  stat_summary(fun = "mean", geom = "line", 
               position = position_dodge(width = 30)) +
  labs(x = "Elevation (m)", y = "Jmax") +
  theme_classic(base_size = 14) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  border()

# Plot with species pooled
ggplot(rmbl.enq.clean.2.pooled.species.parameters, aes(elevation, Vcmax)) +
  geom_point(position = position_jitter(width = 10), alpha = .3) +
  stat_summary(fun = mean, na.rm = TRUE, 
               geom = "point", color = "firebrick1", size = 3) +
  stat_summary(fun.data = mean_cl_normal, na.rm =TRUE, 
               geom = "errorbar", width = .2, color = "firebrick1") +
  labs(x = "Elevation (m)", y = "Vcmax") +
  theme_classic(base_size = 14) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  border()


ggplot(rmbl.enq.aci.clean.parameters, aes(elevation, Jmax, group = species, colour = species)) +
  stat_summary(fun = mean, na.rm = TRUE,
               geom = "point", size = 3,
               position = position_dodge(width = 20)) +
  stat_summary(fun.data = mean_cl_normal, na.rm = TRUE, 
               geom = "errorbar", width = .2,
               position = position_dodge(width = 20)) +
  stat_summary(fun = mean, na.rm = TRUE,
               geom = "line", size = .75, 
               position = position_dodge(width = 20)) +
  labs(x = "Elevation (m)") +
  theme_classic(base_size = 18) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))

# Boxplot, pooled species
ggplot(rmbl.enq.pooled.species.parameters, aes(elevation, Vcmax)) +
  geom_boxplot() +
  labs(x = "Elevation (m)") +
  theme_classic(base_size = 18) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))



boxplot(Vcmax ~ id, data=coef(rmbl.enq.aci.fits))

rmbl.enq.vcmax.estimates <- coef(rmbl.enq.aci.fits)
vercal.vcmax.estimates <- coef(vercal.aci.fits)
hymhoo.vcmax.estimates <- coef(hymhoo.aci.fits)


d <- ggplot(rmbl.enq.vcmax.estimates, aes(site, Vcmax, colour = species)) + 
  geom_point(position = position_dodge(width = .4), size = 3) +
  labs(x = "Site") +
  theme_classic(base_size = 18) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  geom_errorbar(aes(ymin = Vcmax - Vcmax_SE, ymax = Vcmax + Vcmax_SE), width = .3, position = position_dodge(width = .4)) 

###### do not use, keeping code for future reference #####
ggplot(rmbl.enq.clean, aes(elevation, Vcmax, colour = species)) +
  stat_summary(fun = "mean", geom = "pointrange", 
               fun.max = function(x) mean(x) + sd(x) / sqrt(length(x)),
               fun.min = function(x) mean(x) - sd(x) / sqrt(length(x))) +
  geom_line() +
  labs(x = "Elevation (m)") +
  theme_classic(base_size = 14) +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  border()


####################### clean leaf area data ############################ 

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