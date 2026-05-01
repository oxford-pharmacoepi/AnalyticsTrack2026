
cdm <- omock::mockCdmFromDataset(datasetName = "delphi-100k_5.4")
con <- duckdb::dbConnect(drv = duckdb::duckdb(dbdir = here::here("Databases", "delphi.duckdb")))
DBI::dbExecute(con, "CREATE SCHEMA results")
CDMConnector::insertCdmTo(cdm = cdm, to = CDMConnector::dbSource(con, "main"))
DBI::dbDisconnect(con = con)

cdm <- omock::mockCdmFromDataset(datasetName = "GiBleed")
con <- duckdb::dbConnect(drv = duckdb::duckdb(dbdir = here::here("Databases", "GiBleed.duckdb")))
DBI::dbExecute(con, "CREATE SCHEMA results")
CDMConnector::insertCdmTo(cdm = cdm, to = CDMConnector::dbSource(con, "main"))
DBI::dbDisconnect(con = con)
