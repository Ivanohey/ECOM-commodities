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
  models_coffee <- list(open_interest = readRDS("path/to/coffee_model1.rds"),
                        mms = readRDS("path/to/coffee_model2.rds"),
                        mml = readRDS("path/to/coffee_model3.rds"))
  # Repeat the above for cocoa, cotton, and sugar
  models_cocoa <- list(open_interest = readRDS("path/to/coffee_model1.rds"),
                        mms = readRDS("path/to/coffee_model2.rds"),
                        mml = readRDS("path/to/coffee_model3.rds"))
  
  
  models_cotton <- list(open_interest = readRDS("path/to/coffee_model1.rds"),
                        mms = readRDS("path/to/coffee_model2.rds"),
                        mml = readRDS("path/to/coffee_model3.rds"))
  
  models_sugar <- list(open_interest = readRDS("path/to/coffee_model1.rds"),
                        mms = readRDS("path/to/coffee_model2.rds"),
                        mml = readRDS("path/to/coffee_model3.rds"))
  
  observeEvent(input$submit, {
    
    # Collect input data for the latest and previous COT line
    latest_data <- sapply(feature_names, function(name) input[[paste0("latest_", name)]])
    previous_data <- sapply(feature_names, function(name) input[[paste0("previous_", name)]])
    
    # Combine latest and previous data if necessary
    combined_data <- data.frame(latest_data, previous_data)
    
    
    # Process input data
    
    
    # Select models based on the chosen commodity
    selected_models <- switch(input$Commodity,
                              "Coffee" = models_coffee,
                              "Cocoa" = models_cocoa,
                              "Cotton" = models_cotton,
                              "Sugar" = models_sugar)
    
    # Perform model predictions
    prediction1 <- predict(selected_models$open_interest, newdata = combined_data)
    prediction2 <- predict(selected_models$mms, newdata = combined_data)
    prediction3 <- predict(selected_models$mml, newdata = combined_data)
    
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

