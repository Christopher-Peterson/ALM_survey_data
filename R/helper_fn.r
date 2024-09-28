
# Helper Functions #### 
#' function factory for creating with_any/all_late/early() functions
#' equivalent to with(dat, fn(c(...))), where fn() is usually any_of() or all_of()
with_col_factory = \(fn, dat) {
  \(...) {
    dots = rlang::enexprs(...)
    .cols = lapply(dots, eval_tidy, data = dat) |> unlist()
    fn(.cols)
  }
}
with_any_late = with_col_factory(any_of, COLUMN_GROUPS_LATE)
with_all_late = with_col_factory(all_of, COLUMN_GROUPS_LATE)

select_leaf = \(x, ...) { 
  x |> select(with_all_late(leaf_meta), any_of('leaf_id'), ...) }
select_leaf_cols = \(x, ...) { x |> select_leaf(with_any_late(leaf_data), ...) }

group_leaf = \(x, ..., .anyof=character(0)) { 
  x |>  group_by(across(c(with_all_late(leaf_meta), any_of(c('leaf_id', .anyof)), ...))) }
group_leaf_cols = \(x, ..., .anyof=character(0)) { x |>  
    group_leaf(.anyof = c(COLUMN_GROUPS_LATE$leaf_data, .anyof), ...)  }
quant_total = \(df) { df |> 
    mutate(total = across(any_of(COLUMN_TYPES$binary)) |> rowSums(na.rm = TRUE)) }
set_year = \(x, yr) {   year(x) = yr;   x }

drop_null_cols = \(dat) {
  null_columns = map_lgl(dat, \(x) all(is.na(x))) |> which()
  dat |> select(-any_of(null_columns), -starts_with('...')) 
}
na_inf = \(x) {
  y = x
  y[is.infinite(y)] = NA
  mode(y) = mode(x)
  class(y) = class(x)
  y
}
# Go one at a time
parse_numeric = \(x) {
  # List of pattern = replacement for manually fixing some weird entries
  str_replacement_list = c(
    '([0-9])\\.\\.([0-9])' = '\\1\\.\\2', # 2..6 -> 2.6
    '([0-9])\\-' = '\\1', # remove any - not at the beginning
    '`'='', # remove excess backticks
    NULL)
  x |> str_replace_all(str_replacement_list) |> as.numeric()
}


# Error formatting helpers ####
#' Identify which columns in a grouped dataframe are different
#' Returns a long-form data frame
#' Requires a 'rows' column
df_unique_columns = \(grouped_df) {
  chopped_df = grouped_df |> group_by(rows, .add = TRUE) |> 
    chop(-group_cols()) |> 
    # Select columns w/ duplicated values
    select(group_cols(), where(\(x) any(map_int(x, n_distinct) >1)))
  chopped_df |> pivot_longer(-group_cols(), names_to = 'column', 
                             values_to = 'values') |> 
    ungroup() |>  filter( map_int(values, n_distinct) > 1) |> 
    mutate(values = map_chr(values, \(x) paste(x, collapse = ','))) |> 
    relocate(rows, column, values)
}

# Get a table w/ standard and reverse colnames for a specific dataset
#' @param colname_key named list of colname aliases, from the yaml file
#' @param in_file excel file to standardize against
#' @return a tibble w/ columns `column` and `raw_column`
reverse_column_table = \(colname_key, in_file) {
  
  raw_colnames = read_excel(in_file, n_max = 0) |> names()
  imap_dfr(colname_key, \(raw_column, column) tibble(column, raw_column)) |> 
    filter(raw_column %in% raw_colnames) |> 
    mutate(column = if_else(column == 'leaf_width_cm', 'leaf_width', column))
  
}

## Markdown Helpers ####
fmt_title_md = \(x, n) {
  hash = rep('#', n) |> paste(collapse = '')
  paste0('\n\n', paste(hash, x), '\n\n')
}
