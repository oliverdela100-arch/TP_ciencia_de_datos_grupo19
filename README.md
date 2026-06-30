# Una industria que no levanta cabeza
## Evolución del PIB industrial per cápita en Argentina (1970–2024)

**Materia:** Ciencia de Datos para Economía y Negocios — FCE, UBA  
**Grupo:** 19  
**Integrantes:** 912164 · 913221  
**Docente:** Nicolás Sidicaro  

---

## Cómo ejecutar

Desde RStudio, abrir el proyecto desde la carpeta raíz y correr:

```r
source("run_all.R")
```

O desde la terminal:

```
Rscript run_all.R
```

El script maestro instala automáticamente los paquetes faltantes y corre todos los scripts en orden.

### Paquetes necesarios
```r
install.packages(c("dplyr", "readr", "ggplot2", "tidyr", "purrr"))
```

---

## Estructura de carpetas

```
├── raw/          # Datos crudos de Argendata — no se modifican
├── input/        # Datos procesados — producto de 01_limpieza.R
├── output/       # Gráficos y tablas — producto de los scripts de análisis
├── auxiliar/     # Bases de datos complementarias (vacía: todo proviene de Argendata)
├── utils/        # Funciones personalizadas (vacía: no se reutilizan funciones entre scripts)
├── scripts/      # Códigos en orden de ejecución
├── run_all.R     # Script maestro
└── README.md
```

---

## Scripts — orden y descripción

| Script | Qué hace | Lee de | Genera en |
|--------|----------|--------|-----------|
| `01_limpieza.R` | Filtra 1970 en adelante, selecciona 4 países, unifica nombres, convierte prop_mundial a % | `raw/` | `input/` |
| `02_descriptivas.R` | Media, mediana, desvío, mín/máx por subperiodo; tabla de faltantes con evidencia | `input/` | `output/tabla_descriptivas_arg.csv`, `tabla_descriptivas_comparado.csv`, `tabla_faltantes.csv` |
| `03_grafico_comunicacional.R` | Serie Argentina vs Francia y México con anotaciones (dictadura, crisis 2001, pico 1974); Corea del Sur en gráfico aparte | `input/` | `output/grafico_comunicacional.png`, `grafico_corea.png` |
| `04_grafico_exploratorio.R` | Event study por crisis, definidas por el piso real de la serie (no el año histórico) | `input/` | `output/grafico_exploratorio.png` |
| `05_exportaciones.R` | Participación en exportaciones manufactureras mundiales por país (1962–2023) | `input/` | `output/grafico_exportaciones.png`, `tabla_exportaciones.csv` |

---

## Fuentes

Todas las bases provienen del tópico Industria de **Argendata (Fundación Fundar)**:  
[argendata.fund.ar/topico/industria](https://argendata.fund.ar/topico/industria)

- **PIB industrial per cápita — Argentina:** Cuentas Nacionales, INDEC; Fundación Norte y Sur; Lattes et al. (1975)  
- **PIB industrial per cápita — comparado:** National Accounts, UNSTATS  
- **Exportaciones manufactureras:** Harvard Growth Lab, BACI-CEPII
