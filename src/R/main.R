box::use(
  bslib[page, bs_theme],
  shiny[moduleServer, NS, div, tags],
)

box::use(
  . / table,
  ./ selectors
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  page(
    theme = bs_theme(
      primary = "#3F72FF",
      secondary = "#E85600"
    ),
    div(
      class = "container-fluid",
      div(
        class = "row bg-primary",
        div(
          class = "col-12 p-4",
          tags$span("cran-rank", class = "text-light d-inline-block fs-1"),
          tags$span(" "),
          tags$a(
            tags$span("by ixpantia", class = "text-secondary fs-6 fw-bold"),
            href = "https://ixpantia.com"
          )
        )
      ),
      div(
        class = "row px-4 pt-4",
        div(
          class = "col-3",
          selectors$ui(ns("selectors"))
        ),
        div(
          class = "col-9",
          table$ui(ns("table"))
        )
      )
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    selectors <- selectors$server("selectors")
    table$server("table",
                 selected_date = selectors$selected_date,
                 selected_packages = selectors$selected_package)
  })
}
