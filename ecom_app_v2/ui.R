#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readxl)

# Define the feature names (replace these with your actual feature names)
# feature_names <- c("Date",	`Open Interest`,	`Producer Longs`,	`Producer Shorts`,
#                    `Swap Dealer Longs`,	`Swap Dealer Shorts`,	`Swap Dealer Spreads`,
#                    `Money Manager Longs`,	`Money Manager Shorts`, `Money Manager Spreads`,
#                    `Other Reportable Longs`,	`Other Reportable Shorts`,	`Other Reportable Spreads`,
#                    `Total Reportable Longs`,	`Total Reportable Shorts`,
#                    `Non Reportable Longs`,	`Non Reportable Shorts`)
features_names <- data.frame(
                    features_input = c("Open Interest T", "Producer Longs T", "Producer Shorts T",
                   "Swap Dealer Longs T", "Swap Dealer Shorts T", "Swap Dealer Spreads T",
                   "Money Manager Longs T", "Money Manager Shorts T", "Money Manager Spreads T",
                   "Other Reportable Longs T", "Other Reportable Shorts T", "Other Reportable Spreads T",
                   "Total Reportable Longs T", "Total Reportable Shorts T", "Non Reportable Longs T", "Non Reportable Shorts T",
                   "Open Interest T-1", "Producer Longs T-1", "Producer Shorts T-1",
                   "Swap Dealer Longs T-1", "Swap Dealer Shorts T-1", "Swap Dealer Spreads T-1",
                   "Money Manager Longs T-1", "Money Manager Shorts T-1", "Money Manager Spreads T-1",
                   "Other Reportable Longs T-1", "Other Reportable Shorts T-1", "Other Reportable Spreads T-1",
                   "Total Reportable Longs T-1", "Total Reportable Shorts T-1", "Non Reportable Longs T-1", "Non Reportable Shorts T-1"),

                   features_mod = c("Open_Interest.t", "Producer_Longs.t", "Producer_Shorts.t",
                  "Swap_Dealer_Longs.t", "Swap_Dealer_Shorts.t", "Swap_Dealer_Spreads.t",
                  "Mon.t_1_Manager_Longs.t", "Mon.t_1_Manager_Shorts.t", "Mon.t_1_Manager_Spreads.t",
                  "Other_Reportable_Longs.t", "Other_Reportable_Shorts.t", "Other Reportable Spreads.t",
                  "Total_Reportable_Longs.t", "Total_Reportable_Shorts.t", "Non_Reportable_Longs.t", "Non_Reportable_Shorts.t",
                  "Open_Interest.t_1", "Producer_Longs.t_1", "Producer_Shorts.t_1",
                  "Swap_Dealer_Longs.t_1", "Swap_Dealer_Shorts.t_1", "Swap_Dealer_Spreads.t_1",
                  "Mon.t_1_Manager_Longs.t_1", "Mon.t_1_Manager_Shorts.t_1", "Mon.t_1_Manager_Spreads.t_1",
                  "Other_Reportable_Longs.t_1", "Other_Reportable_Shorts.t_1", "Other Reportable Spreads.t_1",
                  "Total_Reportable_Longs.t_1", "Total_Reportable_Shorts.t_1", "Non_Reportable_Longs.t_1", "Non_Reportable_Shorts.t_1")
                  )


# Define UI
fluidPage(
  titlePanel("COT Line Prediction Tool"),
  sidebarLayout(
    sidebarPanel(
      selectInput("Commodity", "Select Commodity", choices = c("Coffee", "Cocoa", "Cotton", "Sugar")),
      
      fileInput("dataFile", "Upload Data File", accept = c(".csv", ".xlsx", ".xls")),
      
      actionButton("submit", "Submit")
    ),
    mainPanel(
      h3("Results"),
      tableOutput("resultsTable")
    )
  )
)