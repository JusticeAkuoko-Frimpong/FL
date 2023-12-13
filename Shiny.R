# Install required packages if not already installed
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

if (!requireNamespace("FL", quietly = TRUE)) {
  devtools::install_github("JusticeAkuoko-Frimpong/FL")
}

if (!requireNamespace("shiny", quietly = TRUE)) {
  install.packages("shiny")
}

# Load packages
library(FL)
library(shiny)

# Generate UI
ui = fluidPage(
  titlePanel("Tabsets"),
  sidebarLayout(
    sidebarPanel(
      fileInput(
        "file",
        "Upload your data as a CSV here",
        multiple = FALSE,
        accept = ".csv",
        buttonLabel = "Browse...",
        placeholder = "No file selected"
      )
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Age Sq - Int",
                 verbatimTextOutput("out1")),
        tabPanel("Age Sq - No Int",
                 verbatimTextOutput("out2")),
        tabPanel("No Age Sq - Int",
                 verbatimTextOutput("out3")),
        tabPanel("No Age Sq - No Int",
                 verbatimTextOutput("out4")),
      )
    )
  )
)

# Generate output
server = function(input, output, session) {

  ## Reactive dataframe when the uploaded company is the reference
  df = reactive({
    req(input$file)
    df = read.csv(input$file$datapath)
    ### Replace spaces with periods in column names
    colnames(df) = gsub(" ", ".", colnames(df))
    ### Create Age Squared column
    df$Age.Sq = df$Age ^ 2
    return(df)
  })

  ## Age Sq - Int
  out1 = reactive({
    FL_local_summary(
      Billing.Amount ~ Age + Age.Sq + Gender + Medical.Condition + Admission.Type + Medication + length.of.stay + Medical.Condition:length.of.stay,
      df()
    )
  })

  ## Age Sq - No Int
  out2 = reactive({
    FL_local_summary(
      Billing.Amount ~ Age + Age.Sq + Gender + Medical.Condition + Admission.Type + Medication + length.of.stay,
      df()
    )
  })

  ## No Age Sq - Int
  out3 = reactive({
    FL_local_summary(
      Billing.Amount ~ Age + Gender + Medical.Condition + Admission.Type + Medication + length.of.stay + Medical.Condition:length.of.stay,
      df()
    )
  })

  ## No Age Sq - No Int
  out4 = reactive({
    FL_local_summary(
      Billing.Amount ~ Age + Gender + Medical.Condition + Admission.Type + Medication + length.of.stay,
      df()
    )
  })

  output$out1 = renderPrint(out1())
  output$out2 = renderPrint(out2())
  output$out3 = renderPrint(out3())
  output$out4 = renderPrint(out4())
}

shinyApp(ui, server)
