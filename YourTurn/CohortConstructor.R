
# load packages ---
library(duckdb)
library(dplyr)
library(CDMConnector)
library(here)
library(PhenotypeR)
library(CohortConstructor)
library(CodelistGenerator)

# connect to database ----
con <- dbConnect(drv = duckdb(dbdir = here("Databases", "delphi.duckdb")))

cdm <- cdmFromCon(
  con = con,
  cdmSchema = "main",
  writeSchema = "results",
  writePrefix = "cc_"
)


# disconnect from database ----
cdmDisconnect(cdm = cdm)