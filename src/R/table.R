box::use(
  shiny[NS, tagList, tags, moduleServer],
  DT[DTOutput, renderDT, formatStyle],
  cranlogs[cran_top_downloads, cran_downloads],
  lubridate[year, month, week, day],
  dplyr[mutate, group_by, summarise],
  tidyr[pivot_wider]
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
server <- function(id, selected_date, selected_packages) {
  moduleServer(id, function(input, output, session) {

    selected_cols <- c("year", "month", "week")
    # selected_packages <- c("tidyr", "plumber", "shiny")

    output$table <- renderDT({
      raw_data <- cran_downloads(packages = selected_packages(),
                                 from = selected_date()[1],
                                 to = selected_date()[2]) |>
        mutate(year = year(date)) |>
        mutate(month = month(date)) |>
        mutate(week = week(date)) |>
        mutate(day = day(date)) |>
        group_by(!!!rlang::syms(selected_cols), package) |>
        summarise(count = sum(count, na.rm = TRUE), .groups = "drop") |>
        group_by(package) |>
        dplyr::arrange(week) |>
        mutate(
          .lag = dplyr::lag(count),
          .diff = count - .lag,
          .is_neg = .diff < 0,
          .html = redgreen::redgreen(count, .diff)
        ) |>
        dplyr::arrange(year, month, week) |>
        mutate(
          year = paste0("Y", year),
          month = paste0("M", month),
          week = paste0("W", week)
        ) |>
        dplyr::rename(Package = package) |>
        pivot_wider(
          names_from = selected_cols,
          names_sep = "|",
          values_from = ".html",
          id_cols = "Package"
        )

      container <- ContainerBuilder$new(colnames(raw_data))$build()

      DT::datatable(
        raw_data,
        escape = FALSE,
        container = container,
        rownames = FALSE
      ) |>
        formatStyle(TRUE, "white-space" = "nowrap")
    })
  })
}

