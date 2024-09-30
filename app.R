# Load required libraries
# library(shiny)
# library(rlang)
# # library(shinythemes)
# library(readxl)
# library(purrr)
# library(gt)
# library(dplyr)
# library(tidyr)
# library(stringr)
# library(archive)
# 
# Define UI ####
ui <- fluidPage(
  # theme = shinytheme("flatly"),
  
  # App title
  titlePanel("Upload & Validate Raw ALM Data"),
  
## Sidebar layout with input and output definitions ####
  sidebarLayout(
    sidebarPanel(
      ### File Upload ####
      fluidRow(
        radioButtons("period", "Sampling Period (This currently does nothing)", 
                     choiceNames = c('Late', 'Early'), choiceValues = c('late', 'early'))),
        fileInput("files", "Upload Excel files from one sample period", 
                  accept = ".xlsx", multiple = TRUE),
      ### Canonical Download ####
      uiOutput('canonical_download')
      
        # "Canonical Data Download", # Finish this
    ),
## Main Panel, which switches between different options ####    
    mainPanel(
      tabsetPanel(
        id = 'switcher', type = 'hidden',
        tabPanelBody('panelNull', h2('Upload Excel files with raw ALM data to begin'),  
                     p('You can select multiple files to upload at once by using shift or control.')),
        tabPanelBody('panelErrors', 
                     style = "height: 90vh; overflow-y: auto;",  # This should (in theory) enable a scrollbar
                     h2("Errors or issues detected with the uploaded data."),
                     p("Please correct these errors and and re-upload."),
                     # Add a link to download...
                     "You can download a copy of this report ", 
                     downloadLink('error_report_dl', 'here.'),
                     htmlOutput('error_report')
                     # THIS IS WHERE YOU add in the actual errors.
                      # "Link to Open in New Window"
                     ),
        tabPanelBody('panelDownload', h2("No Errors Detected"),
                     p("All validations have been passed. You can download the canonical data from the sidebar."),
                     h3('Uploading canonical data to the repository'),
                     p('Download and unzip the canonical data, then go to the ', 
                       a('canonical_data', href = 'github.com'),
                       ' directory in the repository.  Click on "Upload Files", and select all of the csv files you unzipped.'),
                     # update this part
                     p('Enter a quick description in the "commit" field, such as "added 2024 data" or "fixed data for new validation rules"',
                       'then click "commit"')
                     # Throw in some images...
                     ) 
      )
      # I want to show the errors here
      
      # Download Error Log (or open in new tab?)
      # If no errors, display th e
      # Download Canonical Data
      # Instructions for how to fix the canonical data
      
      # tableOutput("contents")
    )
  )
)
# Helper Function for parsing; consider moving to script####
parse_late_excel_files = \(files_df, .colname_key) {
  
  
  output_data = withProgress(
    pmap(files_df, \(...) {
        nm = list(...)$name
        incProgress(amount = 1/(nrow(files_df) + 1), detail = nm) 
        clean_late_datasheet_shiny(..., colname_key = .colname_key )
        })|> 
      set_names(files_df$name) |> 
      transpose(), 
    message = "Parsing and Validating:"
  )
  
  # Clean up report
  # Discard the null logs

  output_data$report = output_data$report |> purrr::discard(\(x) x$logs |> is.null() )
  if(length(output_data$report) == 0) output_data$report = NULL # make falsy

  output_data
}

colname_key =  if_else(file.exists('column_names.yaml'), 'column_names.yaml',  
                         'https://raw.githubusercontent.com/Christopher-Peterson/ALM_survey_data/refs/heads/main/column_names.yaml') |> 
  yaml::read_yaml()


# Server Definition ####
server <- function(input, output, session) {
  # Read colnames key
  # colname_key = reactive(yaml::read_yaml(colnames_yaml)
  ## Read CSV file ####
  uploaded_data <- reactive({
    req(input$files)
    # input$files$name is the input filename;
    # input$files$datapath is where the actual file is
    # I'll need to tweak the reading function to handle that...
    parse_late_excel_files(input$files, colname_key)
 })
 
  ## Determine which page to display ####
  display_state = reactive(case_when(
    !isTruthy(input$files) ~ 'panelNull',
    isTruthy(uploaded_data()$report) ~ 'panelErrors',
    !isTruthy(uploaded_data()$report) ~'panelDownload',
    
    TRUE ~ 'something_is_wrong'
  ))
  
  observeEvent(display_state(), {
    updateTabsetPanel(inputId = "switcher", selected = display_state())
    })

  ## Format Error Report ####
  error_report = reactive({
    req(uploaded_data()$report)
    start_level = 3
    # Tidy it
    # report_tbl = uploaded_data()$report |> map('logs') |> 
    #   imap_dfr(\(x, fl) tibble(file = fmt_title_md(fl, start_level), !!!transpose(x)) |> unchop(message) ) 

    gt_table = uploaded_data()$report |> map('logs') |> 
      imap_dfr(\(x, fl) {
        gt_list = tibble(!!!transpose(x)) |> unchop(message) |> 
          pmap(\(message, data) data |> gt(groupname_col = 'rows', row_group_as_column = TRUE, caption = message) |>
                 tab_stubhead('Rows')) 
        # browser()
        tibble(file = fl, html = map_chr(gt_list, as_raw_html, inline_css = FALSE) |> paste(collapse = ' <br> '))
      })
    
    html_output = gt_table |>
      arrange(file) |> 
      mutate(file = map_chr(file, \(x) x |> fmt_title_md(start_level) |> shiny::markdown())) |> 
      # select(file, gt_html) |> 
      glue::glue_data("{file} {html} <br>") |> 
      as.character() |> paste(collapse = '<br>')
    # browser()
    html_output
  })
  output$error_report = error_report
  output$error_report_dl <- downloadHandler(
    filename =  "alm_data_error_report.html",
    content = function(file) {
      write_lines(error_report(), file)
    }
  )
  ## Canonical Data Download ####
  canon_dl =  \(file) {
    cur_data = transpose(uploaded_data()$data)# [[nm]]
    temp_dir = tempdir()
    # browser()
    dir.create(file.path(temp_dir, input$period), showWarnings = FALSE)
    data_names = imap(cur_data, \(data, type) {
      year = names(data) |> word(1) 
      glue::glue("{period}/{type}_{year}.csv", period = input$period)
    }) |> unlist()
    withr::with_dir(temp_dir,{
      walk2( list_flatten(cur_data), data_names, write_csv, na = '')
      archive::archive_write_files(file, data_names)
    })
  }
  
  output$canonical_download = renderUI({
    req(uploaded_data()$data)
    # req(display_state()  == 'panelDownload')
    fluidRow(h4("Download Canonical Data"),
             downloadButton('dl_canon', 'Download Zip' ),
             #downloadButton('dl_canon_surface', 'Surface Data')#, disabled = !isTruthy(uploaded_data()$data) )
    )})
  output$dl_canon = downloadHandler(
    'canonical_data.zip', content = canon_dl)
  # output$dl_canon_surface = downloadHandler(
  #   'surface.zip', content = canon_dl('surface'))
  ### Activate the download button(s) ####
  # observe({
  #   req(uploaded_data()$data)
  #   updateActionButton(inputId = 'dl_canon_leaf', disabled = FALSE)
  #   updateActionButton(inputId = 'dl_canon_surface', disabled = FALSE)
  # })
  
  
}



# Run the application
shinyApp(ui = ui, server = server)