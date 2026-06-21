
# load packages ---
library(CDMConnector)
library(CodelistGenerator)
library(CohortConstructor)
library(CohortCharacteristics)
library(duckdb)
library(DBI)
library(dplyr)
library(gt)
library(here)

# connect to database ----
con <- dbConnect(drv = duckdb(dbdir = here("Databases", "delphi.duckdb")))
cdm <- cdmFromCon(
  con = con,
  cdmSchema = "main",
  writeSchema = "results",
  writePrefix = "cc_"
)

# Exercise 1 ----
# Create a cohort table with two cohorts: chronic kidney disease and acute kidney injury. Use the following codelist.

# Exercise 2 ----
# Create a new cohort named "study_cohort" by applying the following criteria to the base conditions cohort:
# -   For both cohorts, require that records start between January 1, 1990, and December 31, 2011.
# -   For both cohorts, include only patients with no previous history (before diagnosis) of diabetes. Use the diabetes codes below.

# Exercise 3 ----
# Since Chronic Kidney Disease (CKD) is a chronic condition, define its cohort exit so patients remain in the cohort from first diagnostic date to the end of patient's observation.

# Exercise 4 ----
# Create a third cohort containing patients with Chronic Kidney Disease who also experience an Acute Kidney Injury; define its criteria so that the final "study_cohort" table includes three distinct cohorts: "acute_kidney_injury", "chronic_kidney_disease", and "acute_kidney_injury_chronic_kidney_disease".
# Finally, rename cohorts so they are called "aki", "ckd", and "aki_ckd", respectively.

# disconnect from database ----
cdmDisconnect(cdm = cdm)