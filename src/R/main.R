box::use(
  bslib[page_fluid],
  shiny[moduleServer, NS],
)

box::use(
  . / table,
  ./ selectors
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  page_fluid(
    selectors$ui(ns("selectors")),
    table$ui(ns("table"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    selectors <- selectors$server("selectors")
    table$server("table",
                 year = selectors$year(),
                 month = selectors$month(),
                 week = selectors$week(),
                 day = selectors$day())
  })
}
