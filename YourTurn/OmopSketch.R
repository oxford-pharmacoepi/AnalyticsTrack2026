
# load packages ---
library(OmopSketch)
library(CDMConnector)
library(duckdb)
library(dplyr)
library(here)
library(omock)

# connect to database ----
con <- dbConnect(drv = duckdb(dbdir = here("Databases", "delphi.duckdb")))

cdm <- cdmFromCon(
  con = con,
  cdmSchema = "main",
  writeSchema = "results",
  writePrefix = "os_"
)


# disconnect from database ----
cdmDisconnect(cdm = cdm)
