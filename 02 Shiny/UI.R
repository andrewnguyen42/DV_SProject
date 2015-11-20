#ui.R

require(shiny)
require(shinydashboard)
require(leaflet)

dashboardPage(
  dashboardHeader(
  ),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Scatter", tabName = "scatter", icon = icon("dashboard"))
    )
  ),
  dashboardBody(
    tabItems(
      # First tab content
      tabItem(tabName = "scatter",
              actionButton(inputId = "clicks1",  label = "Click me"),
              plotOutput("distPlot1")
      )
    )
  )
)
