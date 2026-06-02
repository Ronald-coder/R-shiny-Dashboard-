library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(readr)
library(forcats)

#-----------------------------
# Helper: Safe CSV loader
#-----------------------------
load_csv <- function(file) {
  if (!file.exists(file)) {
    stop(paste("Missing file:", file))
  }
  read.csv(file)
}

#-----------------------------
# UI COMPONENTS
#-----------------------------

header <- dashboardHeader(title = "KMPG TASK 3")

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Dashboard", tabName = "dashboard", icon = icon("dashboard")),
    menuItem("Visit-us", icon = icon("send", lib = "glyphicon"), href = ""),
    
    selectInput(
      "month", "Month:",
      choices = list(
        "All Year" = 99, "January" = 1, "February" = 2, "March" = 3,
        "April" = 4, "May" = 5, "June" = 6, "July" = 7,
        "August" = 8, "September" = 9, "October" = 10,
        "November" = 11, "December" = 12
      ),
      selected = 99,
      selectize = FALSE
    )
  )
)

#-----------------------------
# UI ROWS
#-----------------------------

frow1 <- fluidRow(
  valueBoxOutput("numberofcustomers"),
  valueBoxOutput("approvalBox")
)

frow2 <- fluidRow(
  box(
    title = "Total profit based on industry", status = "primary",
    solidHeader = TRUE, collapsible = TRUE,
    plotOutput("profit_based_on_industry", height = "300px")
  ),
  box(
    title = "Total profit based on wealth segment", status = "primary",
    solidHeader = TRUE, collapsible = TRUE,
    plotOutput("profit_based_on_wealth_segment", height = "300px")
  )
)

frow3 <- fluidRow(
  box(
    title = "Total profit based on states", status = "primary",
    solidHeader = TRUE, collapsible = TRUE,
    plotOutput("profit_based_on_states", height = "300px")
  ),
  box(
    title = "Number of bicycles purchased per month", status = "primary",
    solidHeader = TRUE, collapsible = TRUE,
    plotOutput("profit_based_on_gender", height = "300px")
  )
)

frow4 <- fluidRow(
  box(
    title = "Total profit based on age groups", status = "primary",
    solidHeader = TRUE, collapsible = TRUE,
    plotOutput("profit_based_on_agegroups", height = "300px")
  ),
  box(
    title = "Most purchased brands among customers", status = "primary",
    solidHeader = TRUE, collapsible = TRUE,
    plotOutput("most_purchased_brands", height = "300px")
  )
)

frow5 <- fluidRow(
  box(
    title = "Most purchased products among customers", status = "primary",
    solidHeader = TRUE, collapsible = TRUE,
    plotOutput("most_purchased_products", height = "300px")
  )
)

body <- dashboardBody(frow1, frow2, frow3, frow4, frow5)

ui <- dashboardPage(
  title = "KMPG TASK 3",
  header, sidebar, body, skin = "blue"
)

#-----------------------------
# SERVER
#-----------------------------

server <- function(input, output) {
  
  # Load all CSVs safely
  datum                     <- load_csv("merged_data2.csv")
  prac_data                 <- load_csv("prac_data.csv")
  job_industry_category.profit <- load_csv("job_industry_category.profit.csv")
  wealth_segment.profit     <- load_csv("wealth_segment.profit.csv")
  state.profit              <- load_csv("state.profit.csv")
  d                         <- load_csv("d.csv")
  monthly_data_2            <- load_csv("monthly_data_2.csv")
  age_group.profit          <- load_csv("age_group.profit.csv")
  brand.profit              <- load_csv("brand.profit.csv")
  
  #-----------------------------
  # VALUE BOXES
  #-----------------------------
  
  output$approvalBox <- renderValueBox({
    total.revenue <- sum(datum$profit, na.rm = TRUE)
    valueBox(
      formatC(total.revenue, format = "d", big.mark = ","),
      "Total Profit",
      icon = icon("usd", lib = "glyphicon"),
      color = "blue"
    )
  })
  
  output$numberofcustomers <- renderValueBox({
    number_of_customers <- length(unique(datum$customer_id))
    valueBox(
      formatC(number_of_customers, format = "d", big.mark = ","),
      "Total number of customers",
      icon = icon("users"),
      color = "blue"
    )
  })
  
  #-----------------------------
  # PLOTS
  #-----------------------------
  
  output$profit_based_on_industry <- renderPlot({
    ggplot(job_industry_category.profit,
           aes(Total_profit, job_industry_category, fill = Total_profit)) +
      geom_col() +
      labs(title = "Total profit based on industry",
           x = "Total profit", y = "Job industry category") +
      theme_minimal()
  })
  
  output$profit_based_on_wealth_segment <- renderPlot({
    ggplot(wealth_segment.profit,
           aes(x = "", y = Total_profit, fill = wealth_segment)) +
      geom_bar(stat = "identity") +
      coord_polar("y") +
      labs(title = "Total profit based on wealth segment") +
      theme_void()
  })
  
  output$profit_based_on_states <- renderPlot({
    ggplot(state.profit,
           aes(x = "", y = Total_profit, fill = state)) +
      geom_bar(stat = "identity", width = 1) +
      coord_polar("y") +
      labs(title = "Total profit based on states") +
      theme_void()
  })
  
  output$profit_based_on_gender <- renderPlot({
    ggplot(monthly_data_2) +
      geom_line(aes(month_of_transaction, male_avg), color = "blue") +
      geom_line(aes(month_of_transaction, female_avg), color = "red") +
      labs(title = "Number of bicycles purchased per month",
           x = "Month", y = "Average purchases") +
      theme_minimal()
  })
  
  output$profit_based_on_agegroups <- renderPlot({
    ggplot(age_group.profit,
           aes(age_group, Total_profit, fill = age_group)) +
      geom_col() +
      labs(title = "Total profit based on age group",
           x = "Age group", y = "Total profit") +
      theme_minimal()
  })
  
  output$most_purchased_brands <- renderPlot({
    ggplot(datum, aes(y = fct_infreq(brand), fill = brand)) +
      geom_bar() +
      labs(title = "Most purchased brands",
           x = "Count", y = "Brand") +
      theme_minimal()
  })
  
  output$most_purchased_products <- renderPlot({
    ggplot(datum, aes(x = fct_infreq(product_line), fill = product_line)) +
      geom_bar() +
      labs(title = "Most purchased products",
           x = "Product line", y = "Count") +
      theme_minimal()
  })
}

shinyApp(ui = ui, server = server)