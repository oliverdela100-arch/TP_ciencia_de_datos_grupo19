# run_all.R
# Script maestro: corre todos los scripts en orden
# Ejecutar desde la carpeta raíz del proyecto con: source("run_all.R")

cat("=== TP Final — Una industria que no levanta cabeza ===\n")
cat("Ciencia de Datos para Economía y Negocios — FCE, UBA\n")
cat("Grupo 19\n\n")

# Verificar que estamos en la carpeta correcta
if (!dir.exists("raw")) {
  stop("No se encuentra la carpeta raw/. Ejecutar desde la carpeta raíz del proyecto.")
}

# Crear carpetas si no existen
if (!dir.exists("input"))  dir.create("input")
if (!dir.exists("output")) dir.create("output")

# Instalar paquetes faltantes
paquetes <- c("dplyr", "readr", "ggplot2", "tidyr", "purrr")
nuevos   <- paquetes[!(paquetes %in% installed.packages()[, "Package"])]
if (length(nuevos) > 0) {
  message(sprintf("Instalando: %s", paste(nuevos, collapse = ", ")))
  install.packages(nuevos, repos = "https://cran.r-project.org")
}

scripts <- c(
  "scripts/01_limpieza.R",
  "scripts/02_descriptivas.R",
  "scripts/03_grafico_comunicacional.R",
  "scripts/04_grafico_exploratorio.R",
  "scripts/05_exportaciones.R"
)

for (s in scripts) {
  cat(sprintf("\n--- Corriendo %s ...\n", s))
  source(s, local = TRUE)
  cat(sprintf("    OK\n"))
}

cat("\n=== Pipeline completado. Resultados en output/ ===\n")

source("run_all.R")


