# OECD Tax Rate and Fiscal Surplus Analysis  
This project analyzes average tax burdens and fiscal surplus frequency across OECD countries over the past two decades, with additional inclusion of Taiwan. It includes world map visualizations, surplus count comparisons, and correlation analysis between tax and surplus values.

## 📁 Files  
國家稅率圖.R — Script to generate regional tax heatmaps (Europe, Americas, Asia, Oceania)  
第一版.R — Main script for calculating surplus frequency, performing regression, and generating plots  
DP_LIVE_24052023040801198.csv — OECD tax revenue data (Value per country-year)  
DP_LIVE_24052023045936370.csv — OECD surplus revenue data  
台灣政府支出.xlsx — Taiwan’s tax and surplus data  
.gitignore — Standard Git ignore settings  

## 📊 What It Does  
The scripts:  
- Load OECD and Taiwan tax data  
- Classify countries into high-tax and low-tax groups based on a computed threshold  
- Count the number of surplus years per country in each group  
- Create regional maps highlighting average tax rate for OECD countries  
- Visualize surplus count using bar charts (`bar4.jpg` for high-tax, `bar3.jpg` for low-tax)  
- Perform and visualize linear regression between tax revenue and surplus (`lm.jpg`)  

## 🧾 Dependencies  
You’ll need the following R packages:  
```r
library(tidyverse)  
library(readxl)  
library(sf)  
library(ggmap)  
