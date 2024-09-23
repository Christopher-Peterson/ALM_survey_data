# Globals

# Global Variables should have all caps names

## Set Directories ####
# Create a self-named subset of directories
#' @x subdirectory name
#' @param direc parent directory
named_subdirs = \(x, direc) {
  paths = file.path(direc,x) |> set_names(x)
  walk(paths, dir.create, recursive = TRUE, showWarnings = FALSE)
  paths
}

LOG_DIR = c('late', 'early', 'test_late', 'test_early') |> named_subdirs('error_logs')
CANONICAL_DIR = list(
  late = c('leaf', 'surface', 'larva', 'pupa', 'parasite') |> named_subdirs('canonical_data/late')
)
COMBINED_DIR = list(
  late = c('leaf_surface') |> named_subdirs('combined_data/late')
)


## Define some column types ####
COLUMN_TYPES = tibble::lst(
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
COLUMN_GROUPS_LATE  = list(
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
COLUMN_ORDER_LATE = unlist(COLUMN_GROUPS_LATE) |> unname()

