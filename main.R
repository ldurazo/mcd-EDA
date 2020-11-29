# Title     : Exploratory data analysis - violence in the world and woman grand master likelihood.
# Objective : See how strong a correlation there is between violence in the world and the world's grandmasters women chess players
# Created by: ldurazo
# Created on: 28/11/20


chooseCRANmirror(ind = 52)
# EDA & Kaggle auth packages
install.packages(c("summarytools", "explore", "dataMaid", "devtools"))
devtools::install_github("ldurazo/kaggler")

#Library loading
library(summarytools)
library(readr)
library(kaggler)

kgl_auth(creds_file = 'kaggle.json')
response <- kgl_datasets_download_all(owner_dataset = "andrewmvd/violence-against-women-and-girls")

# File loading
download.file(response[["url"]], "data/temp.zip", mode="wb")
unzipResult <- unzip("data/temp.zip", exdir = "data/", overwrite = TRUE)
violence_data <- read_csv("data/makeovermonday-2020w10/violence_data.csv")

# Data peek
view(dfSummary(violence_data))
