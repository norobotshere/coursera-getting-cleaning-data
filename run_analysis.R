# libraries
library(dplyr)
library(tidyr)

# constants
DATA_URI <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
FETCH_METHOD <- 'curl'
DATA_ZIP_DEST_FILE <- './data.zip'
DATA_UNZIP_DIR <- './UCI HAR Dataset'
RAW_DATA_TOTAL_COLUMN_COUNT <- 561

# downloads and unzips the raw dataset
downloadFiles <- function () {
    if (file.exists(DATA_ZIP_DEST_FILE)) {
        unlink(DATA_ZIP_DEST_FILE)
    }
    
    if (file.exists(DATA_UNZIP_DIR)) {
        unlink(DATA_UNZIP_DIR, recursive = TRUE)
    }

    download.file(DATA_URI, DATA_ZIP_DEST_FILE, 'curl')
    
    unzip(DATA_ZIP_DEST_FILE)
}

# reads the features.txt file that lists the variable names and finds only the ones we are interested in:
# the std deviations and means. returns two vectors in a list, one can be used as colClasses in read.table,
# and the second element is the column names of the variables we want to keep.
getColumnsFromFeaturesFile <- function () {
    featuresFile = file.path(DATA_UNZIP_DIR, 'features.txt')
    
    varNames <- read.table(featuresFile, sep = "", header = F, na.strings = "", stringsAsFactors = F,
                           col.names = c("index", "name"))
    varNames <- varNames$name    

    # we're only looking for variables that end in -mean()-... or -std()-...
    desiredVarsLogical = grepl('-(mean|std)\\(\\)-', varNames)

    columnNames <- c()
    desiredColumns <- sapply(seq_along(desiredVarsLogical), function (index) {
        if (desiredVarsLogical[index]) {
            columnNames <<- c(columnNames, varNames[[index]])
            "numeric"
        } else {
            # we don't want the column, use "NULL" so read.table will skip it
            "NULL"
        }
    })

    list(desiredColumns, columnNames)
}

# reads the activity name labels from activity_labels.txt in the raw data archive
readActivityNames <- function () {
    activitiesFile = file.path(DATA_UNZIP_DIR, 'activity_labels.txt')
    
    activities <- read.table(activitiesFile, sep = "", header = F, na.strings = "", stringsAsFactors = F,
                             col.names = c("id", "name"))
    
    activities$name
}

# loads an individual data frame from the whole data set (ie, either 'train' or 'test').
# the data loaded is simplified and only the std deviation and mean for each var is loaded from the data.
# the subject and activity for each observation is also merged into this data frame (in the
# raw data, the data is stored in separate files).
loadSimplifiedDataSet <- function (dir, desiredColumns, columnNames, activityNames) {
    columnDataFile = file.path(DATA_UNZIP_DIR, dir, paste('X_', dir, '.txt', sep = ""))
    subjectDataFile = file.path(DATA_UNZIP_DIR, dir, paste('subject_', dir, '.txt', sep = ""))
    activityDataFile = file.path(DATA_UNZIP_DIR, dir, paste('y_', dir, '.txt', sep = ""))

    subjects <- read.table(subjectDataFile, sep = "", header = F, na.strings = "", stringsAsFactors = F,
                              col.names = c("subject"))
    activities <- read.table(activityDataFile, sep = "", header = F, na.strings = "", stringsAsFactors = F,
                             col.names = c("activity"))
    
    data <- read.table(columnDataFile, sep = "", header = F , na.strings ="", stringsAsFactors = F,
                       colClasses = desiredColumns)
    colnames(data) <- columnNames

    data$subject <- subjects$subject
    data$activity <- as.factor(activities$activity)

    data <- data %>% 
        # split long list of variables into four columns, "signal", "mean", "std", "axis"
        pivot_longer(cols = -c(subject, activity),
                     names_to = c("signal", ".value", "axis"),
                     names_pattern = "([^-]+)-(.*?)\\(\\)-(.)") %>%
        # move axis column before mean & std
        select(subject, activity, signal, axis, mean, std)

    data
}

# merges two datasets setting a label to differentiate rows from each
mergeDataSets <- function (ds1, ds1Label, ds2, ds2Label) {
    ds1 <- mutate(ds1, type = ds1Label)
    ds2 <- mutate(ds2, type = ds2Label)
    union(ds1, ds2)
}

# creates a new data frame computing averages for the mean/std deviation for 
computeAverages <- function (data) {
    averages <- data %>%
        group_by(subject, activity, signal, axis) %>%
        dplyr::summarize(averageMean = mean(mean), averageStd = mean(std))
    
    averages
}

# saves a data frame as a csv file
saveDataSet <- function (data, destination) {
    write.csv(data, file = destination, row.names=FALSE)
}

# downloads the raw data and creates two tidy data sets, tidyData.csv and tidyAverages.csv
# see the README and codebook for more information.
runAnalysis <- function () {
    print("Downloading raw dataset...")
    downloadFiles()
    print("Done.")
    
    print("Reading metadata from various txt files...")
    desiredColumnsAndNames <- getColumnsFromFeaturesFile()
    desiredColumns <- desiredColumnsAndNames[[1]]
    columnNames <- desiredColumnsAndNames[[2]]

    activityNames <- readActivityNames()
    print("Done.")

    print("Loading test data set...")
    testData <- loadSimplifiedDataSet('test', desiredColumns, columnNames, activityNames)
    print("Done.")

    print("Loading train data set...")
    trainData <- loadSimplifiedDataSet('train', desiredColumns, columnNames, activityNames)
    print("Done.")
    
    print("Merging data sets...")
    mergedData <- mergeDataSets(testData, 'test', trainData, 'train')
    print("Done.")

    print("Saving tidyData.csv...")
    saveDataSet(mergedData, './tidyData.csv')
    print("Done.")
    
    testData <- NULL
    trainData <- NULL

    print("Computing averages...")
    averageData <- computeAverages(mergedData)
    print("Done.")

    print("Saving tidyAverages.csv...")
    saveDataSet(averageData, './tidyAverages.csv')
    print("Done.")
}

runAnalysis()