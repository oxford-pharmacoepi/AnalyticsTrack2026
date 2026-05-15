
# load packages ---
library(duckdb)
library(dplyr)
library(CDMConnector)
library(here)
library(DrugUtilisation)

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
