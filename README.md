# UCI HAR Tidy Data Creation

## Required libraries

The following R packages are required to run the R script:

* dplyr
* tidyr

## Description

This repository contains a script, run_analysis.R, that will download the UCI HAR Dataset and create
two tidy datasets from it:

* **tidyData.csv**: this is simplified and merged data from all the files in UCI HAR. It only contains
                    the means and std deviations of variables in the original raw dataset.
* **tidyAverages.csv**: this dataset is built on tidyData.csv and shows averages for each mean and std
                        deviation grouped by other variables.

## Running the script

To run this file from the command line, run the following command from the repository's root folder:

```
$ r --vanilla < run_analysis.R
```