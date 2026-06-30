# 07_exportaciones.R
# Participación en exportaciones manufactureras mundiales por país (1962-2023)
# Output: output/grafico_exportaciones.png
#         output/tabla_exportaciones.csv

library(ggplot2)
library(dplyr)
library(readr)

expo <- read_csv("input/peso_arg_expo_ind.csv", show_col_types = FALSE)

# Tabla resumen
tabla_expo <- expo %>%
  group_by(pais) %>%
  summarise(
    inicio_pct = round(prop_pct[anio == min(anio)], 3),
    fin_pct    = round(prop_pct[anio == max(anio)], 3),
    variacion  = round(fin_pct - inicio_pct, 3),
    .groups    = "drop"
  )
cat("=== Participación en exportaciones manufactureras mundiales ===\n")
print(tabla_expo)
write_csv(tabla_expo, "output/tabla_exportaciones.csv")

colores <- c(
  "Argentina"    = "#C0392B",
  "Corea del Sur"= "#2C6496",
  "Francia"      = "#27AE60",
  "México"       = "#F39C12"
)

p <- ggplot(expo, aes(x = anio, y = prop_pct, color = pais)) +
  geom_line(linewidth = 1.1) +
  scale_color_manual(values = colores) +
  scale_x_continuous(breaks = seq(1962, 2023, by = 5)) +
  labs(
    title    = "México y Corea del Sur se convirtieron en exportadores industriales; Argentina, no",
    subtitle = "Participación en exportaciones manufactureras mundiales (%)",
    x        = NULL,
    y        = "Participación (%)",
    color    = NULL,
    caption  = "Fuente: Harvard Growth Lab, BACI-CEPII.\nElaboración propia en base a Argendata — Fundar."
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title      = element_text(face = "bold", size = 13, lineheight = 1.2),
    plot.subtitle   = element_text(color = "grey40", size = 10),
    plot.caption    = element_text(color = "grey50", size = 8),
    legend.position = "bottom",
    panel.grid.minor   = element_blank(),
    axis.text.x = element_text(angle = 45, hjust = 1)
  )

ggsave("output/grafico_exportaciones.png",
       plot = p, width = 12, height = 7, dpi = 300)

message("Gráfico de exportaciones guardado en output/")
