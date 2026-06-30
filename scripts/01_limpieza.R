# 01_limpieza.R
# Carga los datos crudos, los limpia y guarda en input/
# Output: input/arg_evolucion.csv, input/comparado.csv

library(dplyr)
library(readr)

# --- Cargar datos crudos ---
arg_raw        <- read_csv("C:/Users/WINDOWS/OneDrive/Desktop/exploraaaa/raw/pib_indust_per_capita_arg_evolucion.csv", show_col_types = FALSE)
comparado_raw  <- read_csv("C:/Users/WINDOWS/OneDrive/Desktop/exploraaaa/raw/pib_indust_per_capita_comparado.csv",    show_col_types = FALSE)
expo_raw       <- read_csv("C:/Users/WINDOWS/OneDrive/Desktop/exploraaaa/raw/peso_arg_expo_ind.csv",                  show_col_types = FALSE)

# --- Limpieza: evolucion Argentina ---
# Filtramos al periodo de analisis (1970-2024)
# La base ya viene en formato largo y sin faltantes relevantes
arg <- arg_raw %>%
  filter(anio >= 1970) %>%
  select(anio, vab_indust_pc_indice) %>%
  arrange(anio)

cat(sprintf("Argentina: %d observaciones, anos %d-%d\n",
    nrow(arg), min(arg$anio), max(arg$anio)))
cat(sprintf("Faltantes: %d\n", sum(is.na(arg$vab_indust_pc_indice))))

# --- Limpieza: comparado internacional ---
paises_interes <- c("ARG", "FRA", "KOR", "MEX")

comparado <- comparado_raw %>%
  filter(geocodigoFundar %in% paises_interes, anio >= 1970) %>%
  mutate(pais = case_when(
    geocodigoFundar == "ARG" ~ "Argentina",
    geocodigoFundar == "FRA" ~ "Francia",
    geocodigoFundar == "KOR" ~ "Corea del Sur",
    geocodigoFundar == "MEX" ~ "Mexico"
  )) %>%
  select(pais, anio, gdp_indust_pc_indice) %>%
  arrange(pais, anio)

cat(sprintf("Comparado: %d observaciones\n", nrow(comparado)))
cat(sprintf("Faltantes: %d\n", sum(is.na(comparado$gdp_indust_pc_indice))))

# --- Limpieza: exportaciones ---
expo <- expo_raw %>%
  filter(geocodigoFundar %in% paises_interes, anio >= 1970) %>%
  mutate(pais = case_when(
    geocodigoFundar == "ARG" ~ "Argentina",
    geocodigoFundar == "FRA" ~ "Francia",
    geocodigoFundar == "KOR" ~ "Corea del Sur",
    geocodigoFundar == "MEX" ~ "Mexico"
  ),
  prop_pct = prop_mundial * 100) %>%
  select(pais, anio, prop_pct) %>%
  arrange(pais, anio)

# --- Guardar en input/ ---
write_csv(arg,       "C:/Users/WINDOWS/OneDrive/Desktop/exploraaaa/input/pib_indust_per_capita_arg_evolucion.csv")
write_csv(comparado, "C:/Users/WINDOWS/OneDrive/Desktop/exploraaaa/input/pib_indust_per_capita_comparado.csv")
write_csv(expo,      "C:/Users/WINDOWS/OneDrive/Desktop/exploraaaa/input/peso_arg_expo_ind.csv")

cat("Limpieza completada. Archivos guardados en input/\n")
