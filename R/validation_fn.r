# Validation Checks

# Functions named validate_() are void
# Functions named resolve_() return modified data

# Validation Definition Factory ####
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

# Initial Parsing ####
#' Checks that the quantitiative columns have been parsed to numeric
#' @param parsed_data data that has been parsed
validate_numeric_col_parsing = new_validation(
  'numeric_column_parsing', 'Error validating numeric column parsing',
  \(parsed_data) list(data = parsed_data, valid_numeric = parsed_data |> 
                        select(any_of(COLUMN_TYPES$quantitative)) |> map_lgl(is.numeric)),
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
# Data QC ####
#' Checks that the binary columns only have a single 1 in them for each row
#' @param parsed_data parsed data
validate_single_binary_col = new_validation(
  'multiple_binary_rows', 'Multiple binary columns in one row',
  \(parsed_data) parsed_data |>  quant_total() |> 
    # mutate(row = 1:n() + 1) |>  
    filter(total > 1), # Based on a positive quant_total
  .return_fn = \(bad_vals) {
    default_cols = c('site', 'tree', 'leaf_position', 'leaf_side', 'individual')
    bad_vals |> select(row, total,  any_of(COLUMN_TYPES$binary) & where(\(x) any(x > 1, na.rm = TRUE) ),
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


# Leaf mismatches (requires return value) ####

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

# During Canonicalization ####
validate_individual_numbers = new_validation(
  'unique_individual_numbers', "Individuals are not unique within a leaf surface",
  \(surface_data_binary) {     surface_data_binary |> 
      group_by(leaf_id, leaf_side) |> 
      summarize(rows = deparse(row), n_rows = n(), n_individuals = n_distinct(individual),
                individuals = paste(individual, collapse = ','), .groups = 'drop')  |> 
      filter(n_rows != n_individuals) |> 
      select(rows, individuals, leaf_id, leaf_side)
  })
