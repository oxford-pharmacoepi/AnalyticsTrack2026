
# load packages ---
library(duckdb)
library(dplyr)
library(CDMConnector)
library(here)
library(IncidencePrevalence)

# connect to database ----
con <- dbConnect(drv = duckdb(dbdir = here("Databases", "delphi.duckdb")))

cdm <- cdmFromCon(
  con = con,
  cdmSchema = "main",
  writeSchema = "results",
  writePrefix = "ip_"
)


# disconnect from database ----
cdmDisconnect(cdm = cdm)
