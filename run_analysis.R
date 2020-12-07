library(reshape) #needed for step 5
#getting data from the web
rawDataDir <- "./rawData"
rawDataUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
rawDataFilename <- "rawData.zip"
rawDataDFn <- paste(rawDataDir, "/", rawDataFilename, sep = "")
dataDir <- "./data"
#generate a rawData folder for the zip file
if (!file.exists(rawDataDir)) {
  dir.create(rawDataDir)
  download.file(rawDataUrl, rawDataDFn)
}
#generate a data folder for the extracted folder
if (!file.exists(dataDir)) {
  dir.create(dataDir)
  unzip(rawDataDFn, exdir = dataDir)
}

#Step1 Merge training and test sets
# read train data
x_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/X_train.txt"))
y_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/Y_train.txt"))
s_train <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/train/subject_train.txt"))

# read test data
x_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/X_test.txt"))
y_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/Y_test.txt"))
s_test <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/test/subject_test.txt"))

# merge by binding rows - x, y, s will be merged later
x_data <- rbind(x_train, x_test)
y_data <- rbind(y_train, y_test)
s_data <- rbind(s_train, s_test)

#Step 2 Extracts measurements including only mean and standard deviation 
#read feature info
feature <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/features.txt"))


#logical vector where we find mean.. | std..
mean_and_std <- (grepl("mean.." , as.character(feature[,2])) | 
                   grepl("std.." , as.character(feature[,2])) 
)

#subset the columns of x based on the logical vector

x_data <- x_data[ , mean_and_std == TRUE]
#merge selected measurements with subject and activity (for step 1)
allData <- cbind(x_data, s_data, y_data)

#Step 3 Use descriptive activity names to name the activities
#read activity labels - step 3 continues later on
a_label <- read.table(paste(sep = "", dataDir, "/UCI HAR Dataset/activity_labels.txt"))
a_label[,2] <- as.character(a_label[,2])

#Step 4 Appropriately label the data set with descriptive variable names
#assign merged columnnames
names(allData)<-c(as.character(feature$V2[mean_and_std == TRUE]), "subject", "activity" )
#replace abbreviations with words
names(allData)<-gsub("^t", "time", names(allData))
names(allData)<-gsub("^f", "frequency", names(allData))
names(allData)<-gsub("Acc", "Accelerometer", names(allData))
names(allData)<-gsub("Gyro", "Gyroscope", names(allData))
names(allData)<-gsub("Mag", "Magnitude", names(allData))
#remove "()"
names(allData)<-gsub("\\(\\)", "", names(allData))

#assign descriptive activity lables (for step 3)
allData$activity<- factor(allData$activity, levels = a_label[,1], labels = a_label[,2])
#make subject factor (for step 5)
allData$subject <- as.factor(allData$subject)

#Generate a second, independent tidy data set with the average 
#of each variable for each activity and each subject.
meltedData <- melt(allData, id = c("subject", "activity"))
tidyData <- cast(meltedData, subject + activity ~ variable, mean)
#write the data set to file
write.table(tidyData, "./tidy_dataset.txt", row.names = FALSE, quote = FALSE)