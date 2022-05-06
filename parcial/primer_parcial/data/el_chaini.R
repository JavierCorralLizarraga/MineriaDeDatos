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

paquetes <- c("shiny","plotly","ggplot2")

lapply(paquetes, instalar);

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Auto Information"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins",
                  "Number of bins:",
                  min = 1,
                  max = 50,
                  value = 30),
      selectInput("nombre", "Caracteristica", names(autos_data))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("Histograma", plotlyOutput("distPlot")),
                  tabPanel("Summary", verbatimTextOutput("summary")),
                  tabPanel("Boxplot", plotlyOutput("boxplot"))
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
      bins <- seq(min(x), max(x), length.out = input$bins + 1)
      
      # draw the histogram with the specified number of bins
      p <-ggplot(autos_data)+
        geom_histogram(mapping=aes_string(x=input$nombre),breaks=bins)
      
      ggplotly(p)
    }
    else
    {
      
      p <-ggplot(autos_data, aes_string(x=input$nombre))+
        geom_bar()
    }
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
