Workouts - EDA
================

``` r
library(tidyverse)
```

    ## ── Attaching packages ────────────────────────────────── tidyverse 1.2.1 ──

    ## ✔ ggplot2 3.1.0       ✔ purrr   0.3.2  
    ## ✔ tibble  2.1.1       ✔ dplyr   0.8.0.1
    ## ✔ tidyr   0.8.3       ✔ stringr 1.4.0  
    ## ✔ readr   1.3.1       ✔ forcats 0.4.0

    ## ── Conflicts ───────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ dplyr::filter() masks stats::filter()
    ## ✖ dplyr::lag()    masks stats::lag()

``` r
library(googlesheets)
library(lubridate)
```

    ## 
    ## Attaching package: 'lubridate'

    ## The following object is masked from 'package:base':
    ## 
    ##     date

``` r
file_data <- here::here("data/workouts.rds")

#==============

df <- read_rds(file_data)
```

# Time series of duration of workout over the past two weeks (could have other periods of time)

``` r
df %>%
  filter(date > today() - days(13)) %>% 
  group_by(date) %>%
  summarize(duration = sum(duration, na.rm = TRUE)) %>%
  ggplot(aes(date, duration)) +
  geom_col() +
  geom_vline(xintercept = today()) +
  scale_x_date(
    date_breaks = "1 days", 
    date_labels = "%b %d",
    limits = c(today() - days(13), today())
  ) +
  scale_y_continuous(
    breaks = seq(0, 90, by = 15), 
    labels = function(x) str_c(x, " min")
  ) +
  theme_minimal() +
  theme(axis.text.x = element_text(hjust = 1, angle = 45)) +
  labs(x = NULL, y = "Total Duration of Exercise")
```

![](workouts_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

# What type of exercise have I been doing? (Also allow to filter to recent)

``` r
df %>%
  mutate(
    type = case_when(
      workout_type == "Les Mills On Demand" ~ program,
      workout_type == "Run/Walk/Bike/Swim" ~ as.character(glue::glue("{cardio_type} ({cardio_style})")),
      TRUE ~ program
    )
  ) %>%
  group_by(type) %>%
  summarize(duration = sum(duration)) %>%
  ggplot(aes(reorder(type, duration), duration)) +
  geom_col() +
  coord_flip() +
  labs(
    x = NULL,
    y = "Total Minutes"
  )
```

![](workouts_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->

# Month view

``` r
df %>% 
  group_by(month = month(date), day = mday(date)) %>% 
  summarize(total_minutes = sum(duration, na.rm = TRUE)) %>% 
  ungroup() %>% 
  ggplot(aes(xmin = day, ymin = month, xmax = day + 1, ymax = month + 1,fill = total_minutes)) +
  geom_rect()
```

![](workouts_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->
