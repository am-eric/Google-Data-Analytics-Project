# The purpose of this script is to consolidate downloaded Divvy data into a single dataframe and then conduct simple analysis to help answer the key question:
# “In what ways do members and casual riders use Divvy bikes differently?”

# install required packages

install.packages("tidyverse")
library(tidyverse)  #helps wrangle data

install.packages("libridate")
library(lubridate)  #helps wrangle date attributes

install.packages("ggplot")
library(ggplot2)

library(dplyr)

# collect data
January <- read_csv("202301-divvy-tripdata.csv")
February <- read_csv("202302-divvy-tripdata.csv")
March <- read_csv("202303-divvy-tripdata.csv")
April <- read_csv("202304-divvy-tripdata.csv")
May <- read_csv("202305-divvy-tripdata.csv")
June <- read_csv("202306-divvy-tripdata.csv")
July <- read_csv("202307-divvy-tripdata.csv")


# wrangle data and combine into a single file

colnames(January)
colnames(February)
colnames(March)
colnames(April)
colnames(May)
colnames(June)
colnames(July)
# the column names are in the same order 

# Inspect the dataframes and look for inconguencies
str(January)
str(February)
str(March)
str(April)
str(May)
str(June)
str(July)


# Join the datasets to create one data frame 

half_2023trips <- bind_rows(January, February, March, April, May, June, July)
View(half_2023trips)

# Inspect the new table that has been created
colnames(half_2023trips) #List of column names
 
nrow(half_2023trips)  # how many rows are there in the dataframe
 # 3158109
dim (half_2023trips) # dimensions of the data frame
 # [1] 3158109      15
head(half_2023trips)
summary (half_2023trips)

# Add columns that list the date, month, day, and year of each ride
half_2023trips$date <- as.Date(half_2023trips$started_at, "%d/%m/%Y")     #The default format is yyyy-mm-dd
View(half_2023trips)

half_2023trips$month <- format(as.Date(half_2023trips$date), "%m")
half_2023trips$day <- format(as.Date(half_2023trips$date), "%d")
half_2023trips$year <- format(as.Date(half_2023trips$date), "%Y")

# add ride_length column in seconds
half_2023trips$ride_length <- difftime(half_2023trips$ended_at,half_2023trips$started_at)

# Inspect the structure of the columns
str(half_2023trips)


# Convert started_at and ended_at to date-time objects
half_2023trips <- half_2023trips %>%
  mutate(
    started_at = as.POSIXct(started_at, format = "%d/%m/%Y %H:%M"),
    ended_at = as.POSIXct(ended_at, format = "%d/%m/%Y %H:%M")
  )


# Calculate ride_length as the difference in seconds
half_2023trips <- half_2023trips %>%
  mutate(
    ride_length = as.numeric(difftime(ended_at, started_at, units = "secs"))
  )

str(half_2023trips)

# remove data where ride_length is (-ve)
half_2023trips_v2 = half_2023trips[!(half_2023trips$ride_length<0),]

# Descriptive analysis on ride_length (all figures in seconds)
mean(half_2023trips_v2$ride_length)
# 1108.719
median(half_2023trips_v2$ride_length) #midpoint number in the ascending array of ride lengths
# 600
max(half_2023trips_v2$ride_length) #longest ride
# 3087720
min(half_2023trips_v2$ride_length) #shortest ride
# 0 

# get the summary of ride_length
summary(half_2023trips_v2$ride_length)

#  Min. 1st Qu.  Median    Mean 3rd Qu.    Max. 
#     0     300     600    1109    1020 3087720 

# Compare members and casual users
aggregate(half_2023trips_v2$ride_length ~ half_2023trips_v2$member_casual, FUN = mean)
aggregate(half_2023trips_v2$ride_length ~ half_2023trips_v2$member_casual, FUN = median)
aggregate(half_2023trips_v2$ride_length ~ half_2023trips_v2$member_casual, FUN = max)
aggregate(half_2023trips_v2$ride_length ~ half_2023trips_v2$member_casual, FUN = min)

# See the average ride time by each day for members vs casual users
aggregate(half_2023trips_v2$ride_length ~ half_2023trips_v2$member_casual + half_2023trips_v2$day_of_week, FUN = mean)

# format days of the week 
half_2023trips_v2 <- half_2023trips_v2 %>% 
  mutate(
    day_of_week = format(as.Date(half_2023trips_v2$date), "%A")
  )

# Notice that the days of the week are out of order. Let's fix that.
half_2023trips_v2$day_of_week <- ordered(half_2023trips_v2$day_of_week, levels=c("Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"))
View(half_2023trips_v2)

# Now, let's run the average ride time by each day for members vs casual users
aggregate(half_2023trips_v2$ride_length ~ half_2023trips_v2$member_casual + half_2023trips_v2$day_of_week, FUN = mean)


# analyze ridership data by type and weekday
half_2023trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>%  #creates weekday field using wday()
  group_by(member_casual, weekday) %>%  #groups by usertype and weekday
  summarise(number_of_rides = n()							#calculates the number of rides and average duration 
            ,average_duration = mean(ride_length)) %>% 		# calculates the average duration
  arrange(member_casual, weekday)	
#  member_casual weekday number_of_rides average_duration
# <chr>         <ord>             <int>            <dbl>
#  1 casual        Sun              185691            1971.
# 2 casual        Mon              142068            1707.
# 3 casual        Tue              138376            1587.
# 4 casual        Wed              133369            1525.
# 5 casual        Thu              152315            1505.
# 6 casual        Fri              174198            1647.
# 7 casual        Sat              233254            2000.
# 8 member        Sun              224121             830.
# 9 member        Mon              281963             714.
# 10 member        Tue              310252             716.
# 11 member        Wed              311278             699.
# 12 member        Thu              320326             711.
# 13 member        Fri              290696             735.
# 14 member        Sat              260184             839.

# Let's visualize the number of rides by rider type
half_2023trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = number_of_rides, fill = member_casual)) +
  geom_col(position = "dodge")


# Let's create a visualization for average duration
half_2023trips_v2 %>% 
  mutate(weekday = wday(started_at, label = TRUE)) %>% 
  group_by(member_casual, weekday) %>% 
  summarise(number_of_rides = n()
            ,average_duration = mean(ride_length)) %>% 
  arrange(member_casual, weekday)  %>% 
  ggplot(aes(x = weekday, y = average_duration, fill = member_casual)) +
  geom_col(position = "dodge")


# EXPORT SUMMARY FILE FOR FURTHER ANALYSIS
counts <- aggregate(half_2023trips_v2$ride_length ~ half_2023trips_v2$member_casual + half_2023trips_v2$day_of_week, FUN = mean)

write.csv(counts, file = 'C:\\Users\\Eric\\R\\Cyclistic GDPC Capstone\\Google-Data-Analytics-Project\\avg_ride_length.csv')

view(counts)

write.csv(half_2023trips_v2, file = 'C:\\Users\\Eric\\R\\Cyclistic GDPC Capstone\\Google-Data-Analytics-Project\\2023_ride_data.csv')
