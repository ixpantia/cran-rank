box::use(
  shiny[NS, tagList, tags, moduleServer],
  DT[DTOutput, renderDT],
  cranlogs[cran_top_downloads]
)

box::use(
  . / container[ContainerBuilder]
)

#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    DTOutput(ns("table"))
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {

    selected_cols <- c("year", "month", "week")
    selected_packages <- c("ggplot2", "tidyr", "dplyr", "Rcpp", "rextendr", "plumber", "shiny", "data.table", "orbweaver")

    output$table <- renderDT({
      raw_data <- cranlogs::cran_downloads(selected_packages, from = "2023-01-01", to = "2023-12-31") |>
        dplyr::mutate(year = lubridate::year(date)) |>
        dplyr::mutate(month = paste0("M", lubridate::month(date))) |>
        dplyr::mutate(week = paste0("W", lubridate::week(date))) |>
        dplyr::mutate(day = lubridate::day(date)) |>
        tidyr::pivot_wider(
          names_from = selected_cols,
          names_sep = "|",
          values_from = "count",
          values_fn = sum,
          id_cols = "package"
        )

      print(raw_data)

      container <- ContainerBuilder$new(colnames(raw_data))$build()

      DT::datatable(
        raw_data,
        container = container,
        rownames = FALSE
      )
    })
  })
}

