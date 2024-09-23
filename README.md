
# Aspen Leaf Miner survey data from Interior Alaska

In-progress repository to automatically clean ALM survey data and
diagnose errors.

## Current Status

[Error Status](errors.md)

<!-- Here's another attempted edit -->
<!-- Possible workflow: -->
<!--   Read in new data -->
<!--   Check to make sure that all of the columns are detectable by the metadata?   -->
<!--   By default, see if the 2023 metadataa works on them?   -->
<!--   Use build status fail/pass -->
<!--   Use targets (or similar) to detect if a change has been made to the input files (or detect if new files have been added?); key them to a github action -->
<!-- # Design Ideas -->
<!-- Define the human-readable metadata in a csv file, separate for each 'level'.  Automatically read in the appropriate data to the readmes for each canonical subset -->
<!-- ## Directory structure: -->
<!-- - raw_data: contains annual CSV files -->
<!--   - early -->
<!--   - late -->
<!-- - canonical_data: contains uniformly corrected data separated by database table; each subdir contains oen file per year -->
<!--   - leaf_early -->
<!--   - leaf_late -->
<!--   - surface_early -->
<!--   - surface_late -->
<!--   - pupa_late -->
<!--   - parasite_late -->
<!-- - combined_data: contains combinations of canonical_data; only csv files, no directories -->
<!--   - leaf_early.csv, leaf_l.ate.csv : rows correspond to leaf -->
<!--   - leaf_surface_early.csv, leaf_surface_late.csv : rows correspond to surface; should be two per leaf, with no drops -->
<!--   - pupa_leaf_surface_late.csv: rows correspond to observed pupa; leaves/surfaces without pupa are excluded -->
<!--   - parasite_pupa_leaf_surface_late.csv: rows corresponding to parasites: leaves/surfaces/pupa without parasites are excluded -->
<!-- ## Target Goals: -->
<!-- - Inputs: -->
<!--   - Metadata Dictionary ( A file that somehow defines how files refer to the same things.  Maybe YML?) Should be text-editable by Pat/Diane -->
<!--   - Excel files in 2 directories; these will create dynamic branches -->
<!-- - Steps: -->
<!--   1. Read and clean input data create 2 or four output files for each... -->
<!--      - Write output files to the correct subdirectories -->
<!--   2. Read the cannonical data, create the combined_datasets; maybe useful to have several sub-sets, depending on each other -->
<!--      - leaf_early.csv -> leaf_surface_early.csv -->
<!--      - leaf_late.csv -> leaf_surface_late.csv -> pupa_leaf_surface_late.csv -> parasite_pupa_leaf_surface.csv -->
<!-- ## Todo list: -->
<!-- 1. New column name dictionary -->
<!-- 2. Fully functionalize scripts -->
<!-- <!-- 3.  -->
