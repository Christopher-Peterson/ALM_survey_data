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

write_canonical_forms_late = \(canonical_data_list) {
  year = canonical_data_list$leaf$year[1]
  output_files = imap(CANONICAL_DIR$late, 
                      \(x, nm) file.path(x, glue("{nm}_{year}.csv")))
  iwalk(canonical_data_list, \(df, nm) write_csv(df, output_files[[nm]], na = ''))
}

# Parse, Clean, Validate, and Canonicalize one data sheet; write output files ####
#' @param in_file input excel file
#' @param test_only if TRUE, canonical csv files are not written
#' @param colname_yaml yaml file with column names
clean_late_datasheet = \(in_file, test_only = FALSE, colname_yaml = 'column_names.yaml') {
  
  colname_key = yaml::read_yaml(colname_yaml)
  
  error_log = make_logger()
  canonical_data = with_error_logs({
    parsed_data = in_file |> 
      read_late_data(colname_key) |> parse_late_data()  |> 
      resolve_leaf_mismatches()
  
    validate_one_collection_date(parsed_data)
    # identify_multi_binary(parsed_data)
    parsed_data |> make_canonical_forms_late() 
  }, logger = error_log)
  log_direc = if_else(isTRUE(test_only, LOG_DIR$late_test, LOG_DIR$late))
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
combine_leaf_surface = \(leaf_file, surface_file) {
  leaf_in = read_csv(leaf_file)
  surface_in = read_csv(surface_file)
  left_join(leaf_in, surface_in, by = 'leaf_id')
  write_csv(COMBINED_DIR$late$leaf_surface, na = '')
}

# Parse and display error logs





