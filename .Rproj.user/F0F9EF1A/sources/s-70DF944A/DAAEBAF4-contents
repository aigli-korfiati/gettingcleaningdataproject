# CodeBook

The data for the project come from:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The README.txt file included in the zip folder describes the experiment, the data and the available files.

Training and testing data and labels were merged together (initially by every corresponding 2)

- 'train/X_train.txt': Training set.

- 'train/subject_train.txt': the subject who performed the activity.

- 'train/y_train.txt': Training labels.

- 'test/X_test.txt': Test set.

- 'test/subject_test.txt': the subject who performed the activity.

- 'test/y_test.txt': Test labels.

From the 'features.txt': List of all features. file we extracted measurements names including only mean and standard deviation. (79 variables)

The selected features, the subjects and the test labels were merged together in the allData dataframe (10299 obs. of 81 variables).

The 'activity_labels.txt': Links the class labels with their activity name. file was used to assign labels to activity names.

The dataset was labeled with appropriate variable names replacing abbreviations with words and removing parentheses.

From the above tidy data set, an independent tidy data set with the average of each variable for each activity and each subject was generated in tidyData dataframe (180 obs of 81 variables) and saved to tidy_dataset.txt.