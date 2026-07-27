There are several Rscripts that were used to create the Figures that are included in the paper. In this file, it will be explained which Rscripts were used for each of the Figures. 

**Variant_counts_BB.R**
This script can be used to plot the .rds files that orginate from XX. The files are made per dataset; LF, HF and Global.

**Pixy_graphs_BB.R**
This script can be used to make three different graphs, the data used in this Rscript comes from XX:
1. It plots the overall value for genomic diversity (pi) + the values for Chrom4 per dataset into one barplot.
2. It plots the pi-values for each of the subsets + the average of the dataset for HF and LF into one barplot.
3. It plots a scatterplot of the pi-values vs. the fungicide- and azole-concentrations of the heap that the isolates per subset were isolated from. 
      
**LFHF_global_PCA_BB.R**
This script is used to make the PCA from the plink that was performed in XX. The Rscript also shows the additional filtering that was performed to improve the visualization in this plot.

**Clonal_analysis_BB.R**
This script can be used to make five different graphs, the data used in this Rscript comes from XX:
1. A histogram showing the pairwise DST (>0.9) for isolates.
2. A histogram zooming in on the higher DST values, with the vertical line showing where we cut of the clonal limit.
3. A barplot that shows the percentage of isolates of each subsample that are present in a clonal group.
4. A stacked barplot that shows the absolute number of isolates that were present in clonal groups. Clonal groups are seperated, and categorized based on the origin of the isolates present in the clonal group.
5. A stacked barplot that shows the percentage of isolates that were present in clonal groups. The categories are the same as in 2.

**Fst_BB.R**
This script can be used to make three different FST graphs, the data using in this Rscript comes from XX:
1. The FST comparing the LF and HF population.
2. The FST comparing the LF and the Dutch sensitive population of Snelders et al., 2025.
3. The FST comparing the HF and the Dutch resistant population of Snelders et al., 2025.
