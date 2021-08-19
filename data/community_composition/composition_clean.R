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

# rearrange into tidy format
almont <- gather(almont_raw, "code", "cover", -month & -day & -year & -site & - plot)
gothic <- gather(gothic_raw, "code", "cover", -month & -day & -year & -site & - plot)
cinnamon <- gather(cinnamon_raw, "code", "cover", -month & -day & -year & -site & - plot)

almont_gothic <- bind_rows(almont, gothic)
cc_07_21 <- bind_rows(almont_gothic, cinnamon)

# remove rows with 0 cover
cc_07_21 <- filter(cc_07_21, cover > 0)

cc_07_21$plot <- as.character(cc_07_21$plot)

community_composition <- bind_rows(cc_06_21, cc_07_21)
community_composition$species <- NA

# fix incorrect species codes
community_composition$code[community_composition$code == "ADDLEU"] <- "ADELEW"
community_composition$code[community_composition$code == "ALL.UUU."] <- "ALLUUU"
community_composition$code[community_composition$code == "POA1A"] <- "POASPP"
community_composition$code[community_composition$code == "Agulasha"] <- "AGULASHA" #check
community_composition$code[community_composition$code == "Bromopsis"] <- "BROINE"
community_composition$code[community_composition$code == "BUCKWHEAT"] <- "ERISPP"
community_composition$code[community_composition$code == "Delphinium"] <- "DELSPP"
community_composition$code[community_composition$code == "Frasera"] <- "FRASPE"
community_composition$code[community_composition$code == "Ger.like"] <- "GER?"
community_composition$code[community_composition$code == "Hairy.ester"] <- "HAIRYESTER" #check - hairy golden-aster?
community_composition$code[community_composition$code == "Hairy.ester..White."] <- "HAIRYESTER" #check
community_composition$code[community_composition$code == "HelQui"] <- "HELQUI"
community_composition$code[community_composition$code == "Heraculum"] <- "HERSPH"
community_composition$code[community_composition$code == "Hydrophylum"] <- "HYDFEN"
community_composition$code[community_composition$code == "LatLeu"] <- "LATLEU"
community_composition$code[community_composition$code == "Lig.Por"] <- "LIGPOR"
community_composition$code[community_composition$code == "Meadow.Rue"] <- "THAFEN"
community_composition$code[community_composition$code == "Mertensia"] <- "MERCIL"
community_composition$code[community_composition$code == "Senecio"] <- "SENCRA"
community_composition$code[community_composition$code == "Strawberries"] <- "FRAVIR"
community_composition$code[community_composition$code == "Tar.off."] <- "TAROFF"
community_composition$code[community_composition$code == "the.annual"] <- "ANNUAL" #check
community_composition$code[community_composition$code == "Toothed.Leaf"] <- "TOOTHEDLEAF" #check
community_composition$code[community_composition$code == "Valeriana"] <- "VALSPP"
community_composition$code[community_composition$code == "Veratrum"] <- "VERCAL"
community_composition$code[community_composition$code == "Bare.Ground"] <- "bare"
community_composition$code[community_composition$code == "Litter"] <- "litter"


# assign species names by code
community_composition$species[community_composition$code == "ACHMIL"] <- "Achillea millefolium"
community_composition$species[community_composition$code == "ADELEW"] <- "Adenolinum lewisii"
community_composition$species[community_composition$code == "AGOAUR"] <- "Agoseris aurantiaca"
community_composition$species[community_composition$code == "AGOGLA"] <- "Agoseris glauca"
community_composition$species[community_composition$code == "AGOS1A"] <- "Agoseris spp."
community_composition$species[community_composition$code == "AGOS1C"] <- "Agoseris spp." #check
community_composition$species[community_composition$code == "ALLUUU"] <- "Allium spp." #check
community_composition$species[community_composition$code == "ALLSPE"] <- "Allium spp." #check
community_composition$species[community_composition$code == "ALOPRA"] <- "Alopecurus pratensis"
community_composition$species[community_composition$code == "ANTCOR"] <- "Antennaria corymbosa"
community_composition$species[community_composition$code == "ANTE1C"] <- "Antennaria spp." #check
community_composition$species[community_composition$code == "ANTROS"] <- "Antennaria rosea"
community_composition$species[community_composition$code == "ARCUVA"] <- "Arctostaphylos uva-ursi"
community_composition$species[community_composition$code == "ARNMOL"] <- "Arnica mollis"
community_composition$species[community_composition$code == "ARTTRI"] <- "Artemisia tridentata"
community_composition$species[community_composition$code == "BOESTR"] <- "Boechera stricta"
community_composition$species[community_composition$code == "BROINE"] <- "Bromopsis inermis"
community_composition$species[community_composition$code == "CAPBUR"] <- "Capsella bursa-pastoris"
community_composition$species[community_composition$code == "CARALB"] <- "Carex albonigra"
community_composition$species[community_composition$code == "CASMIN"] <- "Castilleja miniata"
community_composition$species[community_composition$code == "CASSUL"] <- "Castilleja sulphurea"
community_composition$species[community_composition$code == "CHRVIS"] <- "Chrysothamnus viscidiflorus"
community_composition$species[community_composition$code == "CYPE1A"] <- "Cyperus spp." #check
community_composition$species[community_composition$code == "DELBAR"] <- "Delphinium barbeyi"
community_composition$species[community_composition$code == "DELNUT"] <- "Delphinium nuttallianum"
community_composition$species[community_composition$code == "DELSPP"] <- "Delphinium spp."
community_composition$species[community_composition$code == "DRAAUR"] <- "Draba aurea"
community_composition$species[community_composition$code == "ELYELY"] <- "Elymus elymoides"
community_composition$species[community_composition$code == "ELYSPP"] <- "Elymus spp."
community_composition$species[community_composition$code == "ERECON"] <- "Eremogone congesta"
community_composition$species[community_composition$code == "ERIFLA"] <- "Erigeron flagellaris"
community_composition$species[community_composition$code == "ERIGLA"] <- "Erigeron glabellus"
community_composition$species[community_composition$code == "ERISPE"] <- "Erigeron speciosus"
community_composition$species[community_composition$code == "ERISPP"] <- "Eriogonum spp." #check
community_composition$species[community_composition$code == "ERIUMB"] <- "Eriogonum umbellatum"
community_composition$species[community_composition$code == "ERYGRA"] <- "Erythronium grandiflorum"
community_composition$species[community_composition$code == "FESTHU"] <- "Festuca thurberi"
community_composition$species[community_composition$code == "FRASPE"] <- "Frasera speciosa"
community_composition$species[community_composition$code == "FRAVIR"] <- "Frasera virginiana"
community_composition$species[community_composition$code == "GALSEP"] <- "Galium spp." #check
community_composition$species[community_composition$code == "GER?"] <- "Geranium viscosissimum" #check
community_composition$species[community_composition$code == "GERVIS"] <- "Geranium viscosissimum"
community_composition$species[community_composition$code == "GEUTRI"] <- "Geum triflorum"
community_composition$species[community_composition$code == "HELQUI"] <- "Helianthella quinquenervis"
community_composition$species[community_composition$code == "HERSPH"] <- "Heracleum sphondylium"
community_composition$species[community_composition$code == "HYDFEN"] <- "Hydrophyllum fendleri"
community_composition$species[community_composition$code == "IPOAGG"] <- "Ipomopsis aggregata"
community_composition$species[community_composition$code == "IRIMIS"] <- "Iris missouriensis"
community_composition$species[community_composition$code == "JUNDRU"] <- "Juncus drummondii"
community_composition$species[community_composition$code == "LATLEU"] <- "Lathyrus leucanthus"
community_composition$species[community_composition$code == "LIGPOR"] <- "Ligusticum porteri"
community_composition$species[community_composition$code == "MERCIL"] <- "Mertensia ciliata"
community_composition$species[community_composition$code == "MERFUS"] <- "Mertensia fusiformis"
community_composition$species[community_composition$code == "MUHMON"] <- "Muhlenbergia montana"
community_composition$species[community_composition$code == "PENS1A"] <- "Penstemon spp." #check
community_composition$species[community_composition$code == "PHASER"] <- "Phacelia sericea"
community_composition$species[community_composition$code == "POA1A"] <- "Poa spp." #check
community_composition$species[community_composition$code == "POA1B"] <- "Poa spp." #check
community_composition$species[community_composition$code == "POAALP"] <- "Poa alpina"
community_composition$species[community_composition$code == "POAC1A"] <- "Poa spp." #check
community_composition$species[community_composition$code == "POALEP"] <- "Poa leptocoma"
community_composition$species[community_composition$code == "POASPP"] <- "Poa spp."
community_composition$species[community_composition$code == "POTGRA"] <- "Potentilla gracilis"
community_composition$species[community_composition$code == "POTHIP"] <- "Potentilla hippiana"
community_composition$species[community_composition$code == "PSEMON"] <- "Pseudocymopterus montanus"
community_composition$species[community_composition$code == "PULPAT"] <- "Pulsatilla patens"
community_composition$species[community_composition$code == "ROSWOO"] <- "Rosa woodsii"
community_composition$species[community_composition$code == "SENCRA"] <- "Senecio crassulus"
community_composition$species[community_composition$code == "SENE1A"] <- "Senecio spp." #check
community_composition$species[community_composition$code == "SENE1C"] <- "Senecio spp." #check
community_composition$species[community_composition$code == "TAROFF"] <- "Taraxacum officinale"
community_composition$species[community_composition$code == "THAFEN"] <- "Thalictrum fendleri"
community_composition$species[community_composition$code == "TRADUB"] <- "Tragopogon dubius"
community_composition$species[community_composition$code == "VALEDU"] <- "Valeriana edulis"
community_composition$species[community_composition$code == "VALSPP"] <- "Valeriana spp."
community_composition$species[community_composition$code == "VERCAL"] <- "Veratrum californicum"
community_composition$species[community_composition$code == "VERWOR"] <- "Veronica wormskjoldii"
community_composition$species[community_composition$code == "VICAME"] <- "Vicia americana"
community_composition$species[community_composition$code == "VIOADU"] <- "Viola adunca"
community_composition$species[community_composition$code == "VIOL1A"] <- "Viola spp." #check
community_composition$species[community_composition$code == "WYEAMP"] <- "Wyethia amplexicaulis"
community_composition$species[community_composition$code == "bare"] <- "bareground"
community_composition$species[community_composition$code == "litter"] <- "leaf litter"

write.csv(community_composition, 'community_composition_clean.csv', row.names = F)

