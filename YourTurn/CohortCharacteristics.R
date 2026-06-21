
# load packages ---
library(duckdb)
library(CDMConnector)
library(CohortConstructor)
library(PatientProfiles)
library(dplyr)
library(ggplot2)
library(here)
library(CohortCharacteristics)
library(CodelistGenerator)

# connect to database ----
con <- dbConnect(drv = duckdb(dbdir = here("Databases", "delphi.duckdb")))

cdm <- cdmFromCon(
  con = con,
  cdmSchema = "main",
  writeSchema = "results",
  writePrefix = "cch_"
)


# disconnect from database ----
cdmDisconnect(cdm = cdm)