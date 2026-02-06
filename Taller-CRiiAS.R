# ============================================================================
# Taller: Usando R y RStudio en la investigación académica
# CRiiAS — 6 de febrero de 2026
# Rashid C.J. Marcano Rivera, Ph.D., M.S., M.A.
# ============================================================================
# Este script acompaña el documento Quarto del taller.
# Pueden ejecutar línea por línea con Cmd+Return (Mac) o Ctrl+Enter (PC).
# ============================================================================

# --- INSTALACIÓN DE PAQUETES (ejecutar solo una vez) ---
# install.packages(c(
#   "tidyverse", "dslabs", "modeldata",
#   "tidytext", "janeaustenr", "gutenbergr",
#   "wordcloud", "RColorBrewer", "stopwords",
#   "quanteda", "quanteda.textstats", "quanteda.textplots"
# ))

# ============================================================================
# PARTE 1: FUNDAMENTOS DE R
# ============================================================================

# --- R como calculadora ---
1 + 2
13 / 2
2 ^ 6
sqrt(81)

# --- Asignando valores a objetos ---
x <- 4
x
x + 2

# Texto (entre comillas)
isla <- "Puerto Rico"
isla

# Valores lógicos
bilingue <- TRUE
bilingue

# --- Vectores y funciones básicas ---
edades <- c(23, 31, 27, 45, 38, 22, 29)
mean(edades)    # media o promedio
sd(edades)      # desviación estándar
range(edades)   # rango (mínimo y máximo)

# Contar participantes por área
humanidades <- 4
ciencias_sociales <- 3
artes <- 2
total <- humanidades + ciencias_sociales + artes
print(paste0("Total de participantes: ", total))

# ============================================================================
# PARTE 2: IMPORTANDO Y EXPLORANDO DATOS
# ============================================================================

library(tidyverse)
library(dslabs)

# Datos preexistentes: esperanza de vida y desarrollo mundial
data(gapminder)
names(gapminder)    # nombres de las variables
head(gapminder)     # primeras filas
summary(gapminder)  # resumen estadístico

# --- Filtrando datos del Caribe ---
gapminder |>
  filter(country %in% c("Puerto Rico", "Cuba", "Dominican Republic",
                         "Jamaica", "Trinidad and Tobago"),
         year %in% c(1970, 1990, 2010)) |>
  select(country, year, life_expectancy, fertility, population) |>
  arrange(year, country)

# --- El pipe |> ---
gapminder |>
  select(country, year, life_expectancy) |>
  filter(country == "Puerto Rico") |>
  arrange(year)

# --- Resumiendo por grupos ---
gapminder |>
  filter(year == 2010) |>
  group_by(continent) |>
  summarise(
    esperanza_media = mean(life_expectancy, na.rm = TRUE),
    paises = n()
  ) |> arrange(desc(esperanza_media))

# ============================================================================
# PARTE 3: VISUALIZACIÓN CON ggplot2
# ============================================================================

# --- Lienzo vacío y primer gráfico ---
gapminder |>
  filter(year == 2010, !is.na(gdp)) |>
  ggplot()

gapminder |>
  filter(year == 2010, !is.na(gdp)) |>
  ggplot(aes(x = gdp/population, y = life_expectancy)) +
  geom_point()

# --- Gráfico con múltiples capas ---
gapminder |>
  filter(year == 2010, !is.na(gdp)) |>
  mutate(pib_per_capita = gdp / population) |>
  ggplot(aes(x = pib_per_capita, y = life_expectancy,
             colour = continent, size = population/10^6)) +
  geom_point(alpha = 0.7) +
  scale_x_log10() +
  labs(
    title = "Esperanza de vida y PIB per cápita (2010)",
    x = "PIB per cápita (escala logarítmica)",
    y = "Esperanza de vida (años)",
    colour = "Continente",
    size = "Población\n(millones)"
  ) +
  theme_minimal()

# --- Facetas: comparando épocas ---
gapminder |>
  filter(year %in% c(1970, 2010)) |>
  ggplot(aes(x = fertility, y = life_expectancy, colour = continent)) +
  geom_point(alpha = 0.6) +
  facet_wrap(continent ~ year) +
  labs(
    title = "Convergencia global: fertilidad y esperanza de vida",
    x = "Fertilidad",
    y = "Esperanza de vida (años)",
    colour = "Continente"
  ) +
  theme_minimal()

# --- El Caribe a través del tiempo ---
caribe <- c("Puerto Rico", "Cuba", "Dominican Republic",
            "Jamaica", "Trinidad and Tobago", "Haiti")

gapminder |>
  filter(country %in% caribe) |>
  ggplot(aes(x = year, y = life_expectancy, colour = country)) +
  geom_line(linewidth = 1.2) +
  geom_point(size = 2) +
  labs(
    title = "Esperanza de vida en el Caribe (1960–2016)",
    x = "Año",
    y = "Esperanza de vida (años)",
    colour = "País"
  ) +
  theme_minimal()

# --- Distribuciones por región ---
gapminder |>
  filter(year == 2010, !is.na(gdp)) |>
  mutate(
    dolares_dia = gdp / population / 365,
    grupo = case_when(
      region %in% c("Caribbean", "Central America",
                    "South America") ~ "Latinoamérica y Caribe",
      region %in% c("Western Europe", "Northern Europe", "Southern Europe",
                    "Northern America",
                    "Australia and New Zealand") ~ "Occidente",
      continent == "Africa" ~ "África",
      TRUE ~ "Asia y otros"
    )
  ) |>
  ggplot(aes(x = reorder(grupo, dolares_dia, FUN = median),
             y = dolares_dia)) +
  geom_boxplot(aes(fill = grupo), alpha = 0.7) +
  scale_y_log10() +
  labs(
    title = "Ingreso diario per cápita por región (2010)",
    x = "", y = "Dólares por día (escala logarítmica)"
  ) +
  theme_minimal() +
  theme(legend.position = "none",
        axis.text.x = element_text(angle = 15, hjust = 1))

# ============================================================================
# PARTE 4: DATOS DE ARTE — COLECCIÓN DEL TATE
# ============================================================================

library(modeldata)
data(tate_text)

# Explorando la colección
names(tate_text)
head(tate_text)

# Los 15 artistas más representados
tate_text |>
  count(artist, sort = TRUE) |>
  head(15)

# Obras a través del tiempo
tate_text |>
  filter(!is.na(year), year >= 1800) |>
  ggplot(aes(x = year)) +
  geom_histogram(binwidth = 1, fill = "steelblue", colour = "white") +
  labs(
    title = "Obras en la colección del Tate por década de creación",
    x = "Año de creación",
    y = "Cantidad de obras"
  ) +
  theme_minimal()

# Medios artísticos más frecuentes
tate_text |>
  mutate(medio_simple = word(medium, 1, 2)) |>
  count(medio_simple, sort = TRUE) |>
  head(12) |>
  ggplot(aes(x = reorder(medio_simple, n), y = n)) +
  geom_col(fill = "coral3") +
  coord_flip() +
  labs(
    title = "Medios artísticos más frecuentes en el Tate",
    x = "", y = "Cantidad de obras"
  ) +
  theme_minimal()

# ============================================================================
# PARTE 5: ANÁLISIS DE TEXTO
# ============================================================================

# --- tidytext: Jane Austen ---
library(tidytext)
library(janeaustenr)

# Convertir las novelas en una tabla de palabras (tokens)
austen_palabras <- austen_books() |>
  unnest_tokens(word, text)

# ¿Cuántas palabras tiene cada novela?
austen_palabras |>
  count(book, sort = TRUE)

# Frecuencias sin palabras vacías
austen_freq <- austen_palabras |>
  anti_join(stop_words, by = "word") |>
  count(book, word, sort = TRUE)

# Las 10 palabras más frecuentes por novela
austen_freq |>
  group_by(book) |>
  slice_max(n, n = 10) |>
  ggplot(aes(x = reorder_within(word, n, book), y = n, fill = book)) +
  geom_col(show.legend = FALSE) +
  facet_wrap(~ book, scales = "free_y") +
  scale_x_reordered() +
  coord_flip() +
  labs(
    title = "Palabras más frecuentes en las novelas de Jane Austen",
    x = "", y = "Frecuencia"
  ) +
  theme_minimal()

# --- Nube de palabras: Orgullo y Prejuicio ---
library(wordcloud)

austen_palabras |>
  filter(book == "Pride & Prejudice") |>
  anti_join(stop_words, by = "word") |>
  count(word, sort = TRUE) |>
  with(wordcloud(word, n, max.words = 200,
                 colors = brewer.pal(8, "Dark2")))

# ============================================================================
# PARTE 6: LITERATURA EN ESPAÑOL — PROYECTO GUTENBERG
# ============================================================================

library(gutenbergr)

# Buscar obras disponibles en español
obras_es <- gutenberg_works(languages = "es")
nrow(obras_es)

# Algunas obras notables
obras_es |>
  filter(grepl("Cervantes|Hostos|Dario|Burgos", author, ignore.case = TRUE)) |>
  select(gutenberg_id, title, author) |>
  head(10)

# Descargar el texto del Quijote (ID 2000 en Gutenberg)
quijote <- gutenberg_download(2000)
head(quijote$text, 20)
nrow(quijote)

# Tokenizar el Quijote
quijote_palabras <- quijote |>
  unnest_tokens(palabra, text)

# Total de palabras
nrow(quijote_palabras)

# Remover stopwords en español
library(stopwords)
vacias_es <- tibble(palabra = stopwords("es", source = "stopwords-iso"))

quijote_freq <- quijote_palabras |>
  anti_join(vacias_es, by = "palabra") |>
  filter(nchar(palabra) > 2) |>
  count(palabra, sort = TRUE)

head(quijote_freq, 20)

# Nube de palabras del Quijote
quijote_freq |>
  with(wordcloud(palabra, n, max.words = 100,
                 colors = brewer.pal(8, "Spectral")))

# Las 20 palabras más frecuentes del Quijote
quijote_freq |>
  head(20) |>
  ggplot(aes(x = reorder(palabra, n), y = n)) +
  geom_col(fill = "darkgoldenrod3") +
  coord_flip() +
  labs(
    title = "Palabras más frecuentes en Don Quijote de la Mancha",
    subtitle = "Texto completo del Proyecto Gutenberg, sin palabras vacías",
    x = "", y = "Frecuencia"
  ) +
  theme_minimal()

# ============================================================================
# PARTE 7: QUANTEDA — ANÁLISIS AVANZADO
# ============================================================================

library(quanteda)
library(quanteda.textstats)
library(quanteda.textplots)

# Discursos inaugurales presidenciales (incluidos en quanteda)
corp_inaug <- data_corpus_inaugural
summary(corp_inaug, 10)

# Tokenizar, limpiar y remover stopwords en inglés
toks_inaug <- tokens(
  corp_inaug,
  remove_punct = TRUE,
  remove_numbers = TRUE,
  remove_symbols = TRUE
) |>
  tokens_tolower() |>
  tokens_remove(stopwords("en"))

# Crear la DFM
dfm_inaug <- dfm(toks_inaug)

# Los 20 términos más frecuentes en todo el corpus
topfeatures(dfm_inaug, 20)

# Nube de palabras
textplot_wordcloud(dfm_inaug, max_words = 100,
                   color = brewer.pal(8, "Set1"))

# Keyness: Obama 2009 vs. Trump 2017
dfm_comparacion <- dfm_inaug |>
  dfm_subset(President %in% c("Obama", "Trump") &
               Year %in% c(2009, 2017))

k <- textstat_keyness(dfm_comparacion,
                      target = docvars(dfm_comparacion)$President == "Obama")
textplot_keyness(k, n = 15) +
  labs(title = "Vocabulario distintivo: Obama 2009 vs. Trump 2017")

# Colocaciones
coll <- textstat_collocations(toks_inaug, size = 2, min_count = 5)
head(coll, 15)

# Red de co-ocurrencias (discursos de Obama)
toks_obama <- tokens_subset(toks_inaug, President == "Trump")
fcmat <- fcm(toks_obama, context = "window", window = 5)
fuerza <- sort(Matrix::colSums(fcmat), decreasing = TRUE)
principales <- names(fuerza)[1:min(30, length(fuerza))]
fcm_sub <- fcm_select(fcmat, pattern = principales)

textplot_network(fcm_sub, min_freq = 3, edge_alpha = 0.5) +
  labs(title = "Red de co-ocurrencia: discursos de Trump")
