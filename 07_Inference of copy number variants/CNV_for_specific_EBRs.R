library(ggplot2)
library(dplyr)
library(wesanderson)

col <- wes_palette("Darjeeling1")
col2 <-wes_palette("Darjeeling2")

setwd("~/Downloads")
CNV.EBR.df<-read.table("CNV.LsinapisSWE_fusion_EBRs.EBRs")

colnames(CNV.EBR.df) <- c("Chromosome", "Start", "End", "Median_ratio", "Copy_number", "ID", "Sampgroup", "Population", "EBR_CHROM", "EBR_START",	"EBR_STOP", "SPECIES", 	"NODE",	"stdBP",	"BUSCO1",	"BUSCO2",	"combID",	"BPid",	"reuse_descendant",	"translocation",	"reciprocal_translocation",	"BRANCH")

CNV.EBR.df$Rearrangement_type <- "Fusions"

CNV.EBR.df2<-read.table("CNV.LsinapisCat_specific_Fissions.v5.EBRs")

colnames(CNV.EBR.df2) <- c("Chromosome", "Start", "End", "Median_ratio", "Copy_number", "ID", "Sampgroup", "Population", "EBR_CHROM", "EBR_START",	"EBR_STOP", "SPECIES", 	"NODE",	"stdBP",	"BUSCO1",	"BUSCO2",	"combID",	"BPid",	"reuse_descendant",	"translocation",	"reciprocal_translocation",	"BRANCH")

CNV.EBR.df2$Rearrangement_type <- "Fissions"


cryptics.DF<-CNV.EBR.df[!grepl("morsei", CNV.EBR.df$Population) & !grepl("amurensis", CNV.EBR.df$Population) & !grepl("duponcheli", CNV.EBR.df$Population) & !grepl("lactea", CNV.EBR.df$Population), ]


df.CNV.mean <- cryptics.DF %>%
  group_by(Population, combID, BRANCH, reuse_descendant, Rearrangement_type) %>%
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

# Prepare data
df.CNV.mean <- df.CNV.mean %>%
  group_by(Rearrangement_type) %>%
  mutate(x_pos = as.numeric(interaction(Population, combID, drop = TRUE))) %>%
  ungroup()

rects <- df.CNV.mean %>%
  group_by(Rearrangement_type, combID) %>%
  summarise(
    xmin = min(x_pos) - 0.5,
    xmax = max(x_pos) + 0.5,
    .groups = "drop"
  ) %>%
  group_by(Rearrangement_type) %>%
  arrange(xmin, .by_group = TRUE) %>%
  mutate(
    ymin = -Inf,
    ymax = Inf,
    fill_color = rep(c("grey", "white"), length.out = n()),
    xmin = ifelse(row_number() == 1, min(xmin), xmin),
    xmax = ifelse(row_number() == n(), max(xmax), xmax)
  ) %>%
  ungroup()

# Plot
ggplot(df.CNV.mean, aes(x = x_pos, y = mean, color = Population)) +
  
  geom_rect(
    data = rects,
    aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax, fill = fill_color),
    inherit.aes = FALSE,
    alpha = 0.5
  ) +
  
  geom_point(size = 1, position = position_dodge(width = 0.5)) +
  
  geom_errorbar(aes(ymin = lower, ymax = upper),
                width = 0.2,
                position = position_dodge(width = 0.5)) +
  
  scale_x_continuous(
    breaks = df.CNV.mean$x_pos,
    labels = interaction(df.CNV.mean$Population, df.CNV.mean$combID),
    expand = c(0, 0)
  )+
  facet_wrap(~Rearrangement_type, ncol = 1, scales = "free")+
  
  geom_hline(yintercept = 1, lty = 2) +
  
  scale_color_manual(
    name = "Population",
    values = c(col[5], col2[2], col[1], col[3]),
    labels = c(
      expression(italic("Leptidea juvernica") ~ "Sweden"),
      expression(italic("Leptidea reali") ~ "Catalonia"),
      expression(italic("Leptidea sinapis") ~ "Catalonia"),
      expression(italic("Leptidea sinapis") ~ "Sweden")
    )
  )+
  scale_fill_identity() +
  
  labs(
    y = "Haploid copy number",
    x = "EBRs",
    color = "Population"
  ) +
  
  theme_bw(base_size = 14) +
  theme(
    axis.text.x = element_blank(),
    axis.ticks.x = element_blank(),
    legend.position = "right",
    panel.grid.major.x = element_blank(),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.y = element_blank(),
    panel.grid.minor.y = element_blank()
  )
