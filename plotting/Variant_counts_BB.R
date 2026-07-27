#For this script, all the analysis have already been done on the server, except for making the figures. 
library(ggplot2)

#Get the data
setwd("~/Library/CloudStorage/OneDrive-WageningenUniversity&\Research/3_Experimental_work/4_Groenafval/Sequencing")
getwd()

#This time, let's include all datasets into 1 graph
global_data <- readRDS("new_global_750.rds")
HF_data <- readRDS("final_HF_120_v02_AD_5.rds")
LF_SS_data <- readRDS("SS_final_groenafval_260_AD_5.rds")

global_data$dataset <- "Global"
HF_data$dataset <- "High fungicide"
LF_SS_data$dataset <- "Low fungicide"

plot_data <- rbind(global_data, HF_data, LF_SS_data)
plot_data

plot_data <- plot_data[order(match(plot_data$dataset, c("Global", "Low fungicide", "High fungicide"))), ]


ragg::agg_tiff("HFLF_Global_variant_plot.tiff", width = 10.62, height = 6.98, units = "in", res = 300) #to get a high-resolution image
ggplot(plot_data, aes(x = subset_size, y = nrows, color = dataset)) +
  geom_point(size = 1.5, alpha = 0.8) +
  labs(
    x = "Number of samples in subset",
    y = "Number of rows (variants)",
    color = "Dataset"
  ) +
  scale_color_manual(values = c(
    "Global" = "#F0DDE4",
    "High fungicide" = "#ffb8f2" ,
    "Low fungicide" = "#850D6F"
  )) +
  coord_cartesian(ylim = c(0, 160000), xlim = c(0, 500)) +
  theme_minimal()


dev.off()

