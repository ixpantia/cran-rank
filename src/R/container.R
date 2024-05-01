box::use(
  htmltools[withTags],
  shiny[tags, tagList],
  purrr[map, map_int, flatten, flatten_chr],
  stringr[str_split, str_detect],
  glue[glue],
  tidyr[fill],
  tidyselect[everything]
)

append_padding_array <- function(arr, t_length) {
  length(arr) <- t_length
  return(arr)
}

#' @export
ContainerBuilder <- R6::R6Class(
  classname = "ContainerBuilder",
  public = list(
    initialize = function(var_names) {

      cnames_split <- var_names |>
        purrr::map(stringr::str_split, "\\|") |>
        purrr::flatten()

      matrix_rows <- cnames_split |>
        purrr::map_int(length) |>
        max()

      matrix_cols <- length(var_names)

      var_names_data <- cnames_split |>
        purrr::map(append_padding_array, matrix_rows) |>
        purrr::flatten_chr() |>
        matrix(nrow = matrix_cols, ncol = matrix_rows, byrow = TRUE) |>
        t() |>
        as.data.frame() |>
        tidyr::fill(tidyselect::everything(), .direction = "downup") |>
        as.matrix() |>
        unname()

      rendered_var_names <- t(
        matrix(FALSE, nrow = matrix_cols, ncol = matrix_rows)
      )

      private$data <- var_names_data
      private$rendered <- rendered_var_names

      return(invisible(self))
    },
    build = function() {

      thead <- tags$thead()

      for (y in seq_len(nrow(private$data))) {
        row <- list()
        for (x in seq_len(ncol(private$data))) {
          rendered <- private$render_th(x, y)
          if (!is.null(rendered)) {
            th <- tags$th(
              colspan = rendered[1],
              rowspan = rendered[2],
              class = "border text-center align-middle",
              private$data[y, x]
            )
            row <- append(row, list(th))
          }
        }
        thead$children <- append(thead$children, list(tags$tr(row)))
      }

      tagList(thead) |>
        tags$table()

    }
  ),
  private = list(
    get_colspan = function(x, y) {

      if (ncol(private$data) == 1) {
        return(1)
      }

      colspan <- 0

      current_x <- x

      repeat {

        if (current_x > ncol(private$data)) {
          break
        }

        if (y > 1) {
          if (private$get_colspan(x, y - 1) <= colspan) {
            break
          }
        }

        if (private$data[y, x] != private$data[y, current_x]) {
          break
        }

        current_x <- current_x + 1
        colspan <- colspan + 1

      }

      return(colspan)
    },
    get_rowspan = function(x, y) {

      if (nrow(private$data) == 1) {
        return(1)
      }

      rowspan <- 0
      current_y <- y

      repeat {

        if (current_y > nrow(private$data)) {
          break
        }

        if (private$data[y, x] != private$data[current_y, x]) {
          break
        }

        current_y <- current_y + 1
        rowspan <- rowspan + 1
      }

      return(rowspan)
    },
    is_rendered = function(x, y) {
      private$rendered[y, x]
    },
    render_th = function(x, y) {
      rowspan <- private$get_rowspan(x, y)
      colspan <- private$get_colspan(x, y)
      if (private$is_rendered(x, y)) {
        return(NULL)
      }
      private$rendered[y:(y + rowspan - 1), x:(x + colspan - 1)] <- TRUE
      return(c(colspan, rowspan))
    },
    data = NULL,
    rendered = NULL
  )
)
