library(ggplot2); library(dplyr); library(readr); library(ggrepel)
source("scripts/00_theme.R")
country_order <- c("United States", "Germany", "Japan", "India")

# ------------------------------------------------------------
# GRAPH 8 — Real GDP Growth vs Employment Growth (cleaner scatter)
# ------------------------------------------------------------
d8 <- read_csv("data/employment_vs_growth.csv", show_col_types = FALSE) %>%
  mutate(country = factor(country, levels = country_order),
         short_label = paste0(country, " '", substr(year, 3, 4)))

g8 <- ggplot(d8, aes(x = employment_growth, y = real_gdp_growth, color = country)) +
  geom_smooth(aes(group = 1), method = "lm", se = FALSE, color = "grey55",
              linetype = "dashed", linewidth = 0.7) +
  geom_point(size = 4.2, alpha = 0.95) +
  geom_text_repel(aes(label = short_label), fontface = "bold", size = 3.4,
                   family = "serif", show.legend = FALSE, seed = 42,
                   box.padding = 0.55, point.padding = 0.35,
                   min.segment.length = 0, segment.color = "grey50",
                   segment.size = 0.35, max.overlaps = 20,
                   force = 3, force_pull = 0.5) +
  scale_color_manual(values = country_colors) +
  scale_x_continuous(expand = expansion(mult = 0.15)) +
  scale_y_continuous(expand = expansion(mult = 0.15)) +
  labs(title = "Graph 8. Real GDP Growth vs. Employment Growth",
       subtitle = "Dashed line: overall linear trend across all country-years. Labels show country and year.",
       x = "Employment Growth (%)", y = "Real GDP Growth (%)", color = NULL,
       caption = "Source: National labour force surveys / Author's compilation") +
  theme_academic() +
  guides(color = guide_legend(override.aes = list(size = 4)))
save_academic(g8, "graph8_realgrowth_vs_employment_scatter", width = 10, height = 7.5)

# ------------------------------------------------------------
# GRAPH 9 — Real GDP Growth vs Unemployment Rate (cleaner scatter)
# ------------------------------------------------------------
d9 <- read_csv("data/unemployment_vs_growth.csv", show_col_types = FALSE) %>%
  mutate(country = factor(country, levels = country_order),
         short_label = paste0(country, " '", substr(year, 3, 4)))

g9 <- ggplot(d9, aes(x = unemployment_rate, y = real_gdp_growth, color = country)) +
  geom_smooth(aes(group = 1), method = "lm", se = FALSE, color = "grey55",
              linetype = "dashed", linewidth = 0.7) +
  geom_point(size = 4.2, alpha = 0.95) +
  geom_text_repel(aes(label = short_label), fontface = "bold", size = 3.4,
                   family = "serif", show.legend = FALSE, seed = 42,
                   box.padding = 0.55, point.padding = 0.35,
                   min.segment.length = 0, segment.color = "grey50",
                   segment.size = 0.35, max.overlaps = 20,
                   force = 3, force_pull = 0.5) +
  scale_color_manual(values = country_colors) +
  scale_x_continuous(expand = expansion(mult = 0.15)) +
  scale_y_continuous(expand = expansion(mult = 0.15)) +
  labs(title = "Real GDP Growth vs. Unemployment Rate, 2021–2023",
       subtitle = "The figure provides descriptive evidence on the relationship between real GDP growth and unemployment rates. Labels show country and year.",
       x = "Unemployment Rate (%)", y = "Real GDP Growth (%)", color = NULL,
       caption = "Source: National labour force surveys / Author's compilation") +
  theme_academic() +
  guides(color = guide_legend(override.aes = list(size = 4)))
save_academic(g9, "graph9_realgrowth_vs_unemployment_scatter", width = 10, height = 7.5)

message("Graphs 8 and 9 rebuilt with cleaner label layout")
