library(tidyverse)
library(readxl)

#載入OECD稅率、稅收超徵、台灣的稅率和稅收超徵
tw=read_xlsx("C:/Users/USER/Documents/R/台灣政府支出.xlsx")
trev=read.csv("C:/Users/USER/Documents/R/DP_LIVE_24052023040801198.csv")%>% rename(稅收 = Value,Location=嚜磧ocation)
deflict=read.csv("C:/Users/USER/Documents/R/DP_LIVE_24052023045936370.csv")%>% rename(稅收超徵 = Value,Location=嚜燉OCATION)

#定義高稅率
htr=(mean(tw$稅收)*15+866*mean(trev$稅收))/881

#在兩份資料中創建共同變數以合併
trev <- trev %>% mutate(Year = str_c(Location, TIME))
deflict <- deflict %>% mutate(Year = str_c(Location, TIME))

#修改台灣資料以合併，包含計算平均稅率
tw <- tw %>% 
    mutate(Year = str_c(Location, Time)) %>% 
    mutate(分組 = ifelse(mean(稅收) >= htr, paste("大於等於", htr), paste("小於", htr)))%>%
    rename(Location.x=Location)%>%
    select(Location.x,Year,稅收,稅收超徵)

#合併稅率和稅收超徵、並加入台灣資料
merge=inner_join(trev,deflict,by="Year") %>% select(Location.x,Year,稅收,稅收超徵) %>% rbind(tw)

#以國家分組，並標記為平均稅率的大小
summary <- merge %>%
    group_by(Location.x) %>%
    mutate(分組 = ifelse(mean(稅收) >= htr, paste("大於等於", htr), paste("小於", htr)))

#以平均稅率高低建立兩個組別
Bgov=filter(summary,分組== paste("大於等於", htr))
Sgov=filter(summary,分組== paste("小於", htr))

#分別計算大小政府各國20年的稅收超徵次數
Btoc <- Bgov %>%
    summarize(count = sum(稅收超徵 > 0))
Stoc <- Sgov %>%
    summarize(count = sum(稅收超徵 > 0))

#繪製稅收超徵次數比較的長條圖
#X軸為國家，Y軸為稅收超徵次數
#並在圖上標示稅收超徵次數
ggplot(Btoc, aes(x = reorder(Location.x, count), y = count)) +
    geom_bar(stat = "identity", fill = "#B9BBDD") +
    geom_text(aes(label = count), vjust = -0.5, color = "black", size = 7) +
    labs(title = "高稅率國家之稅收超徵次數", x = "", y = "超徵次數") +
    theme(axis.text.x = element_text(size = 25, face = "bold"),
          axis.text.y = element_text(size = 25, face = "bold"),
          axis.title.y = element_text(size = 25, face = "bold"),
          plot.title = element_text(size = 25, face = "bold")) 

ggsave("bar4.jpg", width = 24, height =18)

ggplot(Stoc, aes(x = reorder(Location.x, count), y = count)) +
    geom_bar(stat = "identity", fill = "#B9CDA3") +
    geom_text(aes(label = count), vjust = -0.5, color = "black", size = 7) +
    labs(title = "低稅率國家之稅收超徵次數", x = "", y = "超徵次數") +
    theme(axis.text.x = element_text(size = 25, face = "bold"),
          axis.text.y = element_text(size = 25, face = "bold"),
          axis.title.y = element_text(size = 25, face = "bold"),
          plot.title = element_text(size = 25, face = "bold")) 

ggsave("bar3.jpg", width = 24, height =18)


#計算回歸係數
BgovS=ungroup(Bgov) %>% select(Year,稅收,稅收超徵)
SgovS=ungroup(Sgov) %>% select(Year,稅收,稅收超徵)

Bcorrelation <- BgovS %>% 
    summarize(correlation = round(cor(稅收超徵, 稅收), 2))

Scorrelation <- SgovS %>% 
    summarize(correlation = round(cor(稅收超徵, 稅收), 2))

#畫出迴歸直線，並在平均稅率的位置以紅線標示

ggplot(BgovS, aes(x = 稅收超徵, y = 稅收)) +
    geom_point(size = 2, color = "black") +  
    geom_hline(yintercept = htr, color = "red", size = 1.5) +  
    geom_vline(xintercept = 0, color = "blue", size = 1.5) +  
    geom_smooth(method = "lm", se = FALSE, size = 1.2) +  
    labs(title = "Bgov") +
    geom_text(
        x = min(BgovS$稅收超徵) + 0.05 * (max(BgovS$稅收超徵) - min(BgovS$稅收超徵)),
        y = max(BgovS$稅收) - 0.05 * (max(BgovS$稅收) - min(BgovS$稅收)),
        label = paste("r:", Bcorrelation),
        hjust = 0,
        vjust = 1,
        color = "black",
        fontface = "bold",
        size = 14  
    ) +
    theme(axis.title.x = element_text(size = 30),
          axis.title.y = element_text(size = 30),
          axis.text.x = element_text(size = 30),
          axis.text.y = element_text(size = 30),
          plot.title = element_text(size = 30))

ggsave("lm.jpg", width = 30, height =18)


ggplot(SgovS, aes(x = 稅收超徵, y = 稅收)) +
    geom_point(size = 2, color = "black") +  
    geom_hline(yintercept = htr, color = "red", size = 1.5) +  
    geom_vline(xintercept = 0, color = "blue", size = 1.5) +  
    geom_smooth(method = "lm", se = FALSE, size = 1.2) +  
    labs(title = "Sgov") +
    geom_text(
        x = min(SgovS$稅收超徵) + 0.05 * (max(SgovS$稅收超徵) - min(SgovS$稅收超徵)),
        y = max(SgovS$稅收) - 0.05 * (max(SgovS$稅收) - min(SgovS$稅收)),
        label = paste("r:", Scorrelation),
        hjust = 0,
        vjust = 1,
        color = "black",
        fontface = "bold",
        size = 14  
    ) +
    theme(axis.title.x = element_text(size = 30),
          axis.title.y = element_text(size = 30),
          axis.text.x = element_text(size = 30),
          axis.text.y = element_text(size = 30),
          plot.title = element_text(size = 30))


#進行統計檢定

model <- lm(稅收 ~ 稅收超徵, data = Bgov)
summary(model)

model.2 <- lm(稅收 ~ 稅收超徵, data = Sgov)
summary(model.2)



