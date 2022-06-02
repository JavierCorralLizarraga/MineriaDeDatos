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

namesT <- names(titanic_train)[1:15,18,19]

lapply(paquetes, instalar);

# Define UI for application that draws a histogram
ui <- fluidPage(
  
  # Application title
  titlePanel("Auto Information"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
      selectInput("nombre", "Caracteristica", namesT),
      selectInput("nombre2", "Segunda Caracteristica (Bivariado)", namesT)
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
    
    
    if(is.numeric(titanic_train[[input$nombre]]))
    {
      # generate bins based on input$bins from ui.R
      x    <- titanic_train[, input$nombre]
      bins <- seq(min(x), max(x), length.out = 40 + 1)
      
      # draw the histogram with the specified number of bins
      p <-ggplot(titanic_train)+
        geom_histogram(mapping=aes_string(x=input$nombre),breaks=bins)
    }
    else
    {
      p <-ggplot(titanic_train, aes_string(x=input$nombre))+
        geom_bar()
    }
    
    ggplotly(p)
  })
  
  output$distPlot2 <- renderPlotly({
    
    
    if(is.numeric(titanic_train[[input$nombre]]))
    {
      if(is.numeric(titanic_train[[input$nombre2]]))
      {
        p <-plot_ly(x=titanic_train[[input$nombre]], y=titanic_train[[input$nombre2]], type="scatter", mode="markers") %>% layout(xaxis = list(title=input$nombre), yaxis = list(title=input$nombre2))
      }
      else
      {
        p <-ggplot(titanic_train)+
          geom_boxplot(mapping=aes_string(x=input$nombre2, y=input$nombre))
      }
      
    }
    else
    {
      if(is.numeric(titanic_train[[input$nombre2]]))
      {
        p <-ggplot(titanic_train)+
          geom_boxplot(mapping=aes_string(x=input$nombre, y=input$nombre2))
      }
      else
      {
        p <-ggplot(titanic_train)+
          geom_bar(mapping=aes_string(x=input$nombre, fill=input$nombre2))
      }
    }
    
    ggplotly(p)
  })
  
  
  output$distPlot3 <- renderPlotly({
    
    titanic_train.pca <- prcomp(titanic_train[,c(1,2,11:14,17,19:26)], center = TRUE,scale. = TRUE)
    
    p <- ggbiplot(titanic_train.pca, groups = titanic_train[[input$nombre]])
    
    ggplotly(p)
    
  })
  
  output$distPlot4 <- renderPlot({
    
    titanic_train.pca <- prcomp(titanic_train[,c(1,2,6,9,11:15)], center = TRUE,scale. = TRUE)
    
    plot(titanic_train.pca)
    
  })
  
  # Generate a summary of the data ----
  output$summary <- renderPrint({
    summary(titanic_train[input$nombre])
  })
  
  output$boxplot <- renderPlotly({
    variable <- input$nombre
    
    p <-ggplot(titanic_train)+
      geom_boxplot(mapping=aes_string(y=variable))
    
    ggplotly(p)
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)