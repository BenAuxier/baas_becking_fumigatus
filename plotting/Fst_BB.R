library(ggplot2)
library(cowplot)

setwd("~/Library/CloudStorage/OneDrive-WageningenUniversity&Research/3_Experimental_work/4_groenafval/Sequencing")
getwd()

HF_LF_Fst <- read.table("fst_LF_HF.windowed.weir.fst", header = T)
HF_LF_Fst$POS <- (HF_LF_Fst$BIN_START+HF_LF_Fst$BIN_END)/2


HF_LF_Fst$CHROM[HF_LF_Fst$CHROM == "NC_007194.1"] <- "1"
HF_LF_Fst$CHROM[HF_LF_Fst$CHROM == "NC_007195.1"] <- "2"
HF_LF_Fst$CHROM[HF_LF_Fst$CHROM == "NC_007196.1"] <- "3"
HF_LF_Fst$CHROM[HF_LF_Fst$CHROM == "NC_007197.1"] <- "4"
HF_LF_Fst$CHROM[HF_LF_Fst$CHROM == "NC_007198.1"] <- "5"
HF_LF_Fst$CHROM[HF_LF_Fst$CHROM == "NC_007199.1"] <- "6"
HF_LF_Fst$CHROM[HF_LF_Fst$CHROM == "NC_007200.1"] <- "7"
HF_LF_Fst$CHROM[HF_LF_Fst$CHROM == "NC_007201.1"] <- "8"
HF_LF_Fst$CHROM[HF_LF_Fst$CHROM == "JQ346808.1"] <- "9"

cyp51A <- data.frame(CHROM="4",
                     POS=1780204,
                     text="cyp51A")

top <- ggplot(HF_LF_Fst) + 
  geom_segment(data=cyp51A,aes(x=POS,xend=POS,y=0,yend=0.9),inherit.aes = FALSE,color="grey30")+
  geom_text(data=cyp51A,parse=T,aes(x=POS,y=0.95,label='paste(italic("cyp51"),"A")'))+
  geom_point(aes(x=POS,y=WEIGHTED_FST,color=CHROM),size=0.3) + 
  facet_grid(cols=vars(CHROM),scales="free",space="free") +
  theme_classic(base_size=14) + ylim(0.00,1) +
  theme(legend.position="none",
        panel.spacing=unit(0.01,"cm"),
        axis.text.x=element_blank(),
        axis.title.x=element_blank()) +
  scale_x_continuous(breaks=c(1e6,2e6,3e6,4e6,5e6,6e6),labels=c(1,2,3,4,5,6)) +
  labs(x="Position (Mb)",y=expression(atop(HF~vs.~LF,(Weighted~F[st]))))

top

ragg::agg_tiff("HF_LF_Fst_v01.tiff", width = 30, height = 4.5, units = "in", res = 300)
top
dev.off()


###########################################################################################
###The samples were compared to the Dutch isolates of Snelders et al., 2025. It will be LF vs. susceptible and HF vs. resistant population. 
HF_snel_Fst <- read.table("fst_HF_snel.windowed.weir.fst", header = T)
HF_snel_Fst$POS <- (HF_snel_Fst$BIN_START+HF_snel_Fst$BIN_END)/2

HF_snel_Fst$CHROM[HF_snel_Fst$CHROM == "NC_007194.1"] <- "1"
HF_snel_Fst$CHROM[HF_snel_Fst$CHROM == "NC_007195.1"] <- "2"
HF_snel_Fst$CHROM[HF_snel_Fst$CHROM == "NC_007196.1"] <- "3"
HF_snel_Fst$CHROM[HF_snel_Fst$CHROM == "NC_007197.1"] <- "4"
HF_snel_Fst$CHROM[HF_snel_Fst$CHROM == "NC_007198.1"] <- "5"
HF_snel_Fst$CHROM[HF_snel_Fst$CHROM == "NC_007199.1"] <- "6"
HF_snel_Fst$CHROM[HF_snel_Fst$CHROM == "NC_007200.1"] <- "7"
HF_snel_Fst$CHROM[HF_snel_Fst$CHROM == "NC_007201.1"] <- "8"
HF_snel_Fst$CHROM[HF_snel_Fst$CHROM == "JQ346808.1"] <- "9"

HF_snel_plot <- ggplot(HF_snel_Fst) + 
  geom_segment(data=cyp51A,aes(x=POS,xend=POS,y=0,yend=0.9),inherit.aes = FALSE,color="grey30")+
  geom_text(data=cyp51A,parse=T,aes(x=POS,y=0.95,label='paste(italic("cyp51"),"A")'))+
  geom_point(aes(x=POS,y=WEIGHTED_FST,color=CHROM),size=0.3) + 
  facet_grid(cols=vars(CHROM),scales="free",space="free") +
  theme_classic(base_size=14) + ylim(0.00,1) +
  theme(legend.position="none",
        panel.spacing=unit(0.01,"cm"),
        axis.text.x=element_blank(),
        axis.title.x=element_blank()) +
  scale_x_continuous(breaks=c(1e6,2e6,3e6,4e6,5e6,6e6),labels=c(1,2,3,4,5,6)) +
  labs(x="Position (Mb)",y=expression(atop(HF~vs.~RES_snelders,(Weighted~F[st]))))

HF_snel_plot

ragg::agg_tiff("HF_snel_Fst_v01.tiff", width = 30, height = 4.5, units = "in", res = 300)
HF_snel_plot
dev.off()

#Second, the sus_LF. 
LF_snel_Fst <- read.table("fst_LF_snel.windowed.weir.fst", header = T)
LF_snel_Fst$POS <- (LF_snel_Fst$BIN_START+LF_snel_Fst$BIN_END)/2

LF_snel_Fst$CHROM[LF_snel_Fst$CHROM == "NC_007194.1"] <- "1"
LF_snel_Fst$CHROM[LF_snel_Fst$CHROM == "NC_007195.1"] <- "2"
LF_snel_Fst$CHROM[LF_snel_Fst$CHROM == "NC_007196.1"] <- "3"
LF_snel_Fst$CHROM[LF_snel_Fst$CHROM == "NC_007197.1"] <- "4"
LF_snel_Fst$CHROM[LF_snel_Fst$CHROM == "NC_007198.1"] <- "5"
LF_snel_Fst$CHROM[LF_snel_Fst$CHROM == "NC_007199.1"] <- "6"
LF_snel_Fst$CHROM[LF_snel_Fst$CHROM == "NC_007200.1"] <- "7"
LF_snel_Fst$CHROM[LF_snel_Fst$CHROM == "NC_007201.1"] <- "8"
LF_snel_Fst$CHROM[LF_snel_Fst$CHROM == "JQ346808.1"] <- "9"

LF_snel_plot <- ggplot(LF_snel_Fst) + 
  geom_segment(data=cyp51A,aes(x=POS,xend=POS,y=0,yend=0.9),inherit.aes = FALSE,color="grey30")+
  geom_text(data=cyp51A,parse=T,aes(x=POS,y=0.95,label='paste(italic("cyp51"),"A")'))+
  geom_point(aes(x=POS,y=WEIGHTED_FST,color=CHROM),size=0.3) + 
  facet_grid(cols=vars(CHROM),scales="free",space="free") +
  theme_classic(base_size=14) + ylim(0.00,1) +
  theme(legend.position="none",
        panel.spacing=unit(0.01,"cm"),
        axis.text.x=element_blank(),
        axis.title.x=element_blank()) +
  scale_x_continuous(breaks=c(1e6,2e6,3e6,4e6,5e6,6e6),labels=c(1,2,3,4,5,6)) +
  labs(x="Position (Mb)",y=expression(atop(LF~vs.~SUS_snelders,(Weighted~F[st]))))

LF_snel_plot

ragg::agg_tiff("LF_snel_Fst_v01.tiff", width = 30, height = 4.5, units = "in", res = 300)
LF_snel_plot
dev.off()







