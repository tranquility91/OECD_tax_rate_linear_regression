library(sf)
library(tidyverse)
library(ggmap)
library(readxl)

#前置作業，載入稅收和世界地圖
trev=read.csv("C:/Users/USER/Documents/R/DP_LIVE_24052023040801198.csv")%>% rename(稅收 = Value,Location=Location) 

tw=read_xlsx("C:/Users/USER/Documents/R/台灣政府支出.xlsx")%>% select(Location,稅收)

world_map <- st_read("C:/Users/USER/Documents/R/TM_WORLD_BORDERS_SIMPL-0.3.shp")


#標示是否為OECD會員國
OECD_map <- world_map %>%
    mutate(is_OECD = ifelse(ISO3 %in% c("AUT", "BEL", "CAN", "CHL", "COL", "CZE", "DNK", "EST", "FIN", "FRA", "DEU", "GRC", "HUN", "ISL", "IRL", "ISR", "ITA", "JPN", "KOR", "LVA", "LTU", "LUX", "MEX", "NLD", "NZL", "NOR", "POL", "PRT", "SVK", "SVN", "ESP", "SWE", "CHE", "TUR", "GBR","CAN", "CHL", "COL", "MEX", "USA", "CRI","JPN","KOR","TWN","AUS","NZL"), TRUE, FALSE)) 

#依國家分組後算出個別平均稅收
mean_tax <- trev %>% 
    select(Location,稅收)%>% 
    rbind(tw)%>%
    group_by(Location) %>%
    summarize(mean_tax = mean(稅收))

#把平均稅收合併到地圖資料
merged_data <- left_join(OECD_map, mean_tax, by = c("ISO3" = "Location"))%>%
    filter(is_OECD)

#建立經緯度資料，待會迴圈使用
regions <- list(
    list(name = "歐洲", xlim = c(-30, 50), ylim = c(30, 70)),
    list(name = "美洲", xlim = c(-180, -30), ylim = c(-60, 90)),
    list(name = "亞洲", xlim = c(90, 150), ylim = c(10, 60)),
    list(name = "大洋洲", xlim = c(100, 180), ylim = c(-60, 10))
)

#建立空的list以存放圖片
plots <- list()

##以迴圈繪圖
#先畫底圖，再標示出不同OECD國家，並以其平均稅率上色
#在OECD國家上補上國家代碼
#把背景設為藍色
#最後設定不同的經緯度

for (region in regions) {
    plot <- ggplot() +
        geom_sf(data = OECD_map, color = "black", size = 0.2) +
        geom_sf(data = merged_data, aes(fill = mean_tax), color = "black", size = 0.2) +
        geom_text(data = merged_data, aes(label = ISO3, x = LON, y = LAT), color = "black", size = 5) + 
        scale_fill_gradient(low = "green", high = "red", na.value = "white", limits = c(10, 50), guide = guide_colorbar(barwidth = 1, barheight = 20)) +
        theme_void() +
        theme(panel.background = element_rect(fill = "lightblue")) +
        coord_sf(xlim = region$xlim, ylim = region$ylim)
    
    plots[[region$name]] <- plot
}

# 保存圖片
for (region_name in names(plots)) {
    ggsave(paste0(region_name, ".png"), plot = plots[[region_name]], width = 24, height = 18,bg = "lightblue")
}
