####With this Rscript, it was decided where to put the clonal cut-off value for this data set, also, it was used to make the figures that show the relationship between clonality and subtype. 
library(ggplot2)
library(cowplot)
library(UpSetR)
library(dplyr)
library(tidyr)
library(igraph)
library(tidygraph)
library(readxl)
setwd("~/Library/CloudStorage/OneDrive-WageningenUniversity&Research/3_Experimental_work/4_groenafval/Sequencing")
getwd()

all_isolates <- read.table("LFHF_global_50000_plink.genome", header=T)
all_isolates

##These graphs will look at the DST values of all isolates, by this we determine the DST that will be used to filter on later. 
ragg::agg_tiff("All_isolates_clonal.tiff", width = 6.98, height = 4, units = "in", res = 300)
all <- ggplot(all_isolates) +
  geom_histogram(aes(x=DST),bins=400) +
  theme_classic() +
  labs(x="Genetic Distance",y="Pairs")
all
dev.off()

total <- ggplot(all_isolates) +
  geom_histogram(aes(x=DST),bins=400) + xlim(0,1) +
  theme_classic() +
  labs(x="Genetic Distance",y="Pairs")
total

close <- ggplot(all_isolates) +
  geom_histogram(aes(x=DST),bins=400) + xlim(0.995,1) +
  theme_classic() +
  geom_vline(aes(xintercept=0.998),lty=2)+
  labs(x="Genetic Distance",y="")
close

ragg::agg_tiff("Only_isolates_clonal.tiff", width = 6.98, height = 4, units = "in", res = 300)

close_adapted <- ggplot(all_isolates) +
  geom_histogram(aes(x=DST),bins=400) + xlim(0.998,1) +
  theme_classic() +
  geom_vline(aes(xintercept=0.9995),lty=2)+
  labs(x="Genetic Distance",y="")
close_adapted

dev.off()

##Here we will start the filtering of the isolates
filtered_isolates <- subset(all_isolates, DST>0.9995) ##To remove all isolates that are too far apart
clonal_names <- unique(sort(c(filtered_isolates$FID1,filtered_isolates$FID2))) ##Prints the names of all isolates that are part of a clonal group
g <- graph_from_data_frame(filtered_isolates[,c(1,3)])
clonal_groups <- components(g) ##This contains the groups & which samples are in which group. 
clonal_groups$csize #Shows the number of isolates that are included in each clonal group. 

head(clonal_groups$membership)

df_clonal_groups <- data.frame(
  clonal_group = clonal_groups$membership,
  stringsAsFactors = FALSE ##Turns the data into a dataframe, printing each file name + the clonal group that its a part of. 
)
head(df_clonal_groups)

#The column that contains the sample names, needs to have a name, later, the duplicate column needs to be removed. 
df_clonal_groups$Sample <- rownames(df_clonal_groups)
head(df_clonal_groups)
rownames(df_clonal_groups) <- NULL
df_clonal_groups <- df_clonal_groups[, c("Sample", "clonal_group")]

#Here we list what origin (=heap) the samples have. 
df_clonal_groups<- df_clonal_groups %>%
  mutate(
    Type = case_when(
      grepl("HF_", Sample) ~ "HF",
      grepl("BB_28", Sample) ~ "LF",
      TRUE ~ "Global"
    ),
    Type = case_when(
      grepl("HF_", Sample) ~ "HF",
      grepl("BB_28", Sample) ~ "LF",
      TRUE ~ "Global"
    )
  )
head(df_clonal_groups)

#Here we list what subsample of the heaps the isolates come from. 
df_clonal_groups <- df_clonal_groups %>%
  mutate(
    Sub_Type = case_when(
      grepl("HF_G1", Sample) ~ "G1",
      grepl("HF_G2", Sample) ~ "G2",
      grepl("HF_G3", Sample) ~ "G3",
      grepl("HF_G4", Sample) ~ "G4",
      grepl("HF_G8", Sample) ~ "G8",
      grepl("BB_28A", Sample) ~ "A",
      grepl("BB_28B", Sample) ~ "B",
      grepl("BB_28C", Sample) ~ "C",
      grepl("BB_28D", Sample) ~ "D",
      grepl("BB_28E", Sample) ~ "E",
      TRUE ~"" 
    ))

write.csv(df_clonal_groups, "all_clonal_groups.csv")
head(df_clonal_groups)

#This is a list of all samples --> this will allow us to calculate the % of isolates that are present in clonal groups. 
all_names <- read.table("LFHF_global_names.txt")
head(all_names)
colnames(all_names) <- c("Sample")

#Again adding the heap.
all_names<- all_names %>%
  mutate(
    Type = case_when(
      grepl("HF_", Sample) ~ "HF",
      grepl("BB_28", Sample) ~ "LF",
      TRUE ~ "Global"
    ),
    Type = case_when(
      grepl("HF_", Sample) ~ "HF",
      grepl("BB_28", Sample) ~ "LF",
      TRUE ~ "Global"
    )
  )

#Again adding the subtype.
all_names <- all_names %>%
  mutate(
    Sub_Type = case_when(
      grepl("HF_G1", Sample) ~ "G1",
      grepl("HF_G2", Sample) ~ "G2",
      grepl("HF_G3", Sample) ~ "G3",
      grepl("HF_G4", Sample) ~ "G4",
      grepl("HF_G8", Sample) ~ "G8",
      grepl("BB_28A", Sample) ~ "A",
      grepl("BB_28B", Sample) ~ "B",
      grepl("BB_28C", Sample) ~ "C",
      grepl("BB_28D", Sample) ~ "D",
      grepl("BB_28E", Sample) ~ "E",
      TRUE ~"" 
    ))
head(all_names)

##This counts the number of isolates of certain subtypes that are present in clonal groups + the total isolates of that subtype that are included.
count_clones <- table(df_clonal_groups$Sub_Type)
df_count_clones <- as.data.frame(count_clones)
count_all <- table(all_names$Sub_Type)
df_count_all <- as.data.frame(count_all)
df_count_all
df_count_clones

##Here the two dfs of above are merged by SubType and the percentage of clones per subtype is calculated. 
combined_data <- merge(df_count_all, df_count_clones, by = "Var1")
combined_data
colnames(combined_data) <- c("Sub_Type", "All_isolates", "Isolates_in_clonal_groups")
combined_data$percentage <- (combined_data$Isolates_in_clonal_groups / combined_data$All_isolates) * 100
combined_data <- combined_data[-1, ]
combined_data

##The Type still needs to be added again
combined_data <- combined_data %>%
  mutate(
    Type = case_when(
      grepl("G", Sub_Type) ~ "HF",
      TRUE ~ "LF"
    ))

combined_data$Type <- factor(combined_data$Type,
                             levels = c("LF", "HF")) #To make sure that everything is grouped correctly in the graphs. 

write.csv(combined_data, "clonal_counts.csv")

#This makes the graph that shows per SubType what percentage of the isolates is part of a clonal group
ragg::agg_tiff("Perc_in_clonal.tiff", width = 6.98, height = 4, units = "in", res = 300)
ggplot(combined_data, aes(x=Type, y=percentage, fill = Sub_Type)) +
  geom_bar(stat = "identity", position = "dodge2", width = 0.7) +
  geom_text(aes(label = Sub_Type),
            position = position_dodge2(width = 0.7),
            vjust = -0.2,
            size = 3.5) +
  
  scale_x_discrete(labels = c("LF" = "Low fungicide", "HF" = "High fungicide")) +
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
    y = "Percentage of isolates part of a clonal group (%)",
  ) +
  theme_minimal() +
  theme(legend.position = "none") +
  theme(axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12)) +
  theme(axis.text.x = element_text(size = 10)) +
  theme(axis.text.y = element_text(size = 10)) 
dev.off()


head(df_clonal_groups)

##From here, we start to put the clonal groups into different categories depending on the origins (Type, SubType) of the isolates that are part of these groups. 
df_clonal_groups <- all_names %>% 
  left_join(
    df_clonal_groups %>% select(Sample, clonal_group),
    by = "Sample"
  )

##Before categories can be sorted, first, the data needs to be clean - the NA is replaced with "No clonal group". 
df2 <- df_clonal_groups %>%
  mutate(
    clonal_group = ifelse(is.na(clonal_group),
                          "No clonal group",
                          as.character(clonal_group)))

head(df2)

##Here we will categorize the diffeerent types of clonal groups. 
group_categories <- df2 %>%
  group_by(clonal_group) %>%
  summarise(
    types = list(sort(unique(Type))),
    n_subtypes = n_distinct(Sub_Type[Type != "Global"]),
    .groups = "drop"
  ) %>%
  rowwise() %>%
  mutate(
    Category = case_when(
      
      # HF + LF + Global
      all(c("HF", "LF", "Global") %in% types) ~ "All",
      
      # HF + LF
      setequal(types, c("HF", "LF")) ~ "Only between heaps",
      
      # HF + Global OR LF + Global
      setequal(types, c("HF", "Global")) |
        setequal(types, c("LF", "Global")) ~ "Only with global",
      
      # HF only or LF only, >1 subtype
      (setequal(types, "HF") | setequal(types, "LF")) &
        n_subtypes > 1 ~ "Only heap",
      
      # HF only or LF only, 1 subtype
      (setequal(types, "HF") | setequal(types, "LF")) &
        n_subtypes == 1 ~ "Only subgroup",
      
      TRUE ~ NA_character_
    )
  ) %>%
  ungroup() %>%
  mutate(
    Category = factor(
      Category,
      levels = c(
        "Only subgroup",
        "Only heap",
        "Only with global",
        "Only between heaps",
        "All"
      )
    )
  )

group_categories

#The number of isolates per clonal group will be counted, but only for the HF and LF samples, as Global is not included.
plot_df <- df2 %>%
  filter(Type != "Global") %>%
  left_join(
    group_categories %>%
      select(clonal_group, Category),
    by = "clonal_group"
  ) %>%
  filter(!is.na(Category)) %>%
  group_by(Type, Sub_Type, clonal_group, Category) %>%
  summarise(
    n = n(),
    .groups = "drop"
  )

head(plot_df)

##The location of the bars needs to be fixed per location. 
plot_df <- plot_df %>%
  mutate(
    x_pos = case_when(
      Type == "LF" & Sub_Type == "A" ~ 1,
      Type == "LF" & Sub_Type == "B" ~ 2,
      Type == "LF" & Sub_Type == "C" ~ 3,
      Type == "LF" & Sub_Type == "D" ~ 4,
      Type == "LF" & Sub_Type == "E" ~ 5,
      
      Type == "HF" & Sub_Type == "G1" ~ 7,
      Type == "HF" & Sub_Type == "G2" ~ 8,
      Type == "HF" & Sub_Type == "G3" ~ 9,
      Type == "HF" & Sub_Type == "G4" ~ 10,
      Type == "HF" & Sub_Type == "G8" ~ 11
    )
  )

#The colors are set to be similar to other graphs in the paper
cols <- c(
  "Only subgroup" = "#850D6F",
  "Only heap" = "#ffb8f2",
  "Only with global" = "#cc2bae",
  "Only between heaps" = "#FF7F00",
  "All" = "#7570B3"
)

#Sort the levels of importance for different columns
plot_df <- plot_df %>%
  arrange(Type, Sub_Type, Category, desc(n), clonal_group) %>%
  mutate(
    clonal_group = factor(clonal_group, levels = unique(clonal_group))
  )


plot_df <- plot_df %>%
  arrange(Type, Sub_Type, Category, clonal_group) %>%
  group_by(Type, Sub_Type) %>%
  mutate(stack_order = row_number()) %>%
  ungroup()

plot_df


#This plot shows the clonal groups per subsample per category in ABSOLUTE numbers. 
ragg::agg_tiff("Types_of_clones_v02.tiff", width = 6.98, height = 4, units = "in", res = 300)
ggplot(
  plot_df,
  aes(x = x_pos, y = n, fill = Category, group = stack_order)) +
  geom_col(colour = "white",linewidth = 0.3, width = 0.85) +
  scale_fill_manual(values = cols, name = "Clonal category") +
  scale_x_continuous(
    breaks = c(1,2,3,4,5,7,8,9,10,11),
    labels = c("A","B","C","D","E","G1","G2","G3","G4","G8")) +
  labs(x = "", y = "Number of isolates") +
  theme_minimal() +
  annotate("text", x = 3, y = -Inf, label = "Low Fungicide", vjust = 3, size = 3.5) +
  annotate("text",x = 9, y = -Inf, label = "High Fungicide", vjust = 3, size = 3.5) +
  coord_cartesian(clip = "off")
dev.off()


#The percentage of isolates per clonal group will be calculated
plot_df <- plot_df %>%
  group_by(Sub_Type) %>%
  mutate(
    total_n_subtype = sum(n, na.rm = TRUE),
    pct_of_subtype = n / total_n_subtype * 100
  ) %>%
  ungroup()

#The isolates that are not in a clonal group will be removed
plot_df <- plot_df %>%
  filter(clonal_group != "No clonal group")

#To make the graph with the PERCENTAGE of isolates of the total isolates of that Sub_type.
ragg::agg_tiff("Types_of_clones_perc_v01.tiff", width = 6.98, height = 4, units = "in", res = 300)
ggplot(
  plot_df,
  aes(x = x_pos, y = pct_of_subtype, fill = Category, group = stack_order)) +
  geom_col(colour = "white",linewidth = 0.3, width = 0.85) +
  scale_fill_manual(values = cols, name = "Clonal category") +
  scale_x_continuous(
    breaks = c(1,2,3,4,5,7,8,9,10,11),
    labels = c("A","B","C","D","E","G1","G2","G3","G4","G8")) +
  labs(x = "", y = "Percentage of isolates") +
  theme_minimal() +
  annotate("text", x = 3, y = -Inf, label = "Low Fungicide", vjust = 3, size = 3.5) +
  annotate("text",x = 9, y = -Inf, label = "High Fungicide", vjust = 3, size = 3.5) +
  coord_cartesian(clip = "off")
dev.off()
