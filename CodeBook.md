## CodeBook

### Code, data, libraries

All the code is in the run_analysis.R file

The data is contained in the 'data' folder. 
For example, the training set file is in './data/UCI HAR Dataset/train/X_train.txt'

There is a dependency on 'dplyr' package

### Variables (existing and new)

- All original variables (561) from features.txt are included in the tidy data set
- New variables added:
  - *activityId*, *activityName* (added for the activities)
  - *subjectId* (added from the subject test/train files, varies from 1 to 30)

| activityId | activityName |
| ---------- | ------------ |
|1 | WALKING |
|2 | WALKING_UPSTAIRS |
|3 | WALKING_DOWNSTAIRS |
|4 | SITTING |
|5 | STANDING |
|6 | LAYING |

### Resulting Data

- *data_tidy* : A data frame output for the results of step 1 of the assignment, and used for others down the code
- *data_mean_and_std_deviations* : A data frame with means and standard deviations only
- *data_tidy_grouped_by_activity_subject* : A data frame which is the result of step 5 of the assignment.

### Different Sections of Code

It has comments for each section for the below -

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#### 1. Merges the training and the test sets to create one data set.

The output from this section is a dataframe named 'data_tidy'

Steps:

- 1.1. Get the training dataset
- 1.2. Get the Test dataset
- 1.3. Get the feature names
- 1.4. Get the training labels and append them to the training data set
- 1.5. Get the test labels and append them to the test data set
    **NOTE** - This adds a column *'activityId'* to the data set which signifies the activity
- 1.6. Get the training subject ids and append them to training set
- 1.7. Get the test subject ids and append them to test set
    **NOTE** - This adds a column *'subjectId'* to the data set which signifies the subject
- 1.8. Merge the two datasets

The output is the data frame: *data_tidy*

#### 2. Extracts only the measurements on the mean and standard deviation for each measurement.

Steps:

- 2.1. Get the column names with the text "mean()" in them to identify the means
- 2.2. Get the column names with the text "std()" in them to identify standard deviations
- 2.3. Finally, extract data with only mean and std measures only

The ouput is the data frame: *data_mean_and_std_deviations*

#### 3. Uses descriptive activity names to name the activities in the data set

Steps:

- 3.1. Get the activity labels
- 3.2. Set the column names as "activityId", "activityName"
- 3.3. Add the activity name to the original dataset by joining it with the above read labels

#### 4. Appropriately labels the data set with descriptive variable names.

Steps:

- 4.1. Make column names unique
- 4.2. Clean the names - remove brackets, commas and replace with underscores
- 4.3. Assign clean names to data set

#### 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

There are 561 variables to be grouped by 3 (activityId, activityName, subjectId)
There are 6 activities and 30 subjects. So, the ouput will be 180 rows.

The code uses library dplyr, for grouping, and then summarise all to calculate mean of each column.
The result is finally converted to a data frame - *data_tidy_grouped_by_activity_subject*

Finally, export the data to a txt file at ./results/tidy_dataset_step5.txt

**NOTE** - There is a command to clean up all objects at the end. This is commented out, but can be used post execution.



