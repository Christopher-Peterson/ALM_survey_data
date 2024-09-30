# Globals ####
if(!exists('TEMPORARY_FIXES')) TEMPORARY_FIXES = FALSE # Set to false to disable various temporary fixes; this should only be true during script development


# Read and format the data ####
#' Make sure all columns in `column_order` are present and in the correct order
#' This assumes that no extra columns exist; that error should be handled in `read_late_data()`
standardize_col_order = \(df, column_order = COLUMN_ORDER_LATE) {
  present_cols = names(df)
  missing_cols = column_order[!column_order %in% present_cols] |> set_names()
  # If any columns are missing, add them as NA's
  if(length(missing_cols) > 0) df = df |> mutate(!!!(map(missing_cols, \(x) NA_character_)))
  df |> relocate(all_of(column_order))
}
#' Read the data in from an excel file; standardize the column names


#' Read in the raw excel file, fixing the collection date formatting
#' @param file input excel file
#' @param date_names names of date columns
read_excel_raw = \(file, date_names) {
  # browser()
  raw_names = read_excel(file, 1, n_max= 0) |> names()
  date_col = which(raw_names %in% date_names)
  col_types = rep('text', length(raw_names))
  col_types[date_col] = 'date'
  read_excel(file, 1, range = cell_cols(c(1, length(col_types))), # Cut off unnamed columns
             col_type = col_types, na = c('.', '?', ''))
}

read_late_data = \(file, colname_key, year = basename(file) |> word(1)) {
  
  # year = basename(file) |> word(1)
  
  #raw_data = read_excel(file, 1, col_type = 'text', na = c('.', '?', '')) 
  raw_data = read_excel_raw(file, colname_key$collection_date)
  # Check for unknown names
  
  validate_unknown_names(raw_data, colname_key)
  
  renamed_data = raw_data |> select(!!!map(colname_key, any_of))
  
  # The date column will be formatted in excel's internal format; this fixes that
  # date_col = which(names(raw_data) %in% colname_key$collection_date)
  # date_col = which(names(renamed_data) == 'collection_date') # which(raw_names %in% date_columns)
  # browser()
  # date_fixed = read_excel(file, 1, range = cell_cols(date_col), 
  #                         col_types = 'date')
  # Re-insert it into the  df
  data_combined = renamed_data |> 
    mutate(year = as.integer(year)) |> relocate(year, everything()) |> 
    # Fix collection date
    # mutate(collection_date = date_fixed[[1]]) |> 
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
  
  
  data_combined |> standardize_col_order(column_order = COLUMN_ORDER_LATE) |> 
    ungroup() |> mutate(row = as.integer((1:n())+1L)) # +1 makes it concordant w/ Excel
}
#' Parse the data created by `read_late_data()`
parse_late_data = \(data_combined) {
  data_parsed = data_combined |> 
    mutate(across(!any_of(COLUMN_TYPES$non_numeric), parse_numeric),
           across(any_of(COLUMN_TYPES$non_numeric), toupper)) |> 
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
  # browser()
  # if(as.character(data_parsed$year[1]) == '2007') browser()c
  out = data_parsed |> 
    # Fix the date issues
    mutate(collection_date = collection_date |> 
             # Convert to a date
             # ymd() |>
             set_year(year)) |> 
    mutate(leaf_side = toupper(leaf_side))
  # if(TEMPORARY_FIXES) {
  #   out = out |> mutate(
  #     # One observation is missing a date; the subsequent row was collected at the same time.
  #     collection_date = collection_date |> coalesce(lead(collection_date)),
  #     # Fix a missing value in 2007:
  #     site = if_else(is.na(site) & year == 2007, 'BNZ', site))
  #   }
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
    summarize(across(any_of(COLUMN_TYPES$binary), 
                     \(x) sum(x, na.rm = TRUE), 
                     .names = "{.col}_n"), .groups = 'drop')
  
  surface_canonical = surface_scaffold |> 
    left_join(surface_data_counts, by = c('leaf_id', 'leaf_side')) |> 
    mutate(across(any_of(paste0(COLUMN_TYPES$binary, '_n')), 
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
  #   mutate(state =  across(COLUMN_TYPES$binary) |>  
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

#' Output the canonical data to the disk...
write_canonical_data = \(canonical_data_list, period = c('late', 'early'), base_dir = CANONICAL_DIR) {
  period = match.arg(period)
  year = canonical_data_list$leaf$year[1]
  iwalk(canonical_data_list, \(df, type) {
    file = file.path(base_dir[[period]], glue("{type}_{year}.csv"))
    df |> write_csv(file, na = '')
  })
}

# Parse, Clean, Validate, and Canonicalize one data sheet; write output files ####

# Maybe I should take this file and split it into core functionality and variable functions?
# So that it works w/ shiny and non-shiny versions...
# Yes.


# Internal version, used by both shiny and github versions
#' @param data_file name of input excel file
#' @param year The year the data are from
#' @param colname_key named list with alternate column names
clean_late_datasheet_internal = \(data_file, year, colname_key) {
  
  error_log = make_logger()
  canonical_data = with_error_logs({
    parsed_data = data_file |> 
      read_late_data(colname_key, year) |> parse_late_data()  |> 
      resolve_leaf_mismatches()
    
    validate_one_collection_date(parsed_data)
    # identify_multi_binary(parsed_data)
    parsed_data |> make_canonical_forms_late() 
  }, logger = error_log)
  
  # I need to figure out how to handle writing this...
  error_report = error_log$report(data_file, colname_key)
  list(data = canonical_data, report = error_report)
}



#' @param in_file name of input excel file
#' @param test_only if TRUE, canonical csv files are not written
#' @param colname_yaml yaml file of the colname list list
clean_late_datasheet_github = \(in_file, test_only = FALSE, colname_yaml = 'column_names.yaml') {
  colname_key = yaml::read_yaml(colname_yaml)
  year = basename(in_file) |> word(1)
  
  output = clean_late_datasheet_internal(in_file, year, colname_key)
  log_direc = if_else(isTRUE(test_only, LOG_DIR$late_test, LOG_DIR$late))
  
  # I need to figure out how to handle writing this...
  output$write(in_file, log_direc)
  # Write output files...
  if(isFALSE(test_only)) output$data |> write_canonical_data('late')
  invisible()
}

# Temporary function
format_error_log = \(...) {
"## Paragraph 1
  Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce lacinia sollicitudin felis, nec porttitor nunc malesuada in. Suspendisse potenti. Curabitur eget gravida dui, non tempor leo. Ut ac ultrices diam. Mauris quis dapibus lectus. Etiam sit amet faucibus diam. Donec facilisis dolor in turpis mollis posuere. Ut rhoncus nulla et rutrum volutpat. Pellentesque in neque id libero tristique fermentum. Phasellus vestibulum sed mauris et ultricies. Integer feugiat bibendum quam sit amet cursus.
## Paragraph 2
Donec vestibulum quis lacus sit amet ullamcorper. Phasellus dapibus magna eget risus tempus, vitae sagittis ipsum tempor. Nullam lorem odio, viverra a tellus eget, scelerisque faucibus eros. Vestibulum eu sodales lorem. In lobortis, urna at porttitor commodo, enim sem efficitur nulla, nec convallis risus libero et orci. Maecenas quis enim volutpat, rutrum lacus vel, venenatis metus. Nulla vitae mattis massa. Vivamus eu turpis pellentesque, lacinia eros mollis, vestibulum quam. In libero velit, maximus et ligula eu, tempus sagittis diam. Nam a nisl vitae orci faucibus mollis. Curabitur a tristique magna. Sed interdum dapibus lorem, id vestibulum urna faucibus et. Maecenas sit amet tellus vel massa convallis dapibus vel sit amet risus. Mauris quis tincidunt massa, sed tempus arcu. Nulla aliquam nisi in turpis accumsan dapibus. Nulla vel libero accumsan, consequat massa sit amet, porttitor elit.
### Paragraph 3
Aliquam vitae vehicula orci. Nam pretium massa tellus, vel egestas magna imperdiet quis. Aliquam efficitur tempor ornare. Mauris ornare nisi eu sapien pretium malesuada. Vivamus mattis luctus auctor. Morbi ac mattis tellus, ut suscipit sem. Vivamus quis facilisis eros.
### Paragraph 4
Etiam vel sem ultrices, gravida eros ut, ultricies nisl. Integer urna odio, placerat eu fermentum ut, dapibus ut enim. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur a elit in nisl congue efficitur a ut neque. Vivamus venenatis, magna ac mattis egestas, dolor ligula sollicitudin nisl, quis tincidunt tellus diam id urna. Donec non tortor dolor. Integer quis leo in est ultricies maximus vitae vitae odio. Aenean consequat quis diam a ornare. Fusce nec tellus blandit, ultrices nibh a, suscipit nulla. Fusce viverra luctus mi, at porttitor dolor dictum quis. Phasellus viverra purus magna, id euismod diam imperdiet volutpat. Vivamus ornare at augue et varius.
## Paragraph 5
Aliquam dapibus nulla eros, a auctor nisl aliquet ac. Sed nec diam varius, sollicitudin metus non, condimentum augue. Etiam nec mattis nulla. Pellentesque ultrices sagittis lorem et sagittis. Sed mollis diam quis velit viverra pharetra. Ut a aliquet neque. Phasellus molestie nulla nec leo auctor, sit amet rutrum leo lacinia. Mauris vitae hendrerit odio. "
}

#' @param name name of input excel file
#' @param datapath actual location of the excel file
#' @param colname_key named list of colname aliases
#' @param ... ignored
clean_late_datasheet_shiny = \(name, datapath,  colname_key, ...) {
  name = basename(name)
  year = name |> word(1)
  output = clean_late_datasheet_internal(datapath, year, colname_key)
  output$report$in_file = name # Correct this, as it was previously datapath
  
  # output$report = format_error_log(output$report, name)
  output
}



#' @param in_file name of input excel file
#' @param test_only if TRUE, canonical csv files are not written
#' @param colname_key named list with alternate column names, OR yaml file of the list
#' @param datapath actual file name, if different from in_file; used for shiny version
clean_late_datasheet_old = \(in_file, test_only = FALSE, colname_key = 'column_names.yaml',
                         datapath = in_file) {
  if(length(colname_key) == 1 && is.character(colname_key) && str_sub(colname_key, -4L) == 'yaml'){
    colname_key = yaml::read_yaml(colname_yaml)
  }
  
    
  error_log = make_logger()
  year = basename(in_file) |> word(1)
  canonical_data = with_error_logs({
    parsed_data = data_file |> 
      read_late_data(colname_key) |> parse_late_data()  |> 
      resolve_leaf_mismatches()
  
    validate_one_collection_date(parsed_data)
    # identify_multi_binary(parsed_data)
    parsed_data |> make_canonical_forms_late() 
  }, logger = error_log)
  log_direc = if_else(isTRUE(test_only, LOG_DIR$late_test, LOG_DIR$late))
  
  # I need to figure out how to handle writing this...
  error_log$write(in_file, colname_key, log_direc)
  
  # Write output files...
  if(isFALSE(test_only)) canonical_data |> write_canonical_forms_late()
  invisible()
}

# Combine cleaned files ####
#' Combine canonical files
#' @param in_dir directory of the canonical files
make_all_year = \(in_dir) {
  # browser()
  in_files = file.path(in_dir, dir(in_dir, pattern = '20[0-9][0-9].csv'))
  read_csv(in_files) |> write_csv(paste0(in_dir, '_allyears.csv'))
}
#' Combine and export the leaf and surface data
combine_leaf_surface = \(leaf_df, surface_df) {
  left_join(leaf_df, surface_df, by = 'leaf_id')
}
combine_leaf_surface_files = \(period = c('late', 'early')) {
  period = match.arg(period)
  direc = CANONICAL_DIR[[period]]
  leaf_files = dir(direc, 'leaf_') |> sort()
  surface_files = dir(direc, 'surface_') |> sort()
  
  leaf_df = read_csv(leaf_files)
  surface_df = read_csv(surface_files)
  
  combine_leaf_surface(leaf_df, surface_df) |> 
  write_csv(file.path(COMBINED_DIR[[period]],  'leaf_surface.csv'), na = '')
}

# Parse and display error logs





