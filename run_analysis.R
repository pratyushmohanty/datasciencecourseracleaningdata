## Note:
## The relative path to the dataset folder is ./data/UCI HAR Dataset


if (!require("dplyr")) 
        install.packages("dplyr");

library(dplyr)

## ------------------------------------------------------------------
## 1. Merges the training and the test sets to create one data set.

## 1.1 Get the training dataset
## - 'train/X_train.txt': Training set.
## Read the file

url_file_training <- './data/UCI HAR Dataset/train/X_train.txt'
data_training <- read.table(url_file_training, header = FALSE)

## Verify the dimensions - rows(7352) and columns (561) 
dim(data_training)

## Verify the datatypes - should be numeric
unique(sapply(data_training, class))


## 1.2 Get the Test dataset
## - 'test/X_test.txt': Test set.
## Read the file 

url_file_test <- './data/UCI HAR Dataset/test/X_test.txt'
data_test <- read.table(url_file_test, header = FALSE)

## Verify the dimensions - rows(2947) and columns (561)
dim(data_test)

## Verify the datatypes - should be numeric
unique(sapply(data_test, class))

## 1.3 Get the feature names
## - 'features.txt': List of all features.

url_file_features <- './data/UCI HAR Dataset/features.txt'
data_features <- read.table(url_file_features, header = FALSE)

## get the feature names into a vector
featurenames <- data_features[, 2]

## Assign the training and test dataset with the feature names
colnames(data_training) <- featurenames
colnames(data_test) <- featurenames

## 1.4 get the training labels and append them to the training data set
## - 'train/y_train.txt': Training labels.
url_file_training_labels <- './data/UCI HAR Dataset/train/y_train.txt'
data_training_labels <- read.table(url_file_training_labels, header = FALSE)

## verify the dimensions - 7352 rows and 1 column
dim(data_training_labels)

## add to the training dataset 
## add a column called activityId
data_training$activityId <- data_training_labels[,1]


## 1.5 get the test labels and append them to the test data set
## - 'test/y_test.txt': Test labels.
url_file_test_labels <- './data/UCI HAR Dataset/test/y_test.txt'
data_test_labels <- read.table(url_file_test_labels, header = FALSE)

## verify the dimensions - 2947 rows and 1 column
dim(data_test_labels)

## add to the test dataset 
## add a column called activityId
data_test$activityId <- data_test_labels[,1]

## 1.6 get the training subject ids and append them to training set
## - 'train/subject_train.txt': 
## Each row identifies the subject who performed the activity for 
## each window sample. Its range is from 1 to 30.

url_file_training_subjects <- './data/UCI HAR Dataset/train/subject_train.txt'
data_training_subjects <- read.table(url_file_training_subjects, header = FALSE)

## add column to the end
data_training$subjectId <- data_training_subjects[, 1]

## 1.6 get the test subject ids and append them to test set
## - 'test/subject_test.txt'

url_file_test_subjects <- './data/UCI HAR Dataset/test/subject_test.txt'
data_test_subjects <- read.table(url_file_test_subjects, header = FALSE)

## add column to end
data_test$subjectId <- data_test_subjects[, 1]


## 1.8 Merge the two datasets
## Append the rows of the test dataset to training dataset
## This is the answer to the first part
data_tidy <- rbind(data_training, data_test)

## verify the merged dataset - 
## this should ouput 10299 rows (= 7352 + 2947) and 563 columnns
# str(data_tidy)
dim(data_tidy)


## ------------------------------------------------------------------


## 2. Extracts only the measurements on 
## the mean and standard deviation for each measurement.

## get colnames
columns <- names(data_tidy)
columnsWithMean <- columns[grepl("-mean()", columns) ]
length(columnsWithMean)

columnsWithStdDeviation <- columns[grepl("-std()", columns) ]
length(columnsWithStdDeviation)

columnsToKeep <- c(columnsWithMean, columnsWithStdDeviation)
length(columnsToKeep)

## This is the answer to the 2nd point - extract data with 
## only mean and std measures only
data_mean_and_std_deviations <- data_tidy[, columnsToKeep]

## verify - should show 10299 rows and 79 columns
dim(data_mean_and_std_deviations)

## ------------------------------------------------------------------

## 3. Uses descriptive activity names to name the activities in the data set

## 3.1 get the activity labels
## - 'activity_labels.txt': Links the class labels with their activity name.
## Read the file

url_file_activity_labels <- './data/UCI HAR Dataset/activity_labels.txt'
data_activity_labels <- read.table(url_file_activity_labels, header = FALSE, stringsAsFactors = FALSE)

## 3.2 set the column names
colnames(data_activity_labels) <- c("activityId", "activityName")

## add the activity name to the original dataset
## by joining it with the data_activity_labels data frame 
## this is the answer to the 3rd question
data_tidy <- join(data_tidy, data_activity_labels)

## verify dimensions - should have 10299 rows and 564 columns now
dim(data_tidy)

## ------------------------------------------------------------------

## 4. Appropriately labels the data set with descriptive variable names.
## check the column names 

columnNames_data <- names(data_tidy)
## there are duplicate columns 
if(length(columnNames_data) != length(unique(columnNames_data))) {
        message("duplicate column names found!")
}

## make columns unique
cleanNames <- make.unique(columnNames_data, sep="_")
## get rid of ()
cleanNames <- gsub(x = cleanNames, pattern = "\\()", replacement = "") 
## replace '(' or ')' with an underscore
cleanNames <- gsub(x = cleanNames, pattern = "\\(", replacement = "_")
cleanNames <- gsub(x = cleanNames, pattern = "\\)", replacement = "_")
## replace ',' with underscores
cleanNames <- gsub(x = cleanNames, pattern = "\\,", replacement = "_")
## replace '-' with underscores
cleanNames <- gsub(x = cleanNames, pattern = "\\-", replacement = "_")
## repalce double underscores with one
cleanNames <- gsub(x = cleanNames, pattern = "\\__", replacement = "_")
## remove trailing underscores using a regex
cleanNames <- gsub('\\_$', '', cleanNames)

## assign the names to the dataset
## this is the answer to the 4th question
colnames(data_tidy) <- cleanNames

## ------------------------------------------------------------------

## 5. From the data set in step 4, creates a second, independent tidy data set
## with the average of each variable for each activity and each subject.

## group by activity and subject
## there are 561 variables 
## to be grouped by 3 (activityId, activityName, subjectId)

## using library dplyr - this will give a list of 180 dataframes
# pipe the dataset to group by
# then pipe to summarise all to calculate mean of each column

data_tidy_grouped_by_activity_subject <- 
        data_tidy %>% 
        group_by(
                activityId, activityName, subjectId
                ) %>%
        summarize_all(
                     funs(mean(., na.rm=TRUE))
                     )

data_tidy_grouped_by_activity_subject <-
        as.data.frame(data_tidy_grouped_by_activity_subject)

## verify - this should give an output of 180 rows x 564 cols
dim(data_tidy_grouped_by_activity_subject)

## run below to remove all objects in memory
rm(list = ls())


