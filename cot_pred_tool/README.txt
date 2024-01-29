--- Welcome in the COT Prediction Tool User Guide ---

This document helps the user to handle and interact with the COT Prediction Tool designed for ECOM Agroindustrial.

ATTENTION: - Make sure to have the latest versions of R and RStudio running on the operating system, available here: https://posit.co/download/rstudio-desktop/
           - Install all required packages, RStudio should suggest you to do it by accepting a window. If not, install them manually in the console using the following function: install.packages("package name")


Setting the data:

 1. Create a copy of the "cot_export.xlsx" file located in the "export" folder (rename it if needed)
 2. Open the newly duplicated file.
 2. Paste the data in the following order:
      - The first 16 columns (1 to 16) must be filled with the latest data available (data on time T), please make sure the correct value is assigned to the corresponding variable.
      - The next 16 columns (16 to 32) must be filled with the second last data available (data on time T-1), please make sure the correct value is assigned to the corresponding variable.
      - The next 5 columns (33 to 37) must be filled with the price difference of the concerned commodity by applying the following formula: price_diff_Commodity(T) = Price_commo(T) - Price_commo(T-1).
      - The last 5 columns (38 to 42) must be filled with the price difference of the concerned commodity by applying the following formula: price_diff_Commodity(T-1) = Price_commo(T-1) - Price_commo(T-2).
  3. Save the modified file.
  4. Open either the ui.R or Server.R file and press the "Run App" button.
  5. The app should open itself into the default browser or in the visualization window of RStudio, expand it if needed.
  6. Select the commodity to be predicted.
  6. Press the "Browse files" button and select the previously filled .xlsx file.
  7. Launch prediction with "Submit" button.
  8. Predictions should appear with corresponding target variables.
  
IMPORTANT: Once the file has been uploaded and submitted, a different commodity can be selected and predicted without having to reload the .xlsx file.

DISCLAIMER: The COT Prediction Tool has been developed in the context of an academic project between HEC Lausanne and ECOM Agroindustrial, it only serves educational applications. The software is a prototype and is therefore not suited nor ready to predict real-time financial data for speculation purposes. 