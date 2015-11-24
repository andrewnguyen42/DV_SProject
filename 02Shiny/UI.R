#ui.R

require(shiny)
require(shinydashboard)
require(leaflet)

dashboardPage(
  dashboardHeader(title="Shiny Project 1"
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
              actionButton(inputId = "clicks1",  label = "Update Data"),
              plotOutput("distPlot1")
              
      ),
      tabItem(tabName = "Barchart",
              radioButtons(inputId="reference", label="Reference Line:",choices = c("Median:"=1,"Mean"=2)),
              sliderInput("mincount","Minimum Death Count",min=1,max=50000,value=5000),
              plotOutput("distPlot2")
      ),

      tabItem(tabName = "Crosstab",
        sliderInput("KPI1", "Death Count KPI", 
                   min = 1, max = 100000,  value = 5000),
              plotOutput("distPlot3")
        
      )

    )
  )
)
