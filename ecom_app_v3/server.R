#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

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
    
    # Prepare input data for models
    model_data <- as.data.frame(sapply(features_names$features_mod, function(name) input[[name]]))
    
    
    # Process input data
    
    
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

