#ui.R

require(shiny)
require(shinydashboard)
require(leaflet)

dashboardPage(
  dashboardHeader(
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Scatter", tabName = "scatter"),
      menuItem("Barchart", tabName = "Barchart"),
      menuItem("Crosstab", tabName = "Crosstab")
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "scatter",
              sidebarPanel(
              actionButton(inputId = "clicks1",  label = "Click me"),
              plotOutput("distPlot1")
              )
      ),
      tabItem(tabName = "Barchart",
              actionButton(inputId = "clicks1",  label = "Click me"),
              plotOutput("distPlot2")
      ),

      tabItem(tabName = "Crosstab",
        sidebarPanel(
        sliderInput("KPI1", "KPI_Low_Max_value:", 
                   min = 1, max = 100000,  value = 5000),
        textInput(inputId = "title", 
                 label = "Crosstab Title",
                 value = "Crosstab"),
              plotOutput("distPlot3")
        )
      )

    )
  )
)
