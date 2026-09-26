# ============================================================
# 01_generate_graphs.R
# Generates all 10 case-study graphs for:
# "Nominal vs. Real GDP During High-Inflation Periods:
#  The Post-Pandemic Global Inflation Surge (2021-2023)"
# Countries: United States, Germany, Japan, India
#
# Run from the project root:  Rscript scripts/01_generate_graphs.R
# Output: output/graphs/*.png and *.pdf (300+ dpi, print-ready)
# ============================================================

library(ggplot2)
library(dplyr)
library(tidyr)
library(readr)
library(scales)
library(forcats)

source("scripts/00_theme.R")
dir.create("output/graphs", recursive = TRUE, showWarnings = FALSE)

country_order <- c("United States", "Germany", "Japan", "India")

# ------------------------------------------------------------
# GRAPH 1 — Nominal vs Real GDP Growth (Grouped Bar)
# ------------------------------------------------------------
d1 <- read_csv("data/gdp_growth.csv", show_col_types = FALSE) %>%
  mutate(country = factor(country, levels = country_order)) %>%
  pivot_longer(c(nominal_gdp_growth, real_gdp_growth),
               names_to = "series", values_to = "growth") %>%
  mutate(series = recode(series,
                          nominal_gdp_growth = "Nominal GDP Growth",
                          real_gdp_growth = "Real GDP Growth"),
         cy = paste0(country, "\n(", year_label, ")"),
         cy = fct_inorder(cy))

g1 <- ggplot(d1, aes(x = cy, y = growth, fill = series)) +
  geom_col(position = position_dodge(width = 0.75), width = 0.68, color = "white", linewidth = 0.2) +
  geom_hline(yintercept = 0, color = "grey40", linewidth = 0.4) +
  geom_text(aes(label = sprintf("%.1f", growth),
                vjust = ifelse(growth >= 0, -0.4, 1.3)),
            position = position_dodge(width = 0.75), size = 2.6, fontface = "bold",
            family = "serif", show.legend = FALSE) +
  scale_fill_manual(values = c("Nominal GDP Growth" = "#1B3A6B", "Real GDP Growth" = "#D98E04")) +
  scale_y_continuous(expand = expansion(mult = c(0.05, 0.08))) +
  labs(title = "Graph 1. Nominal GDP Growth vs. Real GDP Growth (2021-2023)",
       subtitle = "The widening gap between the two series reflects the inflationary component of nominal growth",
       x = NULL, y = "Growth (%)", fill = NULL,
       caption = "Source: MOSPI, BEA, Destatis, Japan Cabinet Office / Author's compilation") +
  theme_academic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = rel(0.75)))
save_academic(g1, "graph1_nominal_vs_real_gdp_growth", width = 10, height = 6)

# ------------------------------------------------------------
# GRAPH 2 — Nominal-Real GDP Growth Gap (Line Chart)
# ------------------------------------------------------------
d2 <- read_csv("data/gdp_growth.csv", show_col_types = FALSE) %>%
  mutate(country = factor(country, levels = country_order),
         gap = nominal_gdp_growth - real_gdp_growth)

g2 <- ggplot(d2, aes(x = year, y = gap, color = country, group = country)) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2.6) +
  ggrepel::geom_text_repel(aes(label = sprintf("%.1f", gap)), size = 3.2, fontface = "bold",
                            family = "serif", show.legend = FALSE, seed = 3,
                            min.segment.length = Inf, direction = "y", box.padding = 0.25) +
  scale_color_manual(values = country_colors) +
  scale_x_continuous(breaks = c(2021, 2022, 2023)) +
  labs(title = "Graph 2. Nominal-Real GDP Growth Gap, 2021-2023",
       subtitle = "Gap = Nominal GDP Growth - Real GDP Growth (approximates the GDP deflator)",
       x = "Year", y = "Gap (percentage points)", color = NULL,
       caption = "Source: Author's calculation from national statistical agencies") +
  theme_academic()
save_academic(g2, "graph2_nominal_real_gap", width = 9, height = 6)

# ------------------------------------------------------------
# GRAPH 3 — GDP Deflator vs CPI Inflation (Line Chart, faceted)
# ------------------------------------------------------------
d3 <- read_csv("data/deflator_cpi.csv", show_col_types = FALSE) %>%
  mutate(country = factor(country, levels = country_order)) %>%
  pivot_longer(c(gdp_deflator, cpi_inflation), names_to = "measure", values_to = "value") %>%
  mutate(measure = recode(measure, gdp_deflator = "GDP Deflator", cpi_inflation = "CPI Inflation"))

g3 <- ggplot(d3, aes(x = year, y = value, color = measure, group = measure)) +
  geom_line(linewidth = 1) +
  geom_point(size = 2) +
  geom_text(aes(label = sprintf("%.1f", value)), size = 2.4, fontface = "bold",
            family = "serif", show.legend = FALSE, vjust = -0.9) +
  facet_wrap(~country, nrow = 1) +
  scale_color_manual(values = c("GDP Deflator" = "#1B3A6B", "CPI Inflation" = "#B23A2E")) +
  scale_x_continuous(breaks = c(2021, 2022, 2023)) +
  labs(title = "Graph 3. GDP Deflator vs. CPI Inflation by Country (2021-2023)",
       subtitle = "Divergence between the two price measures reflects differing consumption vs. production baskets",
       x = "Year", y = "Rate (%)", color = NULL,
       caption = "Source: National statistical agencies / Author's compilation") +
  theme_academic() +
  theme(panel.spacing = unit(1.1, "lines"))
save_academic(g3, "graph3_deflator_vs_cpi", width = 12, height = 5.5)

# ------------------------------------------------------------
# GRAPH 4 — Real GDP Recovery Trajectory, 2019 = 100 (Line Chart)
# ------------------------------------------------------------
d4 <- read_csv("data/real_gdp_index.csv", show_col_types = FALSE) %>%
  pivot_longer(-country, names_to = "year", values_to = "index") %>%
  mutate(year = as.integer(gsub("year_", "", year)),
         country = factor(country, levels = country_order))

g4 <- ggplot(d4, aes(x = year, y = index, color = country, group = country)) +
  geom_hline(yintercept = 100, linetype = "dashed", color = "grey50", linewidth = 0.4) +
  geom_line(linewidth = 1.1) +
  geom_point(size = 2.4) +
  geom_text(data = d4 %>% filter(year == max(year)),
            aes(label = sprintf("%.1f", index)), size = 3.2, fontface = "bold",
            family = "serif", hjust = -0.25, show.legend = FALSE) +
  geom_text(data = d4 %>% filter(year == min(year)),
            aes(label = sprintf("%.1f", index)), size = 3.2, fontface = "bold",
            family = "serif", vjust = 1.6, show.legend = FALSE) +
  scale_color_manual(values = country_colors) +
  scale_x_continuous(breaks = 2019:2023, expand = expansion(mult = c(0.05, 0.09))) +
  labs(title = "Graph 4. Real GDP Recovery Trajectory (2019 = 100)",
       subtitle = "India shows the strongest post-pandemic real GDP recovery; Germany shows the weakest",
       x = "Year", y = "Real GDP Index (2019 = 100)", color = NULL,
       caption = "Source: Author's calculation from national statistical agencies") +
  theme_academic()
save_academic(g4, "graph4_real_gdp_recovery_index", width = 9, height = 6)

# ------------------------------------------------------------
# GRAPH 5 — Real GDP Growth vs GDP Deflator (Grouped Bar, by Country-Year)
# ------------------------------------------------------------
d5 <- read_csv("data/deflator_vs_realgrowth.csv", show_col_types = FALSE) %>%
  mutate(country = factor(country, levels = country_order),
         cy = paste0(country, "\n(", year_label, ")"),
         cy = fct_inorder(cy)) %>%
  pivot_longer(c(gdp_deflator, real_gdp_growth), names_to = "series", values_to = "value") %>%
  mutate(series = recode(series,
                          gdp_deflator = "GDP Deflator",
                          real_gdp_growth = "Real GDP Growth"),
         series = factor(series, levels = c("GDP Deflator", "Real GDP Growth")))

g5 <- ggplot(d5, aes(x = cy, y = value, fill = series)) +
  geom_col(position = position_dodge(width = 0.75), width = 0.68, color = "white", linewidth = 0.2) +
  geom_hline(yintercept = 0, color = "grey40", linewidth = 0.4) +
  geom_text(aes(label = sprintf("%.1f", value),
                vjust = ifelse(value >= 0, -0.4, 1.3)),
            position = position_dodge(width = 0.75), size = 2.6, fontface = "bold",
            family = "serif", show.legend = FALSE) +
  scale_fill_manual(values = c("GDP Deflator" = "#1B3A6B", "Real GDP Growth" = "#D98E04")) +
  scale_y_continuous(expand = expansion(mult = c(0.05, 0.08))) +
  labs(title = "Graph 5. Real GDP Growth vs. GDP Deflator, by Country-Year",
       subtitle = "Bars close in height indicate real growth and price effects were similarly sized that year",
       x = NULL, y = "Rate (%)", fill = NULL,
       caption = "Source: Author's compilation from national statistical agencies") +
  theme_academic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = rel(0.75)))
save_academic(g5, "graph5_realgrowth_vs_deflator_scatter", width = 12, height = 6.5)

# ------------------------------------------------------------
# GRAPH 6 — Expenditure Components of Real GDP Growth (Grouped Bar)
# ------------------------------------------------------------
# helper (base R has no str_to_title) -> simple capitalisation
str_to_title_ <- function(x) paste0(toupper(substr(x,1,1)), substr(x,2,nchar(x)))

d6 <- read_csv("data/expenditure_components_growth.csv", show_col_types = FALSE) %>%
  mutate(country = factor(country, levels = country_order)) %>%
  pivot_longer(c(consumption, investment, government, exports, imports),
               names_to = "component", values_to = "growth") %>%
  mutate(component = str_to_title_(component),
         component = factor(component, levels = c("Consumption","Investment","Government","Exports","Imports")),
         cy = paste0(country, " ", year_label), cy = fct_inorder(cy))

g6 <- ggplot(d6, aes(x = component, y = growth, fill = component)) +
  geom_col(width = 0.7, color = "white", linewidth = 0.2) +
  geom_hline(yintercept = 0, color = "grey40", linewidth = 0.4) +
  facet_wrap(~cy, nrow = 4) +
  scale_fill_viridis_d(option = "cividis") +
  labs(title = "Graph 6. Expenditure Components of Real GDP Growth",
       subtitle = "Growth rate of each expenditure component, by country-year (not percentage-point contributions)",
       x = NULL, y = "Real Growth (%)", fill = NULL,
       caption = "Source: National accounts data / Author's compilation") +
  theme_academic() +
  theme(axis.text.x = element_text(angle = 40, hjust = 1, size = rel(0.65)),
        legend.position = "bottom",
        strip.text = element_text(size = rel(0.75)))
save_academic(g6, "graph6_expenditure_components_growth", width = 11, height = 11)

# ------------------------------------------------------------
# GRAPH 7 — Contribution to Real GDP Growth (Stacked Bar)
# ------------------------------------------------------------
d7 <- read_csv("data/contribution_to_growth.csv", show_col_types = FALSE) %>%
  mutate(country = factor(country, levels = country_order)) %>%
  pivot_longer(c(consumption, investment, inventory, government, net_exports, statistical_discrepancy),
               names_to = "component", values_to = "contribution") %>%
  mutate(component = recode(component,
                             consumption = "Consumption", investment = "Investment",
                             inventory = "Inventory Change", government = "Government",
                             net_exports = "Net Exports", statistical_discrepancy = "Stat. Discrepancy"),
         component = factor(component, levels = c("Consumption","Investment","Inventory Change",
                                                    "Government","Net Exports","Stat. Discrepancy")),
         cy = paste0(country, "\n", year_label), cy = fct_inorder(cy))

d7_totals <- d7 %>%
  group_by(cy) %>%
  summarise(total = sum(contribution), .groups = "drop")

g7 <- ggplot(d7, aes(x = cy, y = contribution, fill = component)) +
  geom_col(width = 0.65, color = "white", linewidth = 0.15) +
  geom_hline(yintercept = 0, color = "grey30", linewidth = 0.4) +
  geom_text(data = d7_totals, aes(x = cy, y = total, label = sprintf("%.1f", total)),
            inherit.aes = FALSE, vjust = -0.5, size = 3, fontface = "bold", family = "serif") +
  scale_fill_viridis_d(option = "plasma", end = 0.9) +
  scale_y_continuous(expand = expansion(mult = c(0.05, 0.1))) +
  labs(title = "Graph 7. Contributions to Real GDP Growth by Expenditure Component",
       subtitle = "Percentage-point contributions of each component (components sum to real GDP growth)",
       x = NULL, y = "Contribution (percentage points)", fill = NULL,
       caption = "Source: National accounts data / Author's compilation") +
  theme_academic() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1, size = rel(0.68)))
save_academic(g7, "graph7_contribution_to_growth_stacked", width = 12, height = 6.5)

# ------------------------------------------------------------
# GRAPH 8 — Real GDP Growth vs Employment Growth (Scatter)
# ------------------------------------------------------------
d8 <- read_csv("data/employment_vs_growth.csv", show_col_types = FALSE) %>%
  mutate(country = factor(country, levels = country_order))

g8 <- ggplot(d8, aes(x = employment_growth, y = real_gdp_growth, color = country)) +
  geom_point(size = 3.4, alpha = 0.9) +
  ggrepel::geom_text_repel(aes(label = year_label), size = 3, family = "serif",
                            show.legend = FALSE, seed = 7) +
  geom_smooth(aes(group = 1), method = "lm", se = FALSE, color = "grey40",
              linetype = "dashed", linewidth = 0.6) +
  scale_color_manual(values = country_colors) +
  labs(title = "Graph 8. Real GDP Growth vs. Employment Growth",
       subtitle = "Dashed line: overall linear trend across all country-years",
       x = "Employment Growth (%)", y = "Real GDP Growth (%)", color = NULL,
       caption = "Source: National labour force surveys / Author's compilation") +
  theme_academic()
save_academic(g8, "graph8_realgrowth_vs_employment_scatter", width = 9, height = 6.5)

# ------------------------------------------------------------
# GRAPH 9 — Real GDP Growth vs Unemployment Rate (Scatter)
# ------------------------------------------------------------
d9 <- read_csv("data/unemployment_vs_growth.csv", show_col_types = FALSE) %>%
  mutate(country = factor(country, levels = country_order))

g9 <- ggplot(d9, aes(x = unemployment_rate, y = real_gdp_growth, color = country)) +
  geom_point(size = 3.4, alpha = 0.9) +
  ggrepel::geom_text_repel(aes(label = year_label), size = 3, family = "serif",
                            show.legend = FALSE, seed = 11) +
  geom_smooth(aes(group = 1), method = "lm", se = FALSE, color = "grey40",
              linetype = "dashed", linewidth = 0.6) +
  scale_color_manual(values = country_colors) +
  labs(title = "Graph 9. Real GDP Growth vs. Unemployment Rate",
       subtitle = "A rough empirical analogue to Okun's Law across four economies, 2021-2023",
       x = "Unemployment Rate (%)", y = "Real GDP Growth (%)", color = NULL,
       caption = "Source: National labour force surveys / Author's compilation") +
  theme_academic()
save_academic(g9, "graph9_realgrowth_vs_unemployment_scatter", width = 9, height = 6.5)

# ------------------------------------------------------------
# GRAPH 10 — Real GDP Per Capita Growth (Grouped Bar)
# ------------------------------------------------------------
d10 <- read_csv("data/gdp_per_capita_growth.csv", show_col_types = FALSE) %>%
  mutate(country = factor(country, levels = country_order))

g10 <- ggplot(d10, aes(x = factor(year), y = real_gdp_per_capita_growth, fill = country)) +
  geom_col(position = position_dodge(width = 0.75), width = 0.68, color = "white", linewidth = 0.2) +
  geom_hline(yintercept = 0, color = "grey40", linewidth = 0.4) +
  geom_text(aes(label = sprintf("%.1f", real_gdp_per_capita_growth),
                vjust = ifelse(real_gdp_per_capita_growth >= 0, -0.4, 1.3)),
            position = position_dodge(width = 0.75), size = 2.6, fontface = "bold",
            family = "serif", show.legend = FALSE) +
  scale_fill_manual(values = country_colors) +
  scale_y_continuous(expand = expansion(mult = c(0.05, 0.08))) +
  labs(title = "Graph 10. Real GDP Per Capita Growth (2021-2023)",
       subtitle = "India records the highest per-capita growth throughout; Germany turns negative in 2023",
       x = "Year", y = "Real GDP per Capita Growth (%)", fill = NULL,
       caption = "Source: National statistical agencies, population data / Author's compilation") +
  theme_academic()
save_academic(g10, "graph10_real_gdp_per_capita_growth", width = 9, height = 6)

message("\nAll 10 graphs generated successfully in output/graphs/")
