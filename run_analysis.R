## Note:
## The relative path to the dataset folder is ./data/UCI HAR Dataset

if (!require("plyr")) 
        install.packages("plyr");

library(plyr)

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

## 1.6 Merge the two datasets
## Append the rows of the test dataset to training dataset
## This is the answer to the first part
data <- rbind(data_training, data_test)

## verify the merged dataset - 
## this should ouput 10299 rows (= 7352 + 2947) and 562 columnns
# str(data)
dim(data)


## ------------------------------------------------------------------


## 2. Extracts only the measurements on 
## the mean and standard deviation for each measurement.

## get colnames
columns <- names(data)
columnsWithMean <- columns[grepl("-mean()", columns) ]
length(columnsWithMean)

columnsWithStdDeviation <- columns[grepl("-std()", columns) ]
length(columnsWithStdDeviation)

columnsToKeep <- c(columnsWithMean, columnsWithStdDeviation)
length(columnsToKeep)

## This is the answer to the 2nd point - extract data with 
## only mean and std measures only
data_mean_and_std_deviations <- data[, columnsToKeep]

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
data <- join(data, data_activity_labels)

## verify dimensions - should have 10299 rows and 563 columns now
dim(data)

## ------------------------------------------------------------------

## 4. Appropriately labels the data set with descriptive variable names.

## ------------------------------------------------------------------

## 5. From the data set in step 4, creates a second, independent tidy data set


## with the average of each variable for each activity and each subject.
