# 03_grafico_comunicacional.R
# Gráfico comunicacional: PIB industrial per cápita Argentina vs Francia y México
# Corea del Sur va en gráfico aparte (domina el eje Y)
# Correcciones post tercera entrega:
#   - Corea del Sur separada
#   - Anotaciones: dictadura, crisis 2001, pico 1974
#   - dpi=300
# Output: output/grafico_comunicacional.png
#         output/grafico_corea.png

library(ggplot2)
library(dplyr)
library(readr)

comparado <- read_csv("input/pib_indust_per_capita_comparado.csv", show_col_types = FALSE)

# ---- Gráfico 1: Argentina, Francia y México --------------------------------

sin_corea <- comparado %>%
  filter(pais!= "Corea del Sur")

colores1 <- c(
  "Argentina" = "#C0392B",
  "Francia"   = "#27AE60",
  "México"    = "#F39C12"
)

p1 <- ggplot(sin_corea, aes(x = anio, y = gdp_indust_pc_indice, color = pais)) +
  # Sombreado dictadura
  annotate("rect",
           xmin = 1976, xmax = 1983,
           ymin = -Inf, ymax = Inf,
           fill = "grey80", alpha = 0.4) +
  annotate("text", x = 1979.5, y = 185,
           label = "Dictadura", size = 3, color = "grey40", fontface = "italic") +
  geom_line(linewidth = 1.1) +
  geom_hline(yintercept = 100, linetype = "dashed",
             color = "grey60", linewidth = 0.5) +
  # Pico Argentina 1974
  annotate("point", x = 1974, y = 113.97, color = "#C0392B", size = 3) +
  annotate("text",  x = 1975.5, y = 118,
           label = "Pico 1974", size = 2.8, color = "#C0392B") +
  # Crisis 2001
  geom_vline(xintercept = 2001, linetype = "dotted",
             color = "grey50", linewidth = 0.5) +
  annotate("text", x = 2002.5, y = 185,
           label = "Crisis\n2001", size = 2.8, color = "grey40") +
  scale_color_manual(values = colores1) +
  scale_x_continuous(breaks = seq(1970, 2023, by = 5)) +
  scale_y_continuous(limits = c(55, 200)) +
  labs(
    title    = "Mientras los demás crecieron, Argentina nunca superó su nivel de 1974",
    subtitle = "PIB industrial per cápita, índice base 1970 = 100",
    x        = NULL,
    y        = "Índice (1970 = 100)",
    color    = NULL,
    caption  = "Fuente: National Accounts, UNSTATS; INDEC; Fundación Norte y Sur.\nElaboración propia en base a Argendata — Fundar."
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

ggsave("output/grafico_comunicacional.png",
       plot = p1, width = 12, height = 7, dpi = 300)

# ---- Gráfico 2: Argentina vs Corea del Sur ---------------------------------

con_corea <- comparado %>%
  filter(pais %in% c("Argentina", "Corea del Sur"))

colores2 <- c("Argentina" = "#C0392B", "Corea del Sur" = "#2C6496")

p2 <- ggplot(con_corea, aes(x = anio, y = gdp_indust_pc_indice, color = pais)) +
  geom_line(linewidth = 1.1) +
  geom_hline(yintercept = 100, linetype = "dashed",
             color = "grey60", linewidth = 0.5) +
  annotate("text", x = 1971, y = 200,
           label = "Base 1970 = 100", size = 3, color = "grey50", hjust = 0) +
  scale_color_manual(values = colores2) +
  scale_x_continuous(breaks = seq(1970, 2023, by = 5)) +
  labs(
    title    = "Corea del Sur multiplicó su PIB industrial per cápita por 57",
    subtitle = "PIB industrial per cápita, índice base 1970 = 100",
    x        = NULL,
    y        = "Índice (1970 = 100)",
    color    = NULL,
    caption  = "Fuente: National Accounts, UNSTATS; INDEC; Fundación Norte y Sur.\nElaboración propia en base a Argendata — Fundar."
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

ggsave("output/grafico_corea.png",
       plot = p2, width = 12, height = 7, dpi = 300)

message("Gráficos comunicacionales guardados en output/")
