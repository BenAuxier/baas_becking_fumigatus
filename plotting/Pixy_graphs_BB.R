install.packages("ggplot2")
install.packages("readxl")
install.packages("dplyr")
library(ggplot2)
library(readxl)
library(dplyr)
library(tidyr)
library(geomtextpath)

setwd("~/Library/CloudStorage/OneDrive-WageningenUniversity&Research/3_Experimental_work/4_groenafval/Sequencing")
getwd()

LFHF_global_pi <- read_xlsx("LFHF_global_pi_v02.xlsx") #the average values are manually added. 
class(LFHF_global_pi)
LFHF_global_pi

filtered_LFHF_global_pi <- LFHF_global_pi %>% filter(chromosome %in% c("average", "NC_007197.1", "JQ346808.1"))
filtered_LFHF_global_pi

filtered_LFHF_global_pi$chromosome <- factor(
  filtered_LFHF_global_pi$chromosome,
  levels = c("average", "NC_007197.1", "JQ346808.1")
)

ragg::agg_tiff("Pixy_HFLF_global_v04.tiff", width = 6.98, height = 4, units = "in", res = 300)
ggplot(filtered_LFHF_global_pi, aes(x=pop, y=avg_pi, fill = chromosome)) +
  geom_bar(stat = "identity", position = "dodge2") +
  scale_y_continuous(limits = c(0, 0.06)) +
  scale_fill_manual (
    values = c(
      "average" = "#850D6F" ,
      "NC_007197.1" = "#ffb8f2",
      "JQ346808.1" = "#FF7F00"),
    labels = c(
    "average" = "Genome-wide average", 
    "NC_007197.1" = "Chromosome 4 average",
    "JQ346808.1" = "Mitochondrial average"
  )) +
  scale_x_discrete(limits = c("Global", "Low fungicide", "High fungicide")) +
labs(
  x = "Population",
  y = "Average genomic diversity (π)",
) +
  theme_minimal() +
  theme(legend.position = c(0.80, 0.90)) +
  theme(legend.title=element_blank(), 
        axis.text = element_text(size = 10),
        axis.title = element_text(size = 11),
        legend.text = element_text(size = 10)) 
  
dev.off()


##Graphs of the subpopulations 
sub_pop <- read_xlsx("HFLF_sub_pi_average.xlsx")
class(sub_pop)
sub_pop

ragg::agg_tiff("Pixy_HFLF_subpop_v02.tiff", width = 6.98, height = 4, units = "in", res = 300)
ggplot(sub_pop, aes(x=pop, y=avg_pi, fill = sub_pop)) +
  geom_bar(stat = "identity", position = "dodge2", width = 0.7) +
  scale_y_continuous(limits = c(0, 0.06)) +
  scale_x_discrete(limits = c("Low fungicide", "High fungicide")) +
  scale_fill_manual (
    values = c(
      "A" = "#850D6F" ,
      "B" = "#850D6F" ,
      "C" = "#850D6F" ,
      "D" = "#850D6F" ,
      "E" = "#850D6F" ,
      "G1" = "#ffb8f2",
      "G2" = "#ffb8f2",
      "G3" = "#ffb8f2",
      "G4" = "#ffb8f2",
      "G8" = "#ffb8f2"
      )) +
  labs(
    x = "Population",
    y = "Pi (π)",
  ) +
  theme_minimal() +
  geom_segment(aes(x=0.6, y=0.03686466, xend=1.4, yend=0.03686466), color = "azure4") +
  geom_segment(aes(x=1.6, y=0.02193212, xend=2.4, yend=0.02193212), color = "azure4") +
theme(legend.position = "none")
  
dev.off()
#Graph pi versus fungicide
setwd("~/Library/CloudStorage/OneDrive-WageningenUniversity&Research/3_Experimental_work/4_groenafval/Sequencing/Bulbs_Normec_2025")
getwd()
fungicide_data <- read_xlsx("Bollen_monsters_Normec_20250828_v01.xlsx")
head(fungicide_data)
setwd("~/Library/CloudStorage/OneDrive-WageningenUniversity&Research/3_Experimental_work/4_groenafval/Sequencing")
getwd()

pi_fungicides <- sub_pop %>% left_join(fungicide_data, by=c("sub_pop" = "Monsternaam"))
pi_fungicides

long_pi_fungicides <- pi_fungicides %>% pivot_longer(cols = c(`Fungicides (mg/kg)`, `Azoles (mg/kg)`),
                                                     names_to = "Treatment", values_to = "Concentration")
long_pi_fungicides
head(long_pi_fungicides)

long_pi_HF_fungicide_data <- long_pi_fungicides %>% filter(!is.na(Materiaal))
long_pi_HF_fungicide_data

ragg::agg_tiff("Correlation_fungicide_pi_v02.tiff", width = 6.98, height = 4.5, units = "in", res = 300)
ggplot(long_pi_fungicides, aes(x = Concentration, y = avg_pi)) +
  geom_point(size = 2, aes(colour = pop)) +
  scale_color_manual(values = c("High fungicide" = "#ffb8f2", "Low fungicide" = "#850D6F" )) +
  geom_smooth(method = "lm", se = FALSE, color = "azure4", linewidth = 0.6) +
  facet_wrap(~ Treatment) + 
  theme_bw() +
  labs( 
    x = "Concentration",
    y = "Pi (π)",
    color = "Population")
dev.off()























  
