#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

instalar <- function(paquete) {
  
  if (!require(paquete,character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE)) {
    install.packages(as.character(paquete), dependecies = TRUE, repos = "http://cran.us.r-project.org")
    library(paquete, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE)
  }
}

paquetes <- c("shiny","plotly","ggplot2","ggbiplot")

lapply(paquetes, instalar);

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Auto Information"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("nombre", "Caracteristica", names(autos_data)),
      selectInput("nombre2", "Segunda Caracteristica (Bivariado)", names(autos_data))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Univariado", plotlyOutput("distPlot")),
                  tabPanel("Bivariado", plotlyOutput("distPlot2")),
                  tabPanel("Multivariado", plotlyOutput("distPlot3"), plotOutput("distPlot4"))
      )
    )        
  )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$distPlot <- renderPlotly({
    
    
    if(is.numeric(autos_data[[input$nombre]]))
    {
      # generate bins based on input$bins from ui.R
      x    <- autos_data[, input$nombre]
      bins <- seq(min(x), max(x), length.out = 40 + 1)
      
      # draw the histogram with the specified number of bins
      p <-ggplot(autos_data)+
        geom_histogram(mapping=aes_string(x=input$nombre),breaks=bins)
    }
    else
    {
      p <-ggplot(autos_data, aes_string(x=input$nombre))+
        geom_bar()
    }
    
    ggplotly(p)
  })
  
  output$distPlot2 <- renderPlotly({
    
    
    if(is.numeric(autos_data[[input$nombre]]))
    {
      if(is.numeric(autos_data[[input$nombre2]]))
      {
        p <-plot_ly(x=autos_data[[input$nombre]], y=autos_data[[input$nombre2]], type="scatter", mode="markers") %>% layout(xaxis = list(title=input$nombre), yaxis = list(title=input$nombre2))
      }
      else
      {
        p <-ggplot(autos_data)+
          geom_boxplot(mapping=aes_string(x=input$nombre2, y=input$nombre))
      }
      
    }
    else
    {
      if(is.numeric(autos_data[[input$nombre2]]))
      {
        p <-ggplot(autos_data)+
          geom_boxplot(mapping=aes_string(x=input$nombre, y=input$nombre2))
      }
      else
      {
        p <-ggplot(autos_data)+
          geom_bar(mapping=aes_string(x=input$nombre, fill=input$nombre2))
      }
    }
    
    ggplotly(p)
  })
  
  
  output$distPlot3 <- renderPlotly({
  
    autos_data.pca <- prcomp(autos_data[,c(1,2,11:14,17,19:26)], center = TRUE,scale. = TRUE)
    
    p <- ggbiplot(autos_data.pca, groups = autos_data[[input$nombre]])
    
    ggplotly(p)
    
  })
  
  output$distPlot4 <- renderPlot({

    autos_data.pca <- prcomp(autos_data[,c(1,2,11:14,17,19:26)], center = TRUE,scale. = TRUE)
    
    plot(autos_data.pca)
    
  })
  
  # Generate a summary of the data ----
  output$summary <- renderPrint({
    summary(autos_data[input$nombre])
  })
  
  output$boxplot <- renderPlotly({
    variable <- input$nombre
    
    p <-ggplot(autos_data)+
      geom_boxplot(mapping=aes_string(y=variable))
    
    ggplotly(p)
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
