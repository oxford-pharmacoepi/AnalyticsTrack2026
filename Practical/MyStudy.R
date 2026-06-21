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

# create a cdm reference to your data

## Day 1
# check the cdm name associated with your cdm reference

# check the OMOP CDM version being used

# check the vocabulary version being used (hint: use CodelistGenerator package)

# insert the cars dataset into your cdm reference

# collect the cars dataset back into your r session

# create a table showing the OMOP CDM snapshot

# create a table showing a summary of the observation period table

# create a plot the yearly trend in ongoing drug exposure records and new condition occurrence records

# create a table that summarise the drug exposure and condition occurrence tables 
# (including proportion of records in observation, source vocabularies, etc)

# create a table with the top 5 most frequent drug exposure and condition occurrence records

## Day 2
# add a cohort table with two cohorts to your cdm reference: rheumatoid arthritis (concept: 80809) and osteoarthritis (concept: 80180)

# set cohort exit to end of observation period for both cohorts

# require at least 365 days of prior observation

# for the osteoarthritis cohort, remove anyone with a diagnosis of rheumatoid arthritis any time prior up to (and including) index date

# create a plot with cohort attrition 

# run phenotype diagnostics on the cohorts
# (include clinical records summary and cohort comparison)

# create a shiny app to view your results


## Day 3
# add a new variable to the cohort table with patients sex

# add another new variable that contains the number of drug exposures each individual has in the year prior to their index date (up to day before index date)

# add another new variable that contains the number of drug exposures each individual has in the year following their index date (from index date)

# create a table summarising characteristics stratified by sex and including a summary of the drug exposure counts before and after diagnosis

# create a table with the top 5 condition occurrence events seen on index date for the cohorts

## Day 4
# create a drug cohort for heparin, collapsing for a gap of 30 days

# summarise drug utilisation details in a table, with ingredient id 1322184

# create a plot with proportion of patients covered up to 180 days

# add an overall denominator cohort from 2005 onwards to your cdm reference

# estimate and plot incidence

# plot denominator counts for incidence 

# plot outcome counts for incidence 

# estimate and plot period prevalence

# plot denominator counts for incidence 

# plot outcome counts for incidence 

