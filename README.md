# 🌍 OECD Tax Rate and Fiscal Surplus Analysis

This project analyzes **OECD countries' average tax burden** and **fiscal surplus frequency** over two decades, with special inclusion of **Taiwan**. It includes tax heatmaps by region, bar charts for surplus comparison, and regression analysis to explore the relationship between tax levels and surplus behavior.

---

## 📁 Files

- `國家稅率圖.R` — Generates world maps showing average tax rates by region.
- `第一版.R` — Main script for tax/surplus analysis, group comparison, and regression modeling.
- `DP_LIVE_24052023040801198.csv` — OECD tax revenue data (per year, per country).
- `DP_LIVE_24052023045936370.csv` — OECD surplus revenue data (超徵資料).
- `台灣政府支出.xlsx` — Taiwan’s tax and surplus data.
- `.gitignore` — Standard Git ignore file.

---

## 🧾 What the Project Does

### 🗺️ Regional Tax Maps (`國家稅率圖.R`)

- Loads shapefile of world borders
- Computes average tax rate per OECD country
- Highlights OECD members on a world map
- Generates separate PNG maps for:
  - Europe (`歐洲.png`)
  - Americas (`美洲.png`)
  - Asia (`亞洲.png`)
  - Oceania (`大洋洲.png`)
- Colors indicate tax rate (green = low, red = high)

### 📊 Surplus Frequency & Tax Grouping (`第一版.R`)

- Combines OECD data and Taiwan data
- Defines a threshold `htr` to split countries into:
  - **High-tax countries (Bgov)**
  - **Low-tax countries (Sgov)**
- Counts how many years each country had surplus revenue
- Outputs bar charts:
  - `bar4.jpg` – Surplus counts for high-tax countries
  - `bar3.jpg` – Surplus counts for low-tax countries

### 📈 Regression & Correlation

- Computes correlation between `稅收` (tax) and `稅收超徵` (surplus)
- Performs linear regression for Bgov and Sgov separately
- Visualizes result with:
  - Regression line
  - Mean tax rate (red line)
  - Surplus = 0 (blue line)
  - Correlation coefficient annotated
- Output plot: `lm.jpg`

- Linear models used:
```r
lm(稅收 ~ 稅收超徵, data = Bgov)
lm(稅收 ~ 稅收超徵, data = Sgov)


## 📦 Required R Packages

```r
library(tidyverse)
library(readxl)
library(sf)
library(ggmap)

