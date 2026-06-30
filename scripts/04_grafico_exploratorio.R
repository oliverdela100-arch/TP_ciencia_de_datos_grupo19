# 04_grafico_exploratorio.R
# Event study: evolución del PIB industrial per cápita alrededor de cada crisis
# Correcciones post tercera entrega:
#   - Crisis definidas por el piso real del PIB (no solo el año histórico)
#   - Título corregido: no todas las crisis dejaron secuelas permanentes
#   - dpi=300
# Output: output/grafico_exploratorio.png

library(ggplot2)
library(dplyr)
library(readr)
library(purrr)

arg <- read_csv("input/pib_indust_per_capita_arg_evolucion.csv", show_col_types = FALSE)

# Crisis definidas por el piso real de la serie (no el año histórico)
# Dictadura: piso en 1978 | Hiperinflación: piso en 1990 | Convertibilidad: piso en 2002 | Crisis 2018: piso en 2020
crisis <- c(
  "Dictadura (piso 1978)"        = 1978,
  "Hiperinflación (piso 1990)"   = 1990,
  "Convertibilidad (piso 2002)"  = 2002,
  "Crisis 2018 (piso 2020)"      = 2020
)

ventana <- 6

# Construir dataset del event study
event_data <- map_dfr(names(crisis), function(nombre) {
  anio_piso <- crisis[nombre]
  base_val  <- arg %>%
    filter(anio == anio_piso) %>%
    pull(vab_indust_pc_indice)

  if (length(base_val) == 0 || is.na(base_val)) return(NULL)

  arg %>%
    filter(anio >= anio_piso - ventana,
           anio <= anio_piso + ventana) %>%
    mutate(
      t               = anio - anio_piso,
      crisis          = nombre,
      indice_relativo = vab_indust_pc_indice / base_val * 100
    )
})

colores <- c(
  "Dictadura (piso 1978)"        = "#C0392B",
  "Hiperinflación (piso 1990)"   = "#E67E22",
  "Convertibilidad (piso 2002)"  = "#2C6496",
  "Crisis 2018 (piso 2020)"      = "#27AE60"
)

p <- ggplot(event_data, aes(x = t, y = indice_relativo, color = crisis)) +
  geom_vline(xintercept = 0, linetype = "dashed",
             color = "grey50", linewidth = 0.6) +
  geom_hline(yintercept = 100, linetype = "dashed",
             color = "grey50", linewidth = 0.6) +
  annotate("text", x = 0.2, y = 78,
           label = "Año del piso", size = 2.8, color = "grey50", hjust = 0) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2.5) +
  scale_x_continuous(breaks = seq(-ventana, ventana, by = 1)) +
  scale_color_manual(values = colores) +
  labs(
    title    = "Las crisis dejaron secuelas muy distintas: algunas se recuperaron, otras no",
    subtitle = "PIB industrial per cápita de Argentina alrededor de cada crisis (piso de la crisis = 100)\nVentana: 6 años antes y después del piso",
    x        = "Años desde el piso de la crisis",
    y        = "Índice (piso de crisis = 100)",
    color    = NULL,
    caption  = "Fuente: Cuentas Nacionales, INDEC; Fundación Norte y Sur; Lattes et al. (1975).\nElaboración propia en base a Argendata — Fundar."
  ) +
  theme_minimal(base_size = 12) +
  theme(
    plot.title      = element_text(face = "bold", size = 13, lineheight = 1.2),
    plot.subtitle   = element_text(color = "grey40", size = 10),
    plot.caption    = element_text(color = "grey50", size = 8),
    legend.position = "bottom",
    panel.grid.minor   = element_blank()
  )

ggsave("output/grafico_exploratorio.png",
       plot = p, width = 12, height = 7, dpi = 300)

message("Gráfico exploratorio guardado en output/")
