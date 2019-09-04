#!/bin/bash

# Remove workouts.rds
rm data/workouts.rds
# Make
Make
# Copy reports/dashboard.html > docs/index.html
cp reports/dashboard.html docs/index.html

# Copy reports/dashboard_files > docs/dashboard_files
cp -r reports/dashboard_files docs/dashboard_files

# Push updated files to GitHub
git add .
git commit -m "update data"
git push
