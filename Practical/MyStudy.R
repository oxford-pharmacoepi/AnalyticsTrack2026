# load libraries ----
library(CDMConnector)
library(duckdb)
library(here)
library(OmopSketch)
library(CodelistGenerator)
library(CohortConstructor)
library(PhenotypeR)
library(PatientProfiles)
library(CohortCharacteristics)
library(IncidencePrevalence)
library(DrugUtilisation)
library(CohortSurvival)
library(dplyr)
library(gt)

# create the database ----
con <- dbConnect(drv = duckdb(dbdir = here("Databases", "delphi.duckdb")))

# create the cdm object
cdm <- cdmFromCon(
  con = con,
  cdmSchema = "main",
  writeSchema = "results",
  achillesSchema = "achilles",
  writePrefix = "rwess_",
  cdmName = "SummerSchool2026",
  # cohortTables = c("exposures", "pain", "base_cohort") # uncomment if the cohorts have already been created (DAY 3 / DAY 4)
)
cdm

# disconnect ----
cdmDisconnect(cdm = cdm)
