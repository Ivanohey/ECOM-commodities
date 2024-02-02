# Welcome to the COT prediction tool.

# This is the server definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# Please refer to the enclosed README.txt file in the cot_pred_tool folder for help and a user guide.



wd = getwd()
cat("Current working directory: ",wd)
setwd(wd)

library(shiny)
library(readxl)
library(readr)
library(dplyr)
library(tidyr)
library(caret)
library(glmnet)
library(randomForest)

# Features_input are the variables names as they stand on the cot_export.xls file
# Features_mod refers to variables as they are read by the model.


features_names <- data.frame(
  features_input = c("Open Interest T", "Producer Longs T", "Producer Shorts T",
                     "Swap Dealer Longs T", "Swap Dealer Shorts T", "Swap Dealer Spreads T",
                     "Money Manager Longs T", "Money Manager Shorts T", "Money Manager Spreads T",
                     "Other Reportable Longs T", "Other Reportable Shorts T", "Other Reportable Spreads T",
                     "Total Reportable Longs T", "Total Reportable Shorts T", "Non Reportable Longs T", "Non Reportable Shorts T",
                     "Cocoa T",	"Coffee T",	"Cotton T", "Oil T", "Sugar T",
                     "Open Interest T-1", "Producer Longs T-1", "Producer Shorts T-1",
                     "Swap Dealer Longs T-1", "Swap Dealer Shorts T-1", "Swap Dealer Spreads T-1",
                     "Money Manager Longs T-1", "Money Manager Shorts T-1", "Money Manager Spreads T-1",
                     "Other Reportable Longs T-1", "Other Reportable Shorts T-1", "Other Reportable Spreads T-1",
                     "Total Reportable Longs T-1", "Total Reportable Shorts T-1", "Non Reportable Longs T-1", "Non Reportable Shorts T-1",
                     "Cocoa T-1",	"Coffee T-1",	"Cotton T-1", "Oil T-1", "Sugar T-1"),
  
  	
  
  
  features_mod = c("Open_Interest.t", "Producer_Longs.t", "Producer_Shorts.t",
                   "Swap_Dealer_Longs.t", "Swap_Dealer_Shorts.t", "Swap_Dealer_Spreads.t",
                   "Mon.t_1_Manager_Longs.t", "Mon.t_1_Manager_Shorts.t", "Mon.t_1_Manager_Spreads.t",
                   "Other_Reportable_Longs.t", "Other_Reportable_Shorts.t", "Other Reportable Spreads.t",
                   "Total_Reportable_Longs.t", "Total_Reportable_Shorts.t", "Non_Reportable_Longs.t", "Non_Reportable_Shorts.t",
                   "Cocoa.t",	"Coffee.t",	"Cotton.t", "Oil.t", "Sugar.t",
                   "Open_Interest.t_1", "Producer_Longs.t_1", "Producer_Shorts.t_1",
                   "Swap_Dealer_Longs.t_1", "Swap_Dealer_Shorts.t_1", "Swap_Dealer_Spreads.t_1",
                   "Mon.t_1_Manager_Longs.t_1", "Mon.t_1_Manager_Shorts.t_1", "Mon.t_1_Manager_Spreads.t_1",
                   "Other_Reportable_Longs.t_1", "Other_Reportable_Shorts.t_1", "Other Reportable Spreads.t_1",
                   "Total_Reportable_Longs.t_1", "Total_Reportable_Shorts.t_1", "Non_Reportable_Longs.t_1", "Non_Reportable_Shorts.t_1",
                   "Cocoa.t_1",	"Coffee.t_1",	"Cotton.t_1", "Oil.t_1", "Sugar.t_1")
)


server <- function(input, output, session) {
  
  # Load the models for each commodity
  models_coffee <- list(open_interest = readRDS("../models_pred/stepwise_coffee_oi.rds"),
                        mms = readRDS("../models_pred/stepwise_coffee_MMS.rds"),
                        mml = readRDS("../models_pred/stepwise_coffee_MML.rds"))
  
  models_cocoa <- list(open_interest = readRDS("../models_pred/stepwise_cocoa_oi.rds"),
                       mms = readRDS("../models_pred/stepwise_cocoa_MMS.rds"),
                       mml = readRDS("../models_pred/stepwise_cocoa_MML.rds"))
  
  models_cotton <- list(open_interest = readRDS("../models_pred/stepwise_cotton_oi.rds"),
                        mms = readRDS("../models_pred/stepwise_cotton_MMS.rds"),
                        mml = readRDS("../models_pred/stepwise_cotton_MML.rds"))
  
  models_sugar <- list(open_interest = readRDS("../models_pred/stepwise_sugar_oi.rds"),
                       mms = readRDS("../models_pred/stepwise_sugar_MMS.rds"),
                       mml = readRDS("../models_pred/stepwise_sugar_MML.rds"))
  
  observeEvent(input$submit, {
    req(input$dataFile)
    
    # Read the uploaded file based on its extension
    file_extension <- tools::file_ext(input$dataFile$name)
    if (file_extension == "csv") {
      pred_file <- read.csv(input$dataFile$datapath)
    } else if (file_extension %in% c("xlsx", "xls")) {
      pred_file <- read_excel(input$dataFile$datapath)
    } else {
      stop("Unsupported file type.")
    }
    
    # Convert pred_file to a data frame if it's a tibble
    pred_file <- as.data.frame(pred_file)
    
    # Create a mapping from features_input to features_mod (input variables are not in same format as the ones saved by the model)
    col_mapping <- setNames(features_names$features_mod, features_names$features_input)
    
    # Check if all required columns are present in the uploaded file
    if (!all(names(pred_file) %in% names(col_mapping))) {
      missing_cols <- names(col_mapping)[!names(col_mapping) %in% names(pred_file)]
      stop("Missing required columns in the uploaded file: ", paste(missing_cols, collapse = ", "))
    }
    
    names(pred_file) <- col_mapping[names(pred_file)]
    
    # Transform all columns in pred_file to numeric
    model_data <- pred_file %>% mutate_if(is.character, as.numeric)
    
    # Handle any NAs that might have been introduced by as.numeric conversion
    if (any(is.na(model_data))) {
      stop("Non-numeric data found in input. Please check your input file.")
    }
    
    print(str(model_data))
    
    # Select models based on the chosen commodity
    selected_models <- switch(input$Commodity,
                              "Coffee" = models_coffee,
                              "Cocoa" = models_cocoa,
                              "Cotton" = models_cotton,
                              "Sugar" = models_sugar)
    
    # Perform model predictions for each target
    prediction_open_interest <- predict(selected_models$open_interest, model_data)
    prediction_manager_shorts <- predict(selected_models$mms, model_data)
    prediction_manager_longs <- predict(selected_models$mml, model_data)
    
    # Combine predictions into a data frame
    results <- data.frame(
      `Open Interest` = prediction_open_interest,
      `Money Managers Longs` = prediction_manager_longs,
      `Money Managers Shorts` = prediction_manager_shorts
    )
    
    # Display results
    output$resultsTable <- renderTable({
      results
    })
  })
}

