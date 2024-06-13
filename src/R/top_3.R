box::use(
  shiny[NS, tagList, h1, h5, div, moduleServer, textOutput, renderText],
  cranlogs[cran_top_downloads]
)

top_3 <- cran_top_downloads(when = "last-day",
                            count = 3)$package

#' @export
ui <- function(id) {
  ns <- NS(id)
  tagList(
    div(
      style = "margin-bottom: 10px; border: 2px solid #ccc; padding: 20px;
      text-align: center; margin-top: 20px;",
      h5(style = "font-weight: bold;", "🌟 Today's Top 3:"),
      div(
        style = "display: grid; grid-template-columns: 1fr;
        grid-template-rows: auto auto;",
        div(
          style = "text-align: center; margin: 10px;",
          h1("🥇"),
          h5(style = "margin-top: 0;", textOutput(ns("package1")))
        ),
        div(
          style = "display: grid; grid-template-columns: 1fr 1fr;
          grid-template-rows: auto;",
          div(
            style = "text-align: center; margin: 10px;",
            h1("🥈"),
            h5(style = "margin-top: 0;", textOutput(ns("package2")))
          ),
          div(
            style = "text-align: center; margin: 10px;",
            h1("🥉"),
            h5(style = "margin-top: 0;", textOutput(ns("package3")))
          )
        )
      )
    )
  )
}

#' @export
server <- function(id) {
  moduleServer(id, function(input, output, session) {
    output$package1 <- renderText({
      top_3[1]
    })
    output$package2 <- renderText({
      top_3[2]
    })
    output$package3 <- renderText({
      top_3[3]
    })
  })
}