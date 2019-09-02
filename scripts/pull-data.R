# Read data from Workout Tracker google sheet and writes out data/workouts.rds

# Source: https://docs.google.com/spreadsheets/d/1MM9UbkV46tahIXGiSPDBS0vCAG3Q7ugqIwAwouqoujg/edit?usp=drive_web&ouid=101998553146455490972
# Author: Sam Robertson
# Version: 9-2-2019

# Libraries
library(tidyverse)
library(googlesheets)
library(lubridate)

# Parameters
SHEET_NAME <- "Workout Tracker (Responses)"
colnames <- c(
  time = "Timestamp",
  track = "Track number/name",
  warmup = "Weights [warmup]",
  squats = "Weights [squats]",
  chest = "Weights [chest]",
  back = "Weights [back]",
  triceps = "Weights [triceps]",
  biceps = "Weights [biceps]",
  lunges = "Weights [lunges]",
  shoulders = "Weights [shoulders]",
  abs = "Weights [abs]",
  sets_reps_weight = "Sets x Reps @ weight",
  cardio_type = "Type", # run / swim / bike
  cardio_style = "Style", # steady state or interval
  stretch = "Stretch?"
)
# Output file
file_out <- here::here("data/workouts.rds")

#===============================================================================

gs_auth(new_user = TRUE) # use personal account

sheet_key <- 
  gs_ls() %>% 
  filter(sheet_title == SHEET_NAME) %>% 
  pull(sheet_key)

gs_key(sheet_key) %>%
  gs_read(
    col_types = cols(
      Timestamp = col_character(),
      `Workout type` = col_character(),
      Duration = col_double(),
      Program = col_character(),
      `Track number/name` = col_character(),
      `Weights [warmup]` = col_number(),
      `Weights [squats]` = col_number(),
      `Weights [chest]` = col_number(),
      `Weights [back]` = col_number(),
      `Weights [triceps]` = col_number(),
      `Weights [biceps]` = col_number(),
      `Weights [lunges]` = col_number(),
      `Weights [shoulders]` = col_number(),
      `Weights [abs]` = col_number(),
      `Sets x Reps @ weight` = col_character(),
      Type = col_character(),
      Style = col_character(),
      Distance = col_double(),
      Description = col_character(),
      `Stretch?` = col_character(),
      `Stretch duration` = col_number()
    ),
    na = c("NA", "", "N/A")
  ) %>% 
  rename(!!colnames) %>%
  janitor::clean_names() %>% 
  mutate(
    time = mdy_hms(time),
    date = as_date(time),
    stretch = (stretch == "Yes")
  ) %>% 
  write_rds(file_out)