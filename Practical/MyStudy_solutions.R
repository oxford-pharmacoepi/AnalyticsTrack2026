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
# cdm <- omock::mockCdmFromDataset(datasetName = "delphi-100k_5.4", source = "duckdb")
cdm <- omock::mockCdmFromDataset(datasetName = "GiBleed", source = "duckdb")

## Day 1
# check the cdm name associated with your cdm reference
cdmName(cdm)

# check the OMOP CDM version being used
cdmVersion(cdm)

# check the vocabulary version being used (hint: use CodelistGenerator package)
vocabularyVersion(cdm)

# insert the cars dataset into your cdm reference
cdm <- insertTable(cdm = cdm, name = "cars", table = cars)

# collect the cars dataset back into your r session
cars |> collect()

# create a table showing the OMOP CDM snapshot
summariseOmopSnapshot(cdm) |> 
  tableOmopSnapshot()

# create a table showing a summary of the observation period table
summariseObservationPeriod(cdm) |> 
  tableObservationPeriod()

# create a plot the yearly trend in ongoing drug exposure records and new condition occurrence records
summariseTrend(cdm, episode = "drug_exposure", interval = "years") |> 
  plotTrend()
summariseTrend(cdm, event = "condition_occurrence", interval = "years") |> 
  plotTrend()

# create a table that summarise the drug exposure and condition occurrence tables 
# (including proportion of records in observation, source vocabularies, etc)
summariseClinicalRecords(cdm, c("drug_exposure", "condition_occurrence")) |> 
  tableClinicalRecords()

# create a table with the top 5 most frequent drug exposure and condition occurrence records
summariseConceptIdCounts(cdm, c("drug_exposure", "condition_occurrence")) |> 
  tableTopConceptCounts(top = 5)

## Day 2
# add a cohort table with two cohorts to your cdm reference: rheumatoid arthritis (concept: 80809) and osteoarthritis (concept: 80180)
cdm$study_cohort <- conceptCohort(cdm,
                                  list(rheumatoid_arthritis = 80809,
                                       osteoarthritis = 80180),
                                  name = "study_cohort")
# set cohort exit to end of observation period for both cohorts
cdm$study_cohort <- cdm$study_cohort |> 
  exitAtObservationEnd()

# require at least 365 days of prior observation
cdm$study_cohort <- cdm$study_cohort |> 
  requirePriorObservation(365)

# for the osteoarthritis cohort, remove anyone with a diagnosis of rheumatoid arthritis any time prior up to (and including) index date
cdm$study_cohort <- cdm$study_cohort |> 
  requireCohortIntersect(cohortId = "osteoarthritis",
                         targetCohortTable = "study_cohort",
                         targetCohortId = "rheumatoid_arthritis", 
                         window = c(-Inf, 0), 
                         intersections = 0)

# create a plot with cohort attrition 
cdm$study_cohort |> summariseCohortAttrition() |> plotCohortAttrition()

# run phenotype diagnostics on the cohorts
# (include clinical records summary and cohort comparison)
diag <- phenotypeDiagnostics(cdm$study_cohort, 
                             databaseDiagnostics = list(clinicalRecordsSummary = TRUE),
                             cohortDiagnostics = list(compareCohorts = TRUE))

# create a shiny app to view your results
shinyDiagnostics(diag, directory = here::here())


## Day 3
# add a new variable to the cohort table with patients sex
cdm$study_cohort <- cdm$study_cohort |> 
  addSex()

# add another new variable that contains the number of drug exposures each individual has in the year prior to their index date (up to day before index date)
cdm$study_cohort <- cdm$study_cohort |> 
  addTableIntersectCount("drug_exposure",
                         window = c(-365, -1))

# add another new variable that contains the number of drug exposures each individual has in the year following their index date (from index date)
cdm$study_cohort <- cdm$study_cohort |> 
  addTableIntersectCount("drug_exposure",
                         window = c(0, 365))

# create a table summarising characteristics stratified by sex and including a summary of the drug exposure counts before and after diagnosis
cdm$study_cohort |> 
  summariseCharacteristics(strata = "sex", 
                           otherVariables = c("drug_exposure_0_to_365",
                                              "drug_exposure_m365_to_m1")) |> 
  tableCharacteristics()

# create a table with the top 5 condition occurrence events seen on index date for the cohorts
cdm$study_cohort |> 
  summariseLargeScaleCharacteristics(window = c(0, 0),
                                     eventInWindow = "condition_occurrence") |> 
  tableTopLargeScaleCharacteristics(topConcepts = 5)


## Day 4
# create a drug cohort for heparin, collapsing for a gap of 30 days
codes <-  getDrugIngredientCodes(cdm, c("clopidogrel"),
                                 nameStyle = "{concept_name}")
cdm$clopidogrel <-  conceptCohort(
  cdm = cdm,
  name = "clopidogrel",
  conceptSet = codes
)  |>
  collapseCohorts(gap = 30)

# summarise drug utilisation details in a table, with ingredient id 1322184
result <- cdm$clopidogrel |>
  summariseDrugUtilisation(
    ingredientConceptId = 1322184, 
    conceptSet = codes,
    indexDate = "cohort_start_date",
    censorDate = "cohort_end_date", 
    restrictIncident = TRUE, 
    gapEra = 30, 
    numberExposures = TRUE, 
    numberEras = TRUE,
    daysExposed = TRUE,
    daysPrescribed = TRUE,
    timeToExposure = FALSE, 
    initialQuantity = TRUE, 
    cumulativeQuantity = TRUE, 
    initialDailyDose = TRUE, 
    cumulativeDose = TRUE,
    estimates = c("q25", "median", "q75")
  )
tableDrugUtilisation(result)

# create a plot with proportion of patients covered up to 180 days
cdm$clopidogrel |>
  summariseProportionOfPatientsCovered(followUpDays = 180) |> 
  plotProportionOfPatientsCovered()

# add an overall denominator cohort from 2005 onwards to your cdm reference
cdm <- generateDenominatorCohortSet(cdm, "denom", cohortDateRange = c(as.Date("2005-01-01"), as.Date(NA)))

# estimate and plot incidence
inc <- estimateIncidence(cdm, "denom", "clopidogrel", outcomeWashout = Inf)
plotIncidence(inc)
# plot denominator counts for incidence 
plotIncidencePopulation(inc, y = "denominator_count")
# plot outcome counts for incidence 
plotIncidencePopulation(inc, y = "outcome_count")

# estimate and plot period prevalence
prev <- estimatePeriodPrevalence(cdm, "denom", "clopidogrel")
plotPrevalence(prev)
# plot denominator counts for incidence 
plotPrevalencePopulation(prev, y = "denominator_count")
# plot outcome counts for incidence 
plotPrevalencePopulation(prev, y = "outcome_count")

