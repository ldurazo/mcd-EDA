#comment package installation when deploying
#chooseCRANmirror(ind = 52)
#install.packages(c("rsconnect", "configr", "ggplot2", "shiny"))

library(rsconnect)
library(configr)
library(ggplot2)
library(shiny)

shinyconf <- read.config(file = "shiny.json")

chess_agg_ds <- read.csv("data/chess_aggregate_ds.csv")
violence_chess_ds <- read.csv("data/violence_chess_ds.csv")

rsconnect::setAccountInfo(name = shinyconf[["name"]],
                          token = shinyconf[["token"]],
                          secret = shinyconf[["secret"]])

# Define UI ----
ui <- fluidPage(
  titlePanel("Violence against women and top women chess players across the developing world"),

  # Create a new Row in the UI for selectInputs
  fluidRow(
    column(4,
           selectInput("code",
                       "Country:",
                       c("All",
                         unique(as.character(violence_chess_ds$code)))),
           sliderInput("violence", "Violence Score:",
                       min = 0, max = 50,
                       value = c(0,50)),
           sliderInput("standard_mean", "Standard Rating:",
                       min = 0, max = 3000,
                       value = c(0,3000)),
    ),
    column(4,
      plotOutput("plot_rate")
    ),
    column(4,
      plotOutput("plot_players")
    ),
  ),
  # Create a new row for the table.
  DT::dataTableOutput("violence"),
)

# Define server logic ----
server <- function(input, output) {
  # Filter data based on selections
  output$violence <- DT::renderDataTable(DT::datatable({
    data <- violence_chess_ds
    if (input$code != "All") {
      data <- data[violence_chess_ds$code == input$code,]
    }
    data <- data[data$Score >= input$violence[1] & data$Score <= input$violence[2],]
    data <- data[data$Standard_Rating_mean >= input$standard_mean[1] & data$Standard_Rating_mean <= input$standard_mean[2] & !is.na(data$Standard_Rating_mean),]
    #data <- data[data$Rapid_Rating_mean >= input$rapid_mean[1] & data$Rapid_Rating_mean <= input$rapid_mean[2] & !is.na(data$Rapid_Rating_mean),]
    #data <- data[data$Blitz_Rating_mean >= input$blitz_mean[1] & data$Blitz_Rating_mean <= input$blitz_mean[2] & !is.na(data$Blitz_Rating_mean),]
    data
  }))

  output$plot_rate <- renderPlot({
    data <- violence_chess_ds
    if (input$code != "All") {
      data <- data[violence_chess_ds$code == input$code,]
    }
    data <- data[data$Score >= input$violence[1] & data$Score <= input$violence[2],]
    data <- data[data$Standard_Rating_mean >= input$standard_mean[1] & data$Standard_Rating_mean <= input$standard_mean[2] & !is.na(data$Standard_Rating_mean),]
    plot(data$Score, data$Standard_Rating_mean)
  })

  output$plot_players <- renderPlot({
        data <- violence_chess_ds
    if (input$code != "All") {
      data <- data[violence_chess_ds$code == input$code,]
    }
    data <- data[data$Score >= input$violence[1] & data$Score <= input$violence[2],]
    data <- data[data$Standard_Rating_mean >= input$standard_mean[1] & data$Standard_Rating_mean <= input$standard_mean[2] & !is.na(data$Standard_Rating_mean),]
    plot(data$Score, data$Standard_Rating_n)
  })
}

shinyApp(ui = ui, server = server)

# Run with deployApp() on terminal