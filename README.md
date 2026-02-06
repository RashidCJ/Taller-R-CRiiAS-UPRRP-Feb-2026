# Taller de R y RStudio — CRiiAS, UPR-RP

**Usando R y RStudio en la investigación académica**

Taller ofrecido el 6 de febrero de 2026 a través del Centro de Recursos de Investigación/Creación Interdisciplinaria y Aprendizaje Subgraduado (CRiiAS) del Recinto de Río Piedras de la Universidad de Puerto Rico.

## Contenido del taller

El taller ofrece una introducción práctica a R y RStudio orientada a personas que investigan en ciencias sociales, humanidades y artes. Cubre los siguientes temas:

1. **Primeros pasos en R** — la consola, objetos, vectores y funciones básicas
2. **Importación y exploración de datos** — paquetes, tipos de datos, `tidyverse` (filter, select, mutate, group_by, summarise)
3. **Visualización con ggplot2** — gramática de gráficos, capas, facetas, distribuciones
4. **Correlación** — coeficiente de Pearson, prueba de significancia, línea de regresión
5. **Datos de arte** — exploración de la colección del Tate de Londres con `modeldata`
6. **Análisis de texto en inglés** — `tidytext` con novelas de Jane Austen, `quanteda` con discursos inaugurales presidenciales
7. **Análisis de texto en español** — `gutenbergr` con el *Quijote*, stopwords en español, nubes de palabras

## Archivos en este repositorio

| Archivo | Descripción |
|---------|-------------|
| `Taller-CRiiAS.qmd` | Documento completo del taller (formato Quarto HTML) |
| `Taller-CRiiAS.html` | Documento renderizado, listo para consultar en el navegador |
| `Taller-CRiiAS-Presentacion.qmd` | Presentación RevealJS con notas del presentador |
| `Taller-CRiiAS.R` | Script de R con el código del taller |
| `uprrp.scss` | Tema institucional UPRRP para presentaciones RevealJS |
| `logos_combinados.png` | Logo combinado: sello del Recinto + Facultad de Ciencias Sociales |

## Paquetes necesarios

Para reproducir el taller, instalen los siguientes paquetes en R:

```r
install.packages(c(
  "tidyverse", "dslabs", "modeldata",
  "tidytext", "janeaustenr", "gutenbergr",
  "wordcloud", "RColorBrewer", "stopwords",
  "quanteda", "quanteda.textstats", "quanteda.textplots"
))
```

## Talleres previos

- [Secuencia de talleres de RStudio, febrero 2025](https://github.com/RashidCJ/Secuencia-de-Talleres-RStudio-FCS-UPRRP-Feb-2025) (4 talleres, CACCS FCS)
- [Secuencia de talleres de RStudio, septiembre 2025](https://github.com/RashidCJ/Secuencia-de-Talleres-RStudio-FCS-UPRRP-Sept-2025) (3 talleres, CACCS FCS)

## Recursos adicionales

- [Introducción a la ciencia de datos (Irizarry, español, gratis)](https://leanpub.com/dslibro)
- [R for Data Science (Wickham, inglés, gratis)](https://r4ds.hadley.nz/)
- [Text Mining with R (Silge & Robinson)](https://www.tidytextmining.com/)
- [Proyecto Gutenberg en español](https://www.gutenberg.org/browse/languages/es)
- [Posit Cloud — R en la nube](https://posit.cloud/)

## Contacto

**Rashid C.J. Marcano Rivera, Ph.D., M.S., M.A.**
Departamento de Sociología y Antropología, Facultad de Ciencias Sociales
Universidad de Puerto Rico, Recinto de Río Piedras
rashid.marcano@upr.edu
