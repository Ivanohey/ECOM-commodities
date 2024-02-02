# Welcome to the COT prediction tool.

# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# Please refer to the enclosed README.txt file in the cot_pred_tool folder for help and a user guide.

library(shiny)
library(readxl)
library(shiny)
library(readxl)
library(readr)
library(dplyr)
library(tidyr)
library(caret)
library(glmnet)
library(randomForest)

fluidPage(
  titlePanel("COT Line Prediction Tool"),
  sidebarLayout(
    sidebarPanel(
      selectInput("Commodity", "Select Commodity", choices = c("Coffee", "Cocoa", "Cotton", "Sugar")),
      
      fileInput("dataFile", "Upload Data File", accept = c(".csv", ".xlsx", ".xls")),
      
      actionButton("submit", "Submit")
    ),
    mainPanel(
      h3("Predictions"),
      tableOutput("resultsTable")
    )
  )
)