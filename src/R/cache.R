
Cache <- R6::R6Class(
  classname = "Cache",
  public = list(
    initialize = function(func) {
      private$value <- func()
    },
    get = function() {
      private$value
    }
  ),
  private = list(
    value = NULL
  )
)

#' @export
TopRankCache <- Cache$new(function() {
  cranlogs::cran_top_downloads(when = "last-month", count = 15)
})
