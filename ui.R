library(shiny) 
library(shinythemes)
library(shiny) 
library(stringr)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(plotly)
library(gghighlight)

Locations_2018 <- read.csv("2018_Locations_Final2.csv", header = TRUE, stringsAsFactors = FALSE)
Var_data <- read.csv("Var_Data3.csv", header = TRUE, stringsAsFactors = FALSE)
Var_data$Cat_ <- as.factor(Var_data$Cat_)
colnames(Var_data)<- c("CIK","Company Name","Assets","Liabilities","Pretax Income Domestic","Pretax Income Foreign","Property, plant, equipment","Tax Foreign","Tax Total","Category","Mean Secrecy Heaven Score","Cat No")

############## App Code Starts ################

navbarPage("Unveiling the Secrecy Havens?",theme = shinytheme("paper"),
                 tabPanel("Location",
                          fluidRow(
                            column(3,
                              selectInput(inputId = "loc", label = "Choose a Location:", choices = unique(Locations_2018$Locations)),
                              helpText("Data: 2018"),
                              helpText("Source: (1) https://www.sec.gov/edgar.html, (2) https://wrds-www.wharton.upenn.edu/")),
                            column(9,
                            fluidRow(
                            column(2, offset = 1,
                                tableOutput("CIK")),
                             column(2, offset = 1,
                                tableOutput("Sec_Score"))))),
                          br(),
                                plotlyOutput("plot")) ,
                 tabPanel("Company Data",
                          sidebarLayout(sidebarPanel(
                            selectInput(inputId = "comp", label = "Choose a Company:", choices = unique(Var_data$`Company Name`))),
                            mainPanel(
                              # tableOutput("CIK"),
                              # tableOutput("Sec_Score"),
                              plotlyOutput("box"),
                              br(),
                              helpText("Company Categories / Industries"),
                              helpText("1: Construction, 2: Finance, Insurance, And Real Estate, 3: Manufacturing, 4: Mining, 5: Public Administration, 6: Retail Trade, 7: Services, 8: Transportation, Communications, Electric, Gas, And Sanitary Services, 9: Wholesale Trade"),
                              br(),
                              tags$blockquote(textOutput("text")) ))),
                 tabPanel("Data",
                          DT::dataTableOutput("table")),
                 tabPanel("About",
                          tags$h6("Shiny Application was prepared as a part of Master Thesis Project"),br(),
                          strong("Steps Involved"),br(),
                          "(1) Data of subsidiary locations extracted for all public listed US companies on Edgar by Web Crawling ",br(),
                          "(2) The dataset helps identify popularity of Secrecy Havens globally", br(),
                          "(3) Company comparative tax information and assets helps identify tax evasion policies adopted by various companies",br(),br(),
                          em("The dashboard was prepared by Daniyal Arif")
))

