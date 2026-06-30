# 02_descriptivas.R
# Estadísticas descriptivas de las tres bases limpias
# Output: output/tabla_descriptivas_arg.csv
#         output/tabla_descriptivas_comparado.csv
#         output/tabla_faltantes.csv

library(dplyr)
library(readr)

arg         <- read_csv("input/pib_indust_per_capita_arg_evolucion.csv",  show_col_types = FALSE)
comparado   <- read_csv("input/pib_indust_per_capita_comparado.csv",      show_col_types = FALSE)
exportaciones <- read_csv("input/peso_arg_expo_ind.csv",show_col_types = FALSE)

# --- Argentina: medidas globales ---
cat("=== PIB industrial per cápita — Argentina (1970-2024) ===\n")
cat(sprintf("N:       %d observaciones\n", nrow(arg)))
cat(sprintf("Media:   %.1f\n", mean(arg$vab_indust_pc_indice)))
cat(sprintf("Mediana: %.1f\n", median(arg$vab_indust_pc_indice)))
cat(sprintf("Desvío:  %.1f\n", sd(arg$vab_indust_pc_indice)))
cat(sprintf("Mínimo:  %.1f (año %d)\n",
            min(arg$vab_indust_pc_indice),
            arg$anio[which.min(arg$vab_indust_pc_indice)]))
cat(sprintf("Máximo:  %.1f (año %d)\n",
            max(arg$vab_indust_pc_indice),
            arg$anio[which.max(arg$vab_indust_pc_indice)]))

# --- Argentina: promedio por subperiodo ---
cat("\n--- Promedio por subperiodo ---\n")
tabla_arg <- arg %>%
  mutate(subperiodo = case_when(
    anio <= 1975 ~ "1970-1975 (pre-dictadura)",
    anio <= 1983 ~ "1976-1983 (dictadura)",
    anio <= 2001 ~ "1984-2001 (transición y convertibilidad)",
    anio <= 2011 ~ "2002-2011 (recuperación)",
    TRUE         ~ "2012-2024 (último ciclo)"
  )) %>%
  group_by(subperiodo) %>%
  summarise(
    promedio = round(mean(vab_indust_pc_indice), 1),
    minimo   = round(min(vab_indust_pc_indice), 1),
    maximo   = round(max(vab_indust_pc_indice), 1)
  )
print(tabla_arg)

# --- Comparado ---
cat("\n=== PIB industrial per cápita comparado (base 1970=100) ===\n")
tabla_comp <- comparado %>%
  group_by(pais) %>%
  summarise(
    media      = round(mean(gdp_indust_pc_indice), 1),
    mediana    = round(median(gdp_indust_pc_indice), 1),
    desvio     = round(sd(gdp_indust_pc_indice), 1),
    minimo     = round(min(gdp_indust_pc_indice), 1),
    maximo     = round(max(gdp_indust_pc_indice), 1),
    nivel_2023 = round(gdp_indust_pc_indice[anio == max(anio)], 1)
  )
print(tabla_comp)

# --- Tabla de faltantes (evidencia) ---
cat("\n=== Datos faltantes — evidencia ===\n")
tabla_faltantes <- data.frame(
  base     = c("arg_evolucion", "comparado", "exportaciones"),
  variable = c("vab_indust_pc_indice", "gdp_indust_pc_indice", "prop_pct"),
  n_total  = c(nrow(arg), nrow(comparado), nrow(exportaciones)),
  n_faltantes = c(
    sum(is.na(arg$vab_indust_pc_indice)),
    sum(is.na(comparado$gdp_indust_pc_indice)),
    sum(is.na(exportaciones$prop_pct))
  )
)
tabla_faltantes$pct_faltantes <- round(
  tabla_faltantes$n_faltantes / tabla_faltantes$n_total * 100, 1)
print(tabla_faltantes)

# --- Guardar ---
write_csv(tabla_arg,       "output/tabla_descriptivas_arg.csv")
write_csv(tabla_comp,      "output/tabla_descriptivas_comparado.csv")
write_csv(tabla_faltantes, "output/tabla_faltantes.csv")

cat("\nDescriptivas guardadas en output/\n")
