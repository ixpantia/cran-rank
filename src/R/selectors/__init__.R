box::use(
  shiny[NS, moduleServer, div, selectizeInput, reactive],
  cranlogs[cran_top_downloads],
  lubridate[year, today]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  div(
    class = 'row',
    selectizeInput(ns("year"),
                   "Year",
                   choices = 2000:year(today())),
    selectizeInput(ns("month"),
                   "Month:",
                   choices = month.name),
    selectizeInput(ns("week"),
                   "Week:",
                   choices = 1:52),
    selectizeInput(ns("day"),
                   "Day:",
                   choices = 1:31)
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {

    selected_year <- reactive({
      input$year
    })

    selected_month <- reactive({
      input$month
    })

    selected_week <- reactive({
      input$week
    })

    selected_day <- reactive({
      input$day
    })
    return(
      list(
        year = selected_year,
        month = selected_month,
        week = selected_week,
        day = selected_day
      )
    )
  })
}

