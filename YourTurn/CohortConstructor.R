
# Load packages ---
library(CDMConnector)
library(CodelistGenerator)
library(CohortConstructor)
library(CohortCharacteristics)
library(duckdb)
library(DBI)
library(dplyr)
library(gt)
library(here)

# Connect to database ----
con <- dbConnect(drv = duckdb(dbdir = here("Databases", "delphi.duckdb")))
cdm <- cdmFromCon(
  con = con,
  cdmSchema = "main",
  writeSchema = "results",
  writePrefix = "cc_"
)

# Exercise 1 ----

# Exercise 2 ----

# Exercise 3 ----

# Exercise 4 ----


# Disconnect from database ----
cdmDisconnect(cdm = cdm)
