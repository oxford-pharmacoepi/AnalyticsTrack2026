
# load packages ---
library(omock)
library(duckdb)
library(CDMConnector)
library(dplyr)
library(CodelistGenerator)
library(DrugUtilisation)
library(CohortConstructor)
library(here)

# connect to database ----
con <- dbConnect(drv = duckdb(dbdir = here("Databases", "delphi.duckdb")))

cdm <- cdmFromCon(
  con = con,
  cdmSchema = "main",
  writeSchema = "results",
  writePrefix = "dus_"
)


# disconnect from database ----
cdmDisconnect(cdm = cdm)
