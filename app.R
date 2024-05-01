box::purge_cache()
options("box.path" = file.path(getwd(), "src", "R"))
box::use(
  src / R / main
)

ui <- main$ui("main")

server <- function(input, output, session) main$server("main")

shinyApp(ui, server)
