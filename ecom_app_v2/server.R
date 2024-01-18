#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(readxl)
library(readr)
library(dplyr)
library(tidyr)
library(caret)
library(glmnet)
library(randomForest)

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

# Define server logic required to draw a histogram
function(input, output, session) {
  # Load the models for each commodity
  models_coffee <- list(open_interest = readRDS("../models_pred/coffee_lasso_oi.rds"),
                        mms = readRDS("../models_pred/coffee_lasso_mms.rds"),
                        mml = readRDS("../models_pred/coffee_lasso_mml.rds"))
  # Repeat the above for cocoa, cotton, and sugar
  models_cocoa <- list(open_interest = readRDS("../models_pred/cocoa_lasso_oi.rds"),
                        mms = readRDS("../models_pred/cocoa_lasso_mms.rds"),
                        mml = readRDS("../models_pred/cocoa_lasso_mml.rds"))
  
  
  models_cotton <- list(open_interest = readRDS("../models_pred/cotton_lasso_oi.rds"),
                        mms = readRDS("../models_pred/cotton_lasso_mms.rds"),
                        mml = readRDS("../models_pred/cotton_lasso_mml.rds"))
  
  models_sugar <- list(open_interest = readRDS("../models_pred/sugar_lasso_oi.rds"),
                       mms = readRDS("../models_pred/sugar_lasso_mms.rds"),
                       mml = readRDS("../models_pred/sugar_lasso_mml.rds"))
  
  observeEvent(input$submit, {
    
    req(input$dataFile)  # Ensure a file is uploaded
    
    # Determine the type of the file based on its extension
    file_extension <- tools::file_ext(input$dataFile$name)
    if (file_extension == "csv") {
      pred_file <- read.csv(input$dataFile$datapath)
    } else if (file_extension %in% c("xlsx", "xls")) {
      pred_file <- read_excel(input$dataFile$datapath)
    } else {
      stop("Unsupported file type.")
    }
    
    pred_file <- as.data.frame(pred_file)
    
    print(names(pred_file))
    print(str(pred_file))
    
    # Create a mapping from features_input to features_mod
    col_mapping <- setNames(features_names$features_mod, features_names$features_input)
    
    # Check if all required columns are present in the uploaded file
    if (!all(names(pred_file) %in% names(col_mapping))) {
      missing_cols <- names(col_mapping)[!names(col_mapping) %in% names(pred_file)]
      stop("Missing required columns in the uploaded file: ", paste(missing_cols, collapse = ", "))
    }
    
    # Rename columns of data according to the model's expected feature names
    names(pred_file) <- col_mapping[names(pred_file)]
    
    # Prepare input data for models
    model_data <- pred_file
    
    print(str(model_data))
    # Select models based on the chosen commodity
    selected_models <- switch(input$Commodity,
                              "Coffee" = models_coffee,
                              "Cocoa" = models_cocoa,
                              "Cotton" = models_cotton,
                              "Sugar" = models_sugar)
    
    # Perform model predictions
    prediction1 <- predict(selected_models$open_interest, newdata = model_data)
    prediction2 <- predict(selected_models$mms, newdata = model_data)
    prediction3 <- predict(selected_models$mml, newdata = model_data)
    
    
    # Combine predictions into a data frame
    results <- data.frame(
      `Open Interest` = prediction1,
      `Money Managers Shorts` = prediction2,
      `Money Managers Longs` = prediction3
    )
    
    # Display results
    output$resultsTable <- renderTable({
      results
    })
  })
}

