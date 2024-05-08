box::use(
  shiny[NS, moduleServer, div, reactive, dateRangeInput,
        observe, bindEvent],
  cranlogs[cran_top_downloads],
  lubridate[year, today]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  div(
    class = 'row',
    dateRangeInput(ns("date_range"), "Date range:",
                   start  = today(),
                   end    = today(),
                   min    = "2001-01-01",
                   max    = today(),
                   format = "yyyy/mm/dd",
                   separator = " - ")
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {

    selected_date <- reactive({
      input$date_range
    })

    return(
      selected_date
    )
  })
}

