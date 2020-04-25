library(dplyr)
library(tidyr)
library(ggplot2)
library(gganimate)

# Importing data
data_confirmed <- read.csv("D:/_Kuliah/3_Junior/KOM332 Daming/Project/data/time_series_covid19_confirmed_global.csv")
data_deaths <- read.csv("D:/_Kuliah/3_Junior/KOM332 Daming/Project/data/time_series_covid19_deaths_global.csv")
data_recovered <- read.csv("D:/_Kuliah/3_Junior/KOM332 Daming/Project/data/time_series_covid19_recovered_global.csv")

# Remove Province
colnames(data_confirmed)
data_confirmed <- data_confirmed[, -1]
data_deaths <- data_deaths[, -1]
data_recovered <- data_recovered[, -1]
colnames(data_confirmed)
ncol(data_confirmed)

# Pivoting the table
data_confirmed_pivot <- data_confirmed %>%
  pivot_longer(4:85, names_to='date', values_to='confirmed')
data_deaths_pivot <- data_deaths %>%
  pivot_longer(4:85, names_to='date', values_to='deaths')
data_recovered_pivot <- data_recovered %>%
  pivot_longer(4:85, names_to='date', values_to='recovered')

head(data_confirmed_pivot)
dim(data_confirmed_pivot)

head(data_deaths_pivot)
dim(data_deaths_pivot)

head(data_recovered_pivot)
dim(data_deaths_pivot)

unique(data_confirmed_pivot$Country.Region) 



table_creator <- function(country){
  table_confirmed <- data_confirmed_pivot[data_confirmed_pivot$Country.Region == country, ]
  table_deaths <- data_deaths_pivot[data_deaths_pivot$Country.Region == country, 5]
  table_recovered <- data_recovered_pivot[data_recovered_pivot$Country.Region == country, 5]
 
  # date = as.Date("2020-01-22") + 0:81 
  day = 1:82
  
  table_fix <- cbind(day, table_confirmed, table_deaths, table_recovered)
  table_fix <- table_fix[, -5]
  head(table_fix)
  return(as_tibble(table_fix))
}

day = 1:82
day

# Mengambil negara terkait, akan diambil Indonesia, Korsel, Singapura, Italia, Cina, dan AS  
indonesia <- table_creator("Indonesia")
italy <- table_creator("Italy")
singapore <- table_creator("Singapore")
s_korea <- table_creator("Korea, South")
taiwan <- table_creator("Taiwan*")

dim(indonesia)

combine <- rbind(indonesia, singapore, s_korea)
combine <- combine %>%
  arrange(day)
combine <- as_tibble(combine)
combine

# Eksplorasi Data
ggplot(combine, aes(x=Country.Region, y=confirmed, color = Country.Region)) +
  geom_line() +
  labs(title = 'Date : {frame_time}', x='Date', y='Confirmed') +
  transition_time(day) +
  ease_aes('linear')


ggplot(italy, aes(x=day, y=confirmed)) +
  geom_line() +
  ggtitle('Italy') +
  transition_time(day) +
  ease_aes('linear')

ggplot(s_korea, aes(x=day, y=confirmed)) +
  geom_line(color='orange', size = 1.5) +
  ggtitle('South Korea')

ggplot(taiwan, aes(x=day, y=confirmed)) +
  geom_line(color='dark blue', size = 1.5) +
  ggtitle('Taiwan')


