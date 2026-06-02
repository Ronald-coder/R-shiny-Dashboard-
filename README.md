
This project is an interactive R Shiny dashboard built to analyze customer behavior, profitability, and purchasing patterns using the KPMG dataset. The dashboard provides a clear visual summary of key business insights through dynamic charts, value boxes, and categorized visual reports.

Features:
Interactive dashboard built with shinydashboard
Value boxes summarizing:
Total profit
Total number of customers
Visual analytics, including:
Profit by industry
Profit by wealth segment
Profit by state
Monthly bicycle purchases by gender
Profit by age group
Most purchased brands
Most purchased products
Clean, consistent UI layout using modular fluid rows
Improved code structure with:
A safe CSV loader
Reduced duplication
Cleaner ggplot themes
More readable server logic

Project Structure
Code
KPMG-Dashboard/
│── app.R
│── merged_data2.csv
│── prac_data.csv
│── job_industry_category.profit.csv
│── wealth_segment.profit.csv
│── state.profit.csv
│── d.csv
│── monthly_data_2.csv
│── age_group.profit.csv
│── brand.profit.csv
│── README.md
🛠️ Technologies Used
R Shiny — interactive web application framework

shinydashboard — dashboard layout and UI components

ggplot2 — data visualization

dplyr — data manipulation

readr — fast CSV reading

forcats — factor reordering for bar charts
