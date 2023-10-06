---
editor_options: 
  markdown: 
    wrap: 72
---

# Google-Data-Analytics-Project-

Google Data Analytics Professional Certificate Capstone Project 1

## Case Study

### How Does a Bike-Share Navigate Speedy Success?

#### Introduction

Welcome to the Cyclistic bike-share analysis case study! In this case
study, you will perform many real-world tasks of a junior data analyst.
You will work for a fictional company, Cyclistic, and meet different
characters and team members. In order to answer the key business
questions, you will follow the steps of the data analysis process:
**ask, prepare, process, analyze, share, and act.**

#### Scenario

You are a junior data analyst working in the marketing analyst team at
Cyclistic, a bike-share company in Chicago. The director of marketing
believes the company's future success depends on maximizing the number
of annual memberships. Therefore, your team wants to understand how
casual riders and annual members use Cyclistic bikes differently. From
these insights, your team will design a new marketing strategy to
convert casual riders into annual members. But first, Cyclistic
executives must approve your recommendations, so they must be backed up
with compelling data insights and professional data visualizations.

## Ask

#### Goal

Design Marketing strategies aimed at converting casual riders into
annual members

#### Business Task

Identify how annual members and casual riders use Cyclistic bikes
differently.

#### Key Stakeholders

Lily Moreno : The director of marketing and your manager.

Cyclistic marketing analytics team: team of data analysts who are
responsible for collecting, analyzing, and reporting data that helps
guide Cyclistic marketing strategy.

Cyclistic executive team

#### Data Sources

Data collected from the first quater of 2020 Q1. The data has been made
available by Motivate International Inc. under this
[license](https://divvybikes.com/data-license-agreement).

## Prepare

Due to the large amount of data, presented here are some snapshots of
the process.

Sorted the data to according to the started day and time.

Adjusted the column width to fit the content

![sorted](https://github.com/am-eric/Google-Data-Analytics-Project-/assets/64156869/9e98fd80-9f13-4e1a-93c2-ed93f6f17832)
.

## Process

Created a column called "ride_length"

Created a column called "day_of_week"

Calculated the day of the week that each ride started using the
"WEEKDAY" command (for example, =WEEKDAY(C2,1)) in each file. Format as
General or as a number with no decimals, noting that 1 = Sunday and 7 =
Saturday

![202301
SORTED](https://github.com/am-eric/Google-Data-Analytics-Project-/assets/64156869/ea2250e2-d4d8-48ab-a09b-4298a58ac0a8)

## Analyze

### Aggregation using R

Data aggregation is done in the R script. Here are the steps taken.

-   Collect data created dataframes for the 7 months data

inspected the data for aggregation

-   Combine data to one table/ dataframe

-   Add columns that list the date, month, day and year

-   Convert started_at and ended_at to date-time objects to get the
    ride_length in seconds

-   Aggregated the data to find the key relationships and patterns.

-   i found that, members have more rides compare to casual members.

![no_of_rides vs weekday for user
type](Rplot%20no_of_rides%20vs%20weekday%20for%20user%20type.png)

-   However, Casual members spend more time on the bike compared to
    members

![Average_duration against weekday by
usertype](Rplot Average_duration  against weekday by usertype.png)
