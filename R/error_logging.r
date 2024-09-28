
# Error Logging ####
# The idea here is that there's an error logger that sits back and captures the 
# specific errors that are detected in the validate_() script, along with their metadata
# Once the main script is done, it produces all of them and saves them as a JSON file for reporting 

#' Throw an error to the logger
#' @param subtype the internal name of the error
#' @param title the user-visible description
#' @param data metadata to include in the report
log_error = \(subtype, title, data, ...) {
  rlang::signal(title, class = 'alm_parse_err', subtype = subtype, data = data, ...)
}
#' Make a logging closure
#' The logger is declared, then passed to with_error_logs()
#' It has two methods: 
#' add(), which adds a condition to the internal log
#' write(), which formats and write all of the errors to a json file, or deletes pre-existing json files if there aren't any.
make_logger = \(...) {
  conditions = list()
  lst(
    #' add an error to the log
    #' @param cnd a condition thrown by log_error()
    add = \(cnd) {
      conditions[[length(conditions) + 1]] <<- cnd
      zap() # Prevents condition from causing an error
    },
    report = \(in_file, colname_key)  {
      # log_dir_late is a 
      if(length(conditions) == 0) {
        logs = NULL
      } else {
        
        reverse_colname_key = reverse_column_table(colname_key, in_file)
        # Now do something w/ the error logs, add year and in_file, format them, and print...
        log_subtypes = conditions |> map_chr('subtype')
        logs = conditions |> map(\(x){
          out = x[c('message', 'data')]
          if('column' %in% names(out$data)){ 
            out$data = left_join(out$data, reverse_colname_key, by = 'column') |> 
              relocate(rows, raw_column, column, everything())
          } 
          out}) |> set_names(log_subtypes)
      }
      list(in_file = in_file, logs = logs)
    },
    #' Format conditions and output as a json file; delete the json file if the log is empty
    #' @param in_file name of the input excel file
    #' @param colname_key read in colname file from the yaml metadata
    #' @param log_dir directory to save logs
    write = \( in_file, colname_key, log_dir = log_dir$late)  {
      # log_dir_late is a 
      log_file = glue("{log_dir}/parsing_{word(basename(in_file), 1)}.json")
      
      log_data = report(colname_key)
      
      if(is.null(log_data)) {
        file.remove(log_file) |> suppressWarnings()
        return(invisible())
      }
      jsonlite::write_json(log_data, log_file)
    }
  )
}
#' Any code run as expr() will pass its logged errors to the logger
#' @param expr an expression/block; usually the main pipeline
#' @param loggger made by make_logger()
with_error_logs = \(expr, logger, ...) {
  rlang::try_fetch(expr, 
                   alm_parse_err = logger$add)
}


# Parse Logs ####
parse_error_reports = \(reports, excel_files) {
  # browser()
  # raw_in = file_list |> map(jsonlite::read_json, simplifyVector = TRUE)
  # excel_files = map_chr(raw_in, 'in_file') |> basename()
  # Structure the logs so that the hierarchy is (sheet: then message and data, which )
  # error_logs = #map(raw_in, 'logs') |> 
  reports |> 
    set_names(excel_files) |> 
    imap_dfr(\(x, fl) tibble(file = fl, !!!transpose(x)) |> unchop(message)) 
  # error_logs
}
# fmt_title_md = \(x, n) {
#   hash = rep('#', n) |> paste(collapse = '')
#   paste0('\n\n', paste(hash, x), '\n\n')
# }
fmt_error_reports_md = \(parsed_log, start_level = 2) {
  
  chopped_log = parsed_log |> 
    # Format titles
    mutate(file = fmt_title_md(file, start_level)) |> #, message = fmt_title_md(message, start_level + 1L)) |> 
    group_by(file) |> 
    nest()  
  
  # Think about a better way to format it...
  
  # chopped_log |> pwalk(\(file, data) {
  #   # browser()
  #   cat(file); 
  #   data |> pwalk(\(message, data) {
  #     cat(message)
  #     knitr::kable(data) |> print()
  #   })
  # })
}