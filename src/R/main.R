box::use(
  bslib[page_fluid],
  shiny[moduleServer, NS],
)

box::use(
  . / table
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  page_fluid(
    table$ui(ns("table"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    table$server("table")
  })
}
