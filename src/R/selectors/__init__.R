box::use(
  shiny[NS, moduleServer, div, reactive, dateRangeInput,
        observe, bindEvent, selectInput, actionButton],
  cranlogs[cran_top_downloads],
  lubridate[year, today],
  tools[CRAN_package_db],
  cranlogs[cran_top_downloads]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  div(
    class = 'd-flex justify-content-between',
    dateRangeInput(ns("date_range"), "Date range:",
                   start = today() - 30,
                   end = today(),
                   min = "2001-01-01",
                   max = today(),
                   format = "yyyy/mm/dd",
                   separator = " - "),
    selectInput(
      ns("selector_paquetes"),
      "Seleccione paquete: ",
      choices = c("todos", CRAN_package_db()$Package),
      multiple = TRUE,
      selected = "todos"
    ),
    actionButton(ns("generar"),
                 class = "shadow mt-2 fs-6 bg-light border",
                 "Generar",
                 width = "120px")
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {

    selected_date <- reactive({
      input$date_range
    }) |> bindEvent(
      input$generar
    )

    selected_package <- reactive({
      if ("todos" %in% input$selector_paquetes) {
        top_packages <- cran_top_downloads(when = "last-month", count = 15)["package"]
        selected_packages <- as.character(top_packages$package)
        cleaned_packages <- gsub("\"", "", selected_packages)
        final_packages <- unlist(strsplit(cleaned_packages, ", "))

        return(final_packages)
      }
      input$selector_paquetes
    }) |> bindEvent(
      input$generar
    )

    return(
      list(selected_date = selected_date,
           selected_package = selected_package)
    )
  })
}

