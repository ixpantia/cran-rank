box::use(
  shiny[NS, moduleServer, div, reactive, dateRangeInput,
        observe, bindEvent, selectizeInput, actionButton, updateSelectizeInput],
  cranlogs[cran_top_downloads], lubridate[year, today],
  tools[CRAN_package_db],
  cranlogs[cran_top_downloads],
  .. / cache[TopRankCache]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  div(
    dateRangeInput(
      ns("date_range"),
      "Dates 🗓️:",
      start = today() - 90,
      end = today() - 7,
      min = "2001-01-01",
      max = today(),
      format = "yyyy/mm/dd",
      separator = " - ",
      width = "100%"
    ),
    selectizeInput(
      ns("package_select"),
      "Select Packages 📦: ",
      choices = NULL,
      multiple = TRUE,
      selected = NULL,
      width = "100%"
    ),
    actionButton(
      ns("generate"),
      class = "shadow mt-2 fs-6 border btn-light",
      "Generate 🏆",
      width = "100%"
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {


    top_packages <- reactive({
      TopRankCache$get()[["package"]]
    })

    observe({
      updateSelectizeInput(
        "package_select",
        choices = CRAN_package_db()$Package,
        selected = top_packages(),
        server = TRUE,
        session = session
      )
    })

    selected_date <- reactive({
      input$date_range
    }) |> bindEvent(input$generate, TRUE)

    selected_package <- reactive({
      if (!shiny::isTruthy(input$package_select)) {
        return(top_packages())
      }
      input$package_select
    }) |> bindEvent(input$generate, TRUE)

    return(
      list(selected_date = selected_date,
           selected_package = selected_package)
    )
  })
}

