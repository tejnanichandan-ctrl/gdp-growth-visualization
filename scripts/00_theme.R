# ============================================================
# 00_theme.R
# Shared academic ggplot2 theme + color palette for the
# Nominal vs Real GDP (2021-2023) case study graphs.
# ============================================================

library(ggplot2)

# Consistent country color palette (colorblind-friendly, print-safe)
country_colors <- c(
  "United States" = "#1B3A6B",  # deep navy
  "Germany"       = "#B23A2E",  # brick red
  "Japan"         = "#2E7D5B",  # forest green
  "India"         = "#D98E04"   # amber/ochre
)

# Academic theme: serif font (Times-like), clean gridlines, journal-style
theme_academic <- function(base_size = 12) {
  theme_minimal(base_size = base_size, base_family = "serif") +
    theme(
      plot.title = element_text(face = "bold", size = rel(1.25), hjust = 0,
                                 margin = margin(b = 6)),
      plot.subtitle = element_text(size = rel(0.95), color = "grey30",
                                    margin = margin(b = 12)),
      plot.caption = element_text(size = rel(0.7), color = "grey40",
                                   hjust = 0, margin = margin(t = 10)),
      axis.title = element_text(face = "bold", size = rel(0.95)),
      axis.text = element_text(color = "grey20", size = rel(0.9)),
      legend.title = element_text(face = "bold", size = rel(0.9)),
      legend.position = "bottom",
      legend.background = element_blank(),
      panel.grid.minor = element_blank(),
      panel.grid.major = element_line(color = "grey88", linewidth = 0.3),
      strip.text = element_text(face = "bold", size = rel(1), color = "white"),
      strip.background = element_rect(fill = "#1B3A6B", color = NA),
      plot.background = element_rect(fill = "white", color = NA),
      plot.margin = margin(16, 18, 12, 14)
    )
}

# Standard high-res save helper: PNG (for Word/viewing) + PDF (for LaTeX-quality print)
save_academic <- function(plot, filename, width = 9, height = 6, dpi = 320) {
  ggsave(file.path("output", "graphs", paste0(filename, ".png")),
         plot, width = width, height = height, dpi = dpi, bg = "white")
  ggsave(file.path("output", "graphs", paste0(filename, ".pdf")),
         plot, width = width, height = height, device = cairo_pdf)
  message("Saved: ", filename, " (.png + .pdf)")
}
