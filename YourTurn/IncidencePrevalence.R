
# load packages ---
library(CDMConnector)
library(IncidencePrevalence)
library(dplyr)
library(tidyr)
library(ggplot2)
library(gt)
library(here)
library(duckdb)

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
