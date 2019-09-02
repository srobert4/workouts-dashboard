# Search path
VPATH = data eda reports scripts

# Processed data files
data = workouts.rds

# EDA studies
eda = workouts.md

# Reports
reports = dashboard.html

# All targets
all : $(data) $(eda) $(reports)

# EDA study and report dependencies
workouts.md : workouts.rds
dashboard.html : workouts.rds

# Pattern rules
%.rds : %.R
	Rscript $<
%.md : %.Rmd
	Rscript -e 'rmarkdown::render(input = "$<", output_options = list(html_preview = FALSE))'
%.html : %.Rmd
	Rscript -e 'rmarkdown::render(input = "$<", output_options = list(html_preview = FALSE))'
