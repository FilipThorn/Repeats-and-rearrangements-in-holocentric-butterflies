library(ggplot2)
library(dplyr)
library(wesanderson)

col <- wes_palette("Darjeeling1")
col2 <-wes_palette("Darjeeling2")

setwd("~/Downloads")
CNV.EBR.df<-read.table("CNV.LsinapisSWE_fusion_EBRs.EBRs")

colnames(CNV.EBR.df) <- c("Chromosome", "Start", "End", "Median_ratio", "Copy_number", "ID", "Sampgroup", "Population", "EBR_CHROM", "EBR_START",	"EBR_STOP", "SPECIES", 	"NODE",	"stdBP",	"BUSCO1",	"BUSCO2",	"combID",	"BPid",	"reuse_descendant",	"translocation",	"reciprocal_translocation",	"BRANCH")

df.CNV.mean <- cryptics.DF %>%
  #filter(combID != "63-217") %>%
  group_by(Population, combID, BRANCH, reuse_descendant) %>%
  summarise(
    mean = mean(Median_ratio, na.rm = TRUE),
    sd   = sd(Median_ratio, na.rm = TRUE),
    n    = sum(!is.na(Median_ratio)),
    .groups = "drop"
  ) %>%
  mutate(
    margin = qt(0.975, df = n - 1) * sd / sqrt(n),
    lower  = mean - margin,
    upper  = mean + margin
  )

# Prepare data
df.CNV.mean <- df.CNV.mean %>%
  mutate(x_pos = as.numeric(interaction(Population, combID)),
         combID = factor(combID))

# Create rectangles with exact edges
rects <- df.CNV.mean %>%
  group_by(combID) %>%
  summarise(
    xmin = min(x_pos) - 0.5,
    xmax = max(x_pos) + 0.5
  ) %>%
  mutate(ymin = -Inf,
         ymax = Inf,
         fill_color = rep(c("grey", "white"), length.out = n()))



# Adjust first and last rectangles to exactly match x-axis
rects[1,]$xmin<-0
rects$xmax[nrow(rects)] <- max(df.CNV.mean$x_pos) + 0.5

# Plot
ggplot(df.CNV.mean, aes(x = x_pos, y = mean, color = Population)) +
  geom_rect(
    data = rects,
    aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
    fill = rects$fill_color,
    inherit.aes = FALSE, alpha=0.5
  ) +
  geom_point(size = 1, position = position_dodge(width = 0.5)) +
  geom_errorbar(aes(ymin = lower, ymax = upper),
                width = 0.2,
                position = position_dodge(width = 0.5)) +
  scale_x_continuous(
    breaks = df.CNV.mean$x_pos,
    labels = interaction(df.CNV.mean$Population, df.CNV.mean$combID),
    expand = c(0, 0), limits = c(0, NA)
  ) +
  labs(
    #x = "Fission EBRs",
    x="Fusion EBRs",
    y = "Haploid copy number",
 #   title = "Mean Median_ratio with 95% CI by Population and combID",
    color = "Population"
  ) +
  geom_hline(yintercept=1, lty=2)+

  scale_color_manual(name="Population", values = c(col[5], col2[2], col[1],  col[3])) +
  
  theme_bw(base_size = 14) +
  theme(
   #axis.text.x = element_text(angle = 45, hjust = 1),
    axis.text.x= element_blank(),
    axis.ticks.x= element_blank(),
    legend.position = "right"
  )+
  theme(
   # panel.background = element_rect(fill = "white", color = NA), # white background
    panel.grid.major.x = element_blank(),                        # remove vertical grid
    panel.grid.minor.x = element_blank(),                        # remove minor vertical grid
    panel.grid.major.y = element_blank(),         # optional horizontal grid
    panel.grid.minor.y = element_blank()
  )
