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



function(input, output){
  ### Loading Data  
  Locations_2018 <- read.csv("2018_Locations_Final2.csv", header = TRUE, stringsAsFactors = FALSE)
  Var_data <- read.csv("Var_Data3.csv", header = TRUE, stringsAsFactors = FALSE)
  Wrd_Data_2018 <- read.csv("2018_Wrd_Data_Final.csv", header = TRUE, stringsAsFactors = FALSE)
  Secrecy_Score <- read.csv("Countries4.csv", header = TRUE, stringsAsFactors = FALSE)
  Plot_data <- read.csv("Plot_data.csv", header = TRUE, stringsAsFactors = FALSE)
  colnames(Var_data)<- c("CIK","Company Name","Assets","Liabilities","Pretax Income Domestic","Pretax Income Foreign","Property, plant, equipment","Tax Foreign","Tax Total","Category","Mean Secrecy Heaven Score","Cat No")
  
  ### Making Data and Loading in Output
  CIK_data <- reactive({
    Locations_2018 %>% filter(Locations == input$loc) %>% summarise("CIK Count" = n())
  })
  
  output$CIK <- renderTable({
    CIK_data()})
  
  ### Making Data and Loading in Output
  Sec_Score <- reactive({
    Secrecy_Score %>% filter(Locations == input$loc) %>% select(SecrecyHavenScore)
  })
  
  output$Sec_Score <- renderTable({
    Sec_Score()})
  
  ### Making Plot Loading in Output
  join_df <- reactive({
    Plot_data %>%  filter(Location == input$loc)  })
  
  
  output$plot <- renderPlotly({
    plot <- ggplot(Plot_data, aes(x= `Secrecy.Haven.Score`, y=Frequency, label = Location)) +
      geom_point(size=1.5, shape=1, alpha=0.5)+
      geom_point(data=join_df(), aes(x=`Secrecy.Haven.Score`,y=Frequency), color='red',size=3)+
      geom_vline(xintercept = 56.1, colour = "red", linetype = "dotted", size = 0.2)+ 
      geom_vline(xintercept = 65.5, colour = "red", linetype = "dotted", size = 0.2)+ 
      geom_vline(xintercept = 74.8, colour = "red", linetype = "dotted", size = 0.2)+ 
      annotate(geom="text", x=54, y=2800, label="1st Quantile",color="red")+
      annotate(geom="text", x=64, y=2800, label="Median",color="red")+ 
      annotate(geom="text", x=72.7, y=2800, label="3rd Quantile",color="red")+ 
      theme_bw()+
      ggtitle("Secrecy Haven Score vs No, of CIK Frequency")+
      xlab("Secrecy Haven Score")+
      ylab("Frequency / Presence")
    
    ggplotly(plot)
  })
  
  output$table <- DT::renderDataTable({
    DT::datatable(Wrd_Data_2018, class = 'cell-border stripe', colnames = c('Company Name' = 'CompanyName','Pretax Income Domestic' = 'PretaxIncome_Dom','Pretax Income Foreign' = 'PretaxIncome_For','Property, Plant & Equipment' = 'PropertyPlantEquip','Tax Foreign' = 'Tax_For'), filter = 'top', options = list(pageLength = 7))})
  
# Company data Server
  
  output$text <- renderText({
    a <- input$comp
    no <- Var_data %>% filter(`Company Name` == a) %>% select(`Mean Secrecy Heaven Score`) %>% unlist() %>% as.numeric()
    nop <- no * 100
    paste(nop,"% of operation of ",input$comp," is in Secrecy Haven locations.")
  })
  
  ### Making Plot Loading in Output
  point <- reactive({
    Var_data %>% filter(`Company Name` == input$comp)  })
  
  output$box <- renderPlotly({
    box <- ggplot(Var_data)+
      geom_boxplot(aes(x = `Cat No`, y = `Mean Secrecy Heaven Score`))+
      geom_point(data=point(), aes(x = `Cat No`, y = `Mean Secrecy Heaven Score`), color='red',size=3)+
      theme_light()+
      ggtitle("Secrecy Haven Score across Company Categories")+
      xlab("Company Categories")+
      ylab("Secrecy Haven Score")
    
    ggplotly(box)})  
  
}
  






