# Globals ####
TEMPORARY_FIXES = TRUE # Set to false to disable various temporary fixes; this should only be true during script development
### Set Directories ####
set_direc = \(path) {dir.create(path, recursive = TRUE, showWarnings = FALSE); path }
log_dir_late = 'error_logs/late' |> set_direc()
canonical_dir_late = c('leaf', 'surface', 'larva', 'pupa', 'parasite') |> set_names() |> 
  map(\(x) { file.path('canonical_data/late', x) |> set_direc() })
combined_dir_late = c('leaf_surface') |> set_names() |> 
  map(\(x) { file.path('combined_data/late', x) |> set_direc() })
# Idea for logging issues: 
#   # Start a Logger object (or maybe use rlang conditions) at the beginning of the master function
#   # Define it as a closure.  
#   # All reportable errors are called to the 'call' function in the closure
#   # At the end of the main function, it is 'resolved' and creates an error report if there were any errors called.
#   # If a report is made, it will write out an error yaml JSON, or table
#   
#   

## Define some column types ####
column_types = tibble::lst(
  binary = c('larva_mine_alive', 'larva_mine_dead', 'larva_mine_paras', 'mine_empty',
                'larva_fold_alive', 'larva_fold_dead', 'larva_fold_paras', 
                'pupa_fold_dead', 'pupa_fold_paras', 'pupa_fold_eclose', 'fold_empty', 
                'pupa_fold_alive'),
  # other numeric values
  real = c('efn_n', 'mine_top_perc', 'mine_bttm_perc', 'leaf_missing_perc', 'necr_perc', 'leaf_roll_n',
                'gall_n', 'leaf_width', 'leaf_width_cm', 'blotch_mines_n', 'mine_init_top_n', 'paras_total_n', 'mine_init_bttm_n', 'total_inds_n', 
                'paras_egg_n', 'paras_larva_alive_n', 'paras_pupa_n', 'paras_eclose_n',   'paras_larva_dead_n'),
# numbers that are labels / IDs
  label = c('tree', 'year', 'leaf_position', 'individual', 'row'),
  quantitative = c(binary, real, label),
  # Non numbers
  non_numeric = c('site', 'collection_date', 'recorder', 'leaf_side', 
                       'pupa_mine_site', 'larva_size', 'exo_endo', 'paras_id', 'puncture', 
                       'alm_pupa_id', 'paras_stage','larva_stage',
                       'paras_stage', 'paras_color', 'recorder', 'notes',
                       'pupa_sex', 'possess_intra_comp', 'leaf_missing'),
  leaf = c('leaf_width', 'efn_n', 'mine_top_perc', 
                'mine_bttm_perc', 'leaf_missing_perc', 
                'mine_init_top_n', 'mine_init_bttm_n'),
# Pupa Cols
# parasite_cols
)
column_groups_late  = list(
  leaf_meta = c('year', 'site', 'tree', 'leaf_position'),
  leaf_data = c('leaf_missing', 'leaf_width', 'leaf_width_cm', # Drop this one...
  'efn_n', 'mine_top_perc', 'mine_bttm_perc', 'mine_init_top_n', 
  'mine_init_bttm_n', 'leaf_missing_perc', 'leaf_roll_n', 'gall_n', 
  'blotch_mines_n', 'collection_date'),# Maybe surface-specific?
  # Surface metadata
  surface_meta = c('leaf_side', 'individual'),
  surface_data = c('larva_mine_alive', 'larva_mine_dead', 
  'larva_mine_paras', 'mine_empty', 'larva_fold_alive',
  'larva_fold_dead', 'larva_fold_paras', 'pupa_fold_alive', 'pupa_fold_dead',
  'pupa_fold_paras', 'pupa_fold_eclose', 'fold_empty'),
  pupa_para = c( # This needs revision
    # Pupa Data
    'alm_pupa_id', 'pupa_sex', 'pupal_mass',
    # Ambiguous
    'paras_egg_n', 'paras_larva_alive_n', 'paras_larva_dead_n', 'paras_total_n',
    # Parasite Data
    'paras_id', 'paras_pupa_n', 'paras_eclose_n', 'exo_endo', 'paras_stage', 'paras_color' ),
    # Should add a 'larva_status' column (also pupa_status), indicating parasitism , survival , mortality, etc.
  larva = c('pupa_mine_site', 'alm_mass', 'larva_size', 'larva_stage',  'possess_intra_comp'),
  wtf = c( # No idea what these are
    'total_inds_n', # 2016/2017 only; probably droppable
    'puncture', # only 2014; maybe drop?
    'necr_perc' # 2006-2012
    # These seem to be larva specific data... make them their own table...
  ),
  suffix = c('recorder', 'notes')
)
column_order_late = unlist(column_groups_late) |> unname()

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
with_any_late = with_col_factory(any_of, column_groups_late)
with_all_late = with_col_factory(all_of, column_groups_late)

select_leaf = \(x, ...) { 
  x |> select(with_all_late(leaf_meta), any_of('leaf_id'), ...) }
select_leaf_cols = \(x, ...) { x |> select_leaf(with_any_late(leaf_data), ...) }

group_leaf = \(x, ..., .anyof=character(0)) { 
  x |>  group_by(across(c(with_all_late(leaf_meta), any_of(c('leaf_id', .anyof)), ...))) }
group_leaf_cols = \(x, ..., .anyof=character(0)) { x |>  
    group_leaf(.anyof = c(column_groups_late$leaf_data, .anyof), ...)  }
quant_total = \(df) { df |> 
    mutate(total = across(any_of(column_types$binary)) |> rowSums(na.rm = TRUE)) }
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
  #' read(), which produces the log

make_logger = \(...) {
  conditions = list()
  
  list(
    add = \(cnd) {
      conditions[[length(conditions) + 1]] <<- cnd
      zap()
    },
    read = \() conditions
  )
}
#' Any code run as expr() will pass its logged errors to the logger
#' @param expr an expression/block; usually the main pipeline
#' @param loggger made by make_logger()
with_error_logs = \(expr, logger, ...) {
  rlang::try_fetch(expr, 
    alm_parse_err = logger$add)
}

# Script to format errors as json or yaml?  
## Error formatting helpers ####
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


## Validation Checks ####
# 
#' Creates a new validation function that logs errors
#' @param .id the name/subtype of the error log
#' @param .title the message of the error log
#' @param .transform_fn a function that transforms its inputs for validation checks;
#' @param .check_fn checks the output of .transform_fn and returns a logical vector; if true, adds to the error log
#' @param .return_fn modifies results of .transform_fn for inclusion in error log
#' @return a void function with the same arguments as .transform_fn()
new_validation = \(.id, .title, .transform_fn = identity, .check_fn = \(x) nrow(x) > 0, .return_fn = identity) {
  new_fmls = fn_fmls(.transform_fn) |> names() |> set_names() |>
    map(as.symbol) |>  as.pairlist()
  rlang::new_function(new_fmls, expr({
    transform = .transform_fn(!!!new_fmls)
    if(isTRUE(.check_fn(transform))) log_error(.id, .title, .return_fn(transform))
    invisible(NULL)
  }))
}
### Initial Parsing ####
#' Checks that the quantitiative columns have been parsed to numeric
#' @param parsed_data data that has been parsed
validate_numeric_col_parsing = new_validation(
  'numeric_column_parsing', 'Error validating numeric column parsing',
  \(parsed_data) list(data = parsed_data, valid_numeric = parsed_data |> 
                        select(any_of(column_types$quantitative)) |> map_lgl(is.numeric)),
  \(x) !all(x$valid_numeric),
  \(res) res$data |> select(all_of(names(res$valid_numeric)[!res$valid_numeric])) |> slice(0)
)
#' Verify that the leaf side structure is as expected
  #' If leaf_side is NA, there's no top or bottom records
  #' If there are records on only one side, the other side is omitted (not NA)
  #' This verifies that this structure is present in the data
#' @param parsed_data data that's been parsed
validate_leaf_sides = new_validation(
  'invalid_leaf_side_structure', 'Leaf Side Structure is Invalid',
  \(parsed_data) {
    # For each year * Tree * site * leaf_position, I looked at the first individual (if any)
    # In this case, all of the missing values for leaf_side correspond to a lack of top AND bottom records
    # So this just means that the whole leaf had no records
    # HOWEVER, if one side contains records, there isn't an NA and the other is just omitted
    
    leaf_smry = parsed_data |> group_by(year, site, tree, leaf_position) |>
      filter(individual == min(individual) | is.na(individual)) |>  
      summarize(n_side = n(), top = 'T' %in% leaf_side, 
                bttm = 'B' %in% leaf_side, na = any(is.na(leaf_side)),
                rows = deparse(row));
    both_na_and_tb = leaf_smry |> filter(na, top | bttm)  ; # TRUE if there's an NA and T or B for oen
    one_side_and_tb = leaf_smry |> filter(n_side == 1, !na, (top + bttm) != 1)   # True if there's both 
    bind_rows(both_na_and_tb, one_side_and_tb)
  })

#' Ensures that any NA's in the parsed data were also present in the unparsed data
#' @param parsed_data, unparsed_data the parsed and unparsed data
validate_na_parsing = new_validation(
  'parsing_na',  "NA's induced by parsing",
  \(parsed_data, unparsed_data) {
    n_p = is.na(parsed_data)
    n_u = is.na(unparsed_data)
    
    xor_mask = (n_p | n_u) & (!(n_p & n_u))
    default_cols = c('year', 'row', 'site', 'tree', 'leaf_position', 'leaf_side', 'individual')
    bad_parses = unparsed_data |>
      # mutate(row = 1:n() + 1) |> 
      filter(rowSums(xor_mask) > 0) |> 
      select(any_of(default_cols), all_of(which(colSums(xor_mask) > 0))) ## |> 
      # pivot_longer(all_of(which(colSums(xor_mask) > 0)), names_to = 'column', values_to = 'value') |>
      # filter(value ==1) |> select(-value)
    # Think of a more clever way to express this, w/ only bad cols
     bad_parses
  } # other fn_args default
)
#' Checks if any of the names in the data sheet are unknown
#' @param raw_data raw data file
validate_unknown_names = new_validation(
  'unknown_names', 'Names in data file not defined in column_names.yaml',
  \(raw_data, colname_key) {
    names(raw_data) |> 
      discard(\(x) x %in% unlist(colname_key) | substr(x, 1, 3) == '...') |> 
      tibble(unknown_names = _)
  }
)
### Data QC ####
#' Checks that the binary columns only have a single 1 in them for each row
#' @param parsed_data parsed data
validate_single_binary_col = new_validation(
  'multiple_binary_rows', 'Multiple binary columns in one row',
  \(parsed_data) parsed_data |>  quant_total() |> 
      # mutate(row = 1:n() + 1) |>  
    filter(total > 1), # Based on a positive quant_total
  .return_fn = \(bad_vals) {
    default_cols = c('site', 'tree', 'leaf_position', 'leaf_side', 'individual')
    bad_vals |> select(row, total,  any_of(column_types$binary) & where(\(x) any(x > 1, na.rm = TRUE) ),
                       any_of(default_cols))
      
  }
)
#' Check if each leaf has only one collection date recorded
#' @param parsed_data parsed data
validate_one_collection_date = new_validation(
  'multiple_collection_dates',  "Multiple collection dates per leaf",
  \(parsed_data) parsed_data |>  group_leaf() |>
    summarize(n_collect = n_distinct(collection_date)) |> 
    ungroup() |> filter(n_collect > 1) )

validate_sites = new_validation(
  'valid_sites', 'Invalid site name',
  \(parsed_data) parsed_data |> select(row, site) |> 
    filter(!toupper(site) %in% c('BNZ', 'RP', "WR", "ED"))
)


### Leaf mismatches (requires return value) ####

resolve_leaf_mismatches = \(parsed_data) {
  # browser()
  leaf_data = parsed_data |>  select_leaf_cols(row) |> 
    group_leaf() |>  mutate(rows = deparse(row)) |> 
    select(-row) |> ungroup() |>  distinct()
  drange = \(x) diff(range(x, na.rm = TRUE) |> suppressWarnings() |> na_inf())
  leaf_repeats = leaf_data |> group_leaf(rows) |> 
    summarize(repeats = n(), 
              top_range = drange(mine_top_perc),
              bttm_range = drange(mine_bttm_perc),
              missing_range = drange(leaf_missing_perc),
              top_init_range = drange(mine_init_top_n),
              bttm_init_range = drange(mine_init_bttm_n),
              date_range = drange(collection_date)
    ) |> ungroup() |>  filter(repeats > 1) |> 
    left_join(leaf_data) |>  group_leaf() |> 
    mutate(multi_leaf = n_distinct(leaf_width) > 1 | n_distinct(efn_n) > 1) |> 
    ungroup() 
  # small difference repeats are only different in mining/missing percentages, 
  # and those differences are within 2%; they get averaged
  small_leaf_repeats = leaf_repeats |> 
    filter(top_range <= 2.5,  bttm_range <= 2.5, missing_range <= 2.5, 
           top_init_range == 0, bttm_init_range == 0, date_range <= days(1),
           !multi_leaf) |> 
    select(-repeats, -ends_with('_range'), -multi_leaf) 
  large_leaf_repeats = leaf_repeats |> 
    anti_join(small_leaf_repeats |> select_leaf()) |> 
    select(-repeats, -ends_with('_range'), -multi_leaf) 

    check_small_repeats = new_validation('leaf_mismatch_small', 
                 'Leaves with minor data conflicts among rows; these will be averaged for now.',
                 .return_fn = \(x) x |> group_leaf() |> df_unique_columns() )
    check_large_repeats = new_validation('leaf_mismatch_large', 
                 'Leaves with major data conflicts among rows; these will be dropped for now.',
                 .return_fn = \(x) x |> group_leaf() |> df_unique_columns() )
  check_small_repeats(small_leaf_repeats)
  check_large_repeats(large_leaf_repeats)
  if(TEMPORARY_FIXES) {
# browser()
    
    # What's the current issue?
    #   Non numerics getting averaged
    
    small_diff_replacements = small_leaf_repeats |> group_leaf() |> 
      summarize(across(any_of('collection_date'), 
                       # Some collection dates are missing; this keeps min() from making them Inf and keeps them quiet
                       \(d) min(d, na.rm = TRUE) |> suppressWarnings() |> na_inf() ),
        across(with_any_late(leaf_data) & where(is.numeric), 
               \(x) mean(x, na.rm = TRUE ))) |> 
      left_join(parsed_data |> select(-with_any_late(leaf_data))) |> 
      ungroup()
    # Remove the bad leaf repeats
    nonbad_data = parsed_data |> 
      # replace small difference data with leaf-averaged version
      anti_join(small_leaf_repeats |> select_leaf()) |> bind_rows(small_diff_replacements) |> 
      # remove the bad leaf duplicates
      anti_join(large_leaf_repeats |> select_leaf() |> distinct())
    # These numbers should add up:
    check_dropping_large_repeats = new_validation('leaf_mismatch_drop_check',
              'Mismatch detected when dropping leaves w/ large mismatches',
              \(nonbad_data) list(expected = nrow(parsed_data) - 
                       nrow(large_leaf_repeats |> select_leaf() |> 
                          distinct() |> left_join(parsed_data)),
                     observed = nrow(nonbad_data)),
              \(x)  x$observed != x$expected)
    check_dropping_large_repeats(nonbad_data)
    parsed_data = nonbad_data
  }
  parsed_data
}

### During Canonicalization ####
validate_individual_numbers = new_validation(
  'unique_individual_numbers', "Individuals are not unique within a leaf surface",
  \(surface_data_binary) {     surface_data_binary |> 
    group_by(leaf_id, leaf_side) |> 
    summarize(rows = deparse(row), n_rows = n(), n_individuals = n_distinct(individual),
              individuals = paste(individual, collapse = ','), .groups = 'drop')  |> 
    filter(n_rows != n_individuals) |> 
    select(rows, individuals, leaf_id, leaf_side)
  })

# Read and format the data ####
#' Make sure all columns in `column_order` are present and in the correct order
#' This assumes that no extra columns exist; that error should be handled in `read_late_data()`
standardize_col_order = \(df, column_order = column_order_late) {
  present_cols = names(df)
  missing_cols = column_order[!column_order %in% present_cols] |> set_names()
  # If any columns are missing, add them as NA's
  if(length(missing_cols) > 0) df = df |> mutate(!!!(map(missing_cols, \(x) NA_character_)))
  df |> relocate(all_of(column_order))
}
#' Read the data in from an excel file; standardize the column names
read_late_data = \(file, colname_key) {
  # browser()
  year = basename(file) |> word(1)
  
  raw_data = read_excel(file, 1, col_type = 'text', na = c('.', '?', '')) 
  # Check for unknown names
  validate_unknown_names(raw_data, colname_key)
  
  renamed_data = raw_data |> select(!!!map(colname_key, any_of))
  
  # The date column will be formatted in excel's internal format; this fixes that
  date_col = which(names(raw_data) %in% colname_key$collection_date)
  # date_col = which(names(renamed_data) == 'collection_date') # which(raw_names %in% date_columns)
  # browser()
  date_fixed = read_excel(file, 1, range = cell_cols(date_col), 
                          col_types = 'date')
  # Re-insert it into the  df
  data_combined = renamed_data |> 
    mutate(year = as.integer(year)) |> relocate(year, everything()) |> 
    # Fix collection date
    mutate(collection_date = date_fixed[[1]]) |> 
    select(-starts_with('drop'), 
           -any_of('Year'),# Some had Year as an extra
           -starts_with('...') # Removes unnamed extra columns
    ) 
  dat_names = names(data_combined)
  
  if('leaf_width_cm' %in% dat_names) {
    # For some leaf width, there are "X2" notes, which indicate that half the
    #  leaf was measured & total width is double, due to damage
    # it only appears to be in leaf_width_cm
    double = \(x) as.character(parse_numeric(x)*2)
    data_combined = data_combined |> 
      mutate(leaf_width_cm = if_else(!str_detect(leaf_width_cm, "X2$"), leaf_width_cm,
                                     str_remove(leaf_width_cm, "X2$") |> double() ))
  }
  
  
  data_combined |> standardize_col_order(column_order = column_order_late) |> 
    ungroup() |> mutate(row = as.integer((1:n())+1L)) # +1 makes it concordant w/ Excel
}
#' Parse the data created by `read_late_data()`
parse_late_data = \(data_combined) {
  data_parsed = data_combined |> 
    mutate(across(!any_of(column_types$non_numeric), parse_numeric),
           across(any_of(column_types$non_numeric), toupper)) |> 
    mutate(row = as.integer(row))
  
  validate_leaf_sides(data_parsed)
  validate_na_parsing(data_parsed, data_combined |> mutate(row = as.integer(row)))
  validate_single_binary_col(data_parsed)
  validate_sites(data_parsed)
  
  if(any(names(data_parsed) == 'leaf_width_cm')) {
    data_parsed = data_parsed |> 
      mutate(leaf_width = coalesce(
        # calling data_parsed directly to extract a NULL from it...
        data_parsed$leaf_width, leaf_width_cm * 10)) |> 
      select(-leaf_width_cm)
  }
  
  out = data_parsed |> 
    # Fix the date issues
    mutate(collection_date = collection_date |> 
             # Convert to a date
             ymd() |> set_year(year)) |> 
    mutate(leaf_side = toupper(leaf_side))
  if(TEMPORARY_FIXES) {
    out = out |> mutate(
      # One observation is missing a date; the subsequent row was collected at the same time.
      collection_date = collection_date |> coalesce(lead(collection_date)),
      # Fix a missing value in 2007:
      site = if_else(is.na(site) & year == 2007, 'BNZ', site))
    }
  out
}

# Canonicalize formats  ####
canonical_leaf_late = \(keyed_data) {
  
  leaf_rows = keyed_data |> #mutate(row = 1:n()) |> 
    select(leaf_id, row) |> 
    group_by(leaf_id) |> 
    summarize(rows = deparse(row) |> str_remove('L'), .groups = 'drop')
  # notes_data = keyed_data |> filter(!is.na(notes)) |> select() # I should do something to save the notes...
  leaf_nested = keyed_data |>  group_leaf_cols() |> nest() 
  leaf_canonical = leaf_nested |> select(-data) |> relocate(leaf_id, everything())
  
  # Check for duplicates; THIS SHOULD BE COVERED EARLIER!
  # leaf_dups = leaf_canonical |> group_by(leaf_id) |> 
  #   summarize(n_dup = n(), .groups = 'drop') |> 
  #   filter(n_dup > 1) |> left_join(leaf_canonical, by = 'leaf_id') |> 
  #   left_join(leaf_rows, by = 'leaf_id')
  # # Why are the earlier duplication checks not catching this??
  # if(nrow(leaf_dups) > 0) {
  #   browser()
  #   leaf_dup_table = leaf_dups |> group_leaf() |> df_unique_columns()
  #   # Fail with, but also report other duplicates
  #   if(TEMPORARY_FIXES) { # Enabled only so I can ignore issues and keep developing
  #     # keyed_data = keyed_data |> anti_join(leaf_dup_table |> select(leaf_id), by = 'leaf_id')
  #     leaf_canonical = leaf_canonical |>  anti_join(leaf_dup_table |> select(leaf_id), by = 'leaf_id')
  #   } else {
  #     # Error report
  #     browser()
  #     stop("Add error handling here")
  #   }
  # }
  leaf_canonical
}

#' Get canonical data 
prep_surface_binary = \(keyed_data) {
  surface_data_binary = keyed_data |> 
    select(leaf_id, surface_id, with_any_late(surface_meta, surface_data), row) |> 
    filter(!is.na(leaf_side))
  # Check for duplicated individuals
  validate_individual_numbers(surface_data_binary)
  surface_data_binary
}

canonical_surface_counts = \(leaf_canonical, surface_data_binary) {
  # Now I want a version of clean_leaf_data that has information on both sides
  # Some tops/bottoms are missing (or both are)
  # 1. Filter out the NA sides
  # 2. Group by leaf_id:side and sum over all binary columns
  # 3. Left join the scaffold summed data, then fill NA's in binary rows w/ zeroes
  surface_scaffold = leaf_canonical |> ungroup() |>  select(leaf_id) |> 
    mutate(leaf_side = rep(list(c('T', 'B')), n())) |> 
    unchop(leaf_side) |> 
    # This code needs to be repeated here, unfortunately...
    mutate(surface_id = str_replace(leaf_id, 'leaf_', 'surface_') |> paste(leaf_side, sep = '_')) 
  
  surface_data_counts = surface_data_binary |> 
    group_by(leaf_id, leaf_side) |> 
    # Count the columns & rename them
    summarize(across(any_of(column_types$binary), 
                     \(x) sum(x, na.rm = TRUE), 
                     .names = "{.col}_n"), .groups = 'drop')
  
  surface_canonical = surface_scaffold |> 
    left_join(surface_data_counts, by = c('leaf_id', 'leaf_side')) |> 
    mutate(across(any_of(paste0(column_types$binary, '_n')), 
                  \(x) replace_na(x, 0))) |> 
    relocate(surface_id)
  # Validations: 
  if(nrow(surface_scaffold) != nrow(surface_canonical)) {
    log_error('canonical_surface_error', "Error while joining the canonical surface data",
              surface_canonical |> group_by(surface_id) |> mutate(rows = '') |> 
                filter(n() > 1) |> df_unique_columns() |> select(-rows))
  }
  surface_canonical
}


make_canonical_forms_late = \(cleaned_data) {
  keyed_data = cleaned_data |> 
    mutate(leaf_id = paste("leaf", year, site, tree, leaf_position, sep = '_'),
           surface_id = str_replace(leaf_id, 'leaf_', 'surface_') |> paste(leaf_side, sep = '_')
    )
  leaf_canonical = canonical_leaf_late(keyed_data)
  if(TEMPORARY_FIXES) { # If some leaves were dropped, drop them here as well
    keyed_data = keyed_data |> left_join(leaf_canonical |> select(leaf_id))
  }
  # notes_data = keyed_data |> filter(!is.na(notes)) |> select() # I should do something to save the notes...
  surface_data_binary = prep_surface_binary(keyed_data)
  surface_canonical = canonical_surface_counts(leaf_canonical, surface_data_binary)
  # if(TEMPORARY_FIXES) # FIGURE OUT WHAT TO DO
  # TEMPORARY EXIT: 
  return(list(leaf = leaf_canonical, surface = surface_canonical))
  {
  # # Convert state from a 1/0 matrix to a character vector
  # indiv_states = surface_data_binary |> ungroup() |> 
  #   mutate(state =  across(column_types$binary) |>  
  #             imap(\(val, name) if_else(val == 1,  name, NA_character_)) |>  
  #             reduce(coalesce)) |> 
  #   select(surface_id, state) |> 
  #   mutate(ind_row = 1:n())
  # 
  # # Next: Pupa and larva Data!
  # indiv_data = keyed_data |> filter(!is.na(leaf_side)) |> 
  #   select(surface_id, with_any_late(surface_data, pupa_para, larva )) |> 
  #   mutate(ind_row = 1:n()) |> 
  #   left_join(indiv_states)
  # 
  # # Not sure how to handle this rn...  
  # browser()
  # larva_data = indiv_data |> select(surface_id, ind_row, state, with_any_late(larva)) |> 
  #   filter(!is.na(alm_mass) | !is.na(larva_size) | !is.na(larva_stage) | !is.na(possess_intra_comp))
  # indiv_data |> select(surface_id, ind_row, state, with_any_late(larva)) |> filter(pupa_mine_site == 'Y')
  # 
  # 
  # 
  #   
  # pupa_data_raw = indiv_data |> select(suirface_id, all_of())
  }
}

write_canonical_forms_late = \(canonical_data_list) {
  year = canonical_data_list$leaf$year[1]
  output_files = imap(canonical_dir_late, 
                      \(x, nm) file.path(x, glue("{nm}_{year}.csv")))
  iwalk(canonical_data_list, \(df, nm) write_csv(df, output_files[[nm]], na = ''))
}

# Parse, Clean, Validate, and Canonicalize one data sheet; write output files ####
clean_late_datasheet = \(in_file, colname_yaml = 'column_names.yaml') {
  
  error_log = make_logger()
  colname_key = yaml::read_yaml(colname_yaml)
  
  canonical_data = with_error_logs({
    parsed_data = in_file |> 
      read_late_data(colname_key) |> parse_late_data()  |> 
      resolve_leaf_mismatches()
  
    validate_one_collection_date(parsed_data)
    # identify_multi_binary(parsed_data)
    parsed_data |> make_canonical_forms_late() 
  }, logger = error_log)
  
  log_conditions = error_log$read()
  log_file = glue("{log_dir_late}/parsing_{word(basename(in_file), 1)}.json")
  
  if(length(log_conditions) > 0) {
    raw_colnames = read_excel(in_file, n_max = 0) |> names()
    colname_key_tbl = imap_dfr(colname_key, \(raw_column, column) tibble(column, raw_column)) |> 
      filter(raw_column %in% raw_colnames) |> 
      mutate(column = if_else(column == 'leaf_width_cm', 'leaf_width', column))
    
    # Now do something w/ the error logs, add year and in_file, format them, and print...
    log_subtypes = log_conditions |> map_chr('subtype')
    log_data = list(in_file = in_file,  logs = log_conditions |> map(\(x){
                      out = x[c('message', 'data')]
                      if('column' %in% names(out$data)){ 
                        out$data = left_join(out$data, colname_key_tbl, by = 'column') |> 
                          relocate(rows, raw_column, column, everything())
                        } 
                      out}) |> set_names(log_subtypes))
    jsonlite::write_json(log_data, log_file)
  } else {
    file.remove(log_file) |> suppressWarnings()
  }
  
  # Write output files...
  canonical_data |> write_canonical_forms_late()
}

# Combine cleaned files ####
#' Combine canonical files
#' @param in_dir directory of the canonical files
make_all_year = \(in_dir) {
  in_files = file.path(in_dir, dir(in_dir, pattern = '20[0-9][0-9].csv'))
  read_csv(in_files) |> write_csv(paste0(in_files, '_allyears.csv'))
}
#' Combine and export the leaf and surface data
combine_leaf_surface = \(leaf_file, surface_file) {
  leaf_in = read_csv(leaf_file)
  surface_in = read_csv(surface_file)
  left_join(leaf_in, surface_in, by = 'leaf_id')
  write_csv(combined_dir_late$leaf_surface, na = '')
}

# Parse and display error logs





