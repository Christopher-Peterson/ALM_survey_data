
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
  list(
    #' add an error to the log
    #' @param cnd a condition thrown by log_error()
    add = \(cnd) {
      conditions[[length(conditions) + 1]] <<- cnd
      zap()
    },
    #' Format conditions and output as a json file; delete the json file if the log is empty
    #' @param in_file name of the input excel file
    #' @param colname_key read in colname file from the yaml metadata
    #' @param log_dir directory to save logs
    write = \( in_file, colname_key, log_dir = log_dir$late)  {
      # log_dir_late is a 
      log_file = glue("{log_dir}/parsing_{word(basename(in_file), 1)}.json")
      
      if(length(conditions) == 0) {
        file.remove(log_file) |> suppressWarnings()
        return(invisible())
      }
      reverse_colname_key = reverse_column_table(colname_key, in_file)
      # Now do something w/ the error logs, add year and in_file, format them, and print...
      log_subtypes = conditions |> map_chr('subtype')
      log_data = list(in_file = in_file,  logs = conditions |> map(\(x){
        out = x[c('message', 'data')]
        if('column' %in% names(out$data)){ 
          out$data = left_join(out$data, colname_key_tbl, by = 'column') |> 
            relocate(rows, raw_column, column, everything())
        } 
        out}) |> set_names(log_subtypes))
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