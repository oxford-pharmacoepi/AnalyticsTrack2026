
# load packages ---
library(PatientProfiles)
library(CDMConnector)
library(CohortConstructor)
library(duckdb)
library(dplyr)
library(here)
library(omock)
library(DBI)
library(CodelistGenerator)

# connect to database ----
con <- dbConnect(drv = duckdb(dbdir = here("Databases", "delphi.duckdb")))

cdm <- cdmFromCon(
  con = con,
  cdmSchema = "main",
  writeSchema = "results",
  writePrefix = "pp_"
)


# disconnect from database ----
cdmDisconnect(cdm = cdm)
