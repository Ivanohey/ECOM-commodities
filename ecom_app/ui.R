#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define the feature names (replace these with your actual feature names)
feature_names <- c("Feature1", "Feature2", "Feature3", ..., "Feature17")



# Define UI
fluidPage(
  titlePanel("COT Line Prediction Tool"),
  sidebarLayout(
    sidebarPanel(
      selectInput("Commodity", "Select Commodity", 
                  choices = c("Coffee", "Cocoa", "Cotton", "Sugar")),
      # Input fields for the latest COT line data
      h4("Latest COT Line Data"),
      lapply(feature_names, function(name) {
        numericInput(paste0(name, " T"), name, value = 0)
      }),
      
      # Input fields for the previous COT line data
      h4("Previous COT Line Data"),
      lapply(feature_names, function(name) {
        numericInput(paste0(name, " T-1"), name, value = 0)
      }),
      
      actionButton("submit", "Submit")
    ),
    mainPanel(
      h3("Results"),
      tableOutput("resultsTable")  # Output table
    )
  )
)