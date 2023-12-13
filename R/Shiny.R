# UPDATE BEFORE RUNNING: number of insurance companies - 1
num = 4


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
        tabPanel("Ref - Age - Int",
                 verbatimTextOutput("out1")),
        tabPanel("Ref - Age - No Int",
                 verbatimTextOutput("out2")),
        tabPanel("Ref - Age Sq - Int",
                 verbatimTextOutput("out3")),
        tabPanel("Ref - Age Sq - No Int",
                 verbatimTextOutput("out4")),
        tabPanel("Not Ref - Age - Int",
                 verbatimTextOutput("out5")),
        tabPanel("Not Ref - Age - No Int",
                 verbatimTextOutput("out6")),
        tabPanel("Not Ref - Age Sq - Int",
                 verbatimTextOutput("out7")),
        tabPanel("Not Ref - Age Sq - No Int",
                 verbatimTextOutput("out8"))
      )
    )
  )
)

# Generate output
server = function(input, output, session) {

  ## Reactive dataframe when the uploaded company is the reference
  df.ref = reactive({
    req(input$file)
    df = read.csv(input$file$datapath)
    ### Replace spaces with periods in column names
    colnames(df) = gsub(" ", ".", colnames(df))
    ### Create Age Squared column
    df$Age.Sq = df$Age ^ 2
    ### Create columns for Insurance Providers
    ins.cols = paste("Insurance.Provider", 1:num, sep = "")
    for (j in ins.cols) {
      df[[j]] = 0
    }
    return(df)
  })

  ## Reactive dataframe when the uploaded company is not the reference
  df.notref = reactive({
    df = df.ref()
    ### Change Insurance.Provider1 to 1 when the uploaded company is not the reference
    df$Insurance.Provider1 = 1
    return(df)
  })

  ## Ref - Age - Int
  out1 = reactive({
    FL_local_summary(
      Billing.Amount ~ Age + Gender + Medical.Condition + Admission.Type + Medication + length.of.stay + Insurance.Provider1 + Insurance.Provider2 + Insurance.Provider3 + Insurance.Provider4 + Medical.Condition:length.of.stay,
      df.ref()
    )
  })

  ## Ref - Age - No Int
  out2 = reactive({
    FL_local_summary(
      Billing.Amount ~ Age + Gender + Medical.Condition + Admission.Type + Medication + length.of.stay + Insurance.Provider1 + Insurance.Provider2 + Insurance.Provider3 + Insurance.Provider4,
      df.ref()
    )
  })

  ## Ref - Age Sq - Int
  out3 = reactive({
    FL_local_summary(
      Billing.Amount ~ Age + Age.Sq + Gender + Medical.Condition + Admission.Type + Medication + length.of.stay + Insurance.Provider1 + Insurance.Provider2 + Insurance.Provider3 + Insurance.Provider4 + Medical.Condition:length.of.stay,
      df.ref()
    )
  })

  ## Ref - Age Sq - No Int
  out4 = reactive({
    FL_local_summary(
      Billing.Amount ~ Age + Age.Sq + Gender + Medical.Condition + Admission.Type + Medication + length.of.stay + Insurance.Provider1 + Insurance.Provider2 + Insurance.Provider3 + Insurance.Provider4,
      df.ref()
    )
  })

  ## Not Ref - Age - Int
  out5 = reactive({
    FL_local_summary(
      Billing.Amount ~ Age + Gender + Medical.Condition + Admission.Type + Medication + length.of.stay + Insurance.Provider1 + Insurance.Provider2 + Insurance.Provider3 + Insurance.Provider4 + Medical.Condition:length.of.stay,
      df.notref()
    )
  })

  ## Not Ref - Age - No Int
  out6 = reactive({
    FL_local_summary(
      Billing.Amount ~ Age + Gender + Medical.Condition + Admission.Type + Medication + length.of.stay + Insurance.Provider1 + Insurance.Provider2 + Insurance.Provider3 + Insurance.Provider4,
      df.notref()
    )
  })

  ## Not Ref - Age Sq - Int
  out7 = reactive({
    FL_local_summary(
      Billing.Amount ~ Age + Age.Sq + Gender + Medical.Condition + Admission.Type + Medication + length.of.stay + Insurance.Provider1 + Insurance.Provider2 + Insurance.Provider3 + Insurance.Provider4 + Medical.Condition:length.of.stay,
      df.notref()
    )
  })

  ## Not Ref - Age Sq - No Int
  out8 = reactive({
    FL_local_summary(
      Billing.Amount ~ Age + Age.Sq + Gender + Medical.Condition + Admission.Type + Medication + length.of.stay + Insurance.Provider1 + Insurance.Provider2 + Insurance.Provider3 + Insurance.Provider4,
      df.notref()
    )
  })

  output$out1 = renderPrint(out1())
  output$out2 = renderPrint(out2())
  output$out3 = renderPrint(out3())
  output$out4 = renderPrint(out4())
  output$out5 = renderPrint(out5())
  output$out6 = renderPrint(out6())
  output$out7 = renderPrint(out7())
  output$out8 = renderPrint(out8())
}

shinyApp(ui, server)
