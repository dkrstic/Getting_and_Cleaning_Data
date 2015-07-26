#Download the file and put the file in the data folder
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile="./data/Dataset.zip",method="auto")

#Unzip the file
unzip(zipfile="./data/Dataset.zip", exdir="./data")

#Read the Activity files
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")

#Read the Subject files
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

#Read Features files
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")

#Merges the training and the test sets to create one data set
x_ds <- rbind(x_train, x_test)
y_ds <- rbind(y_train, y_test)
subject_ds <- rbind(subject_train, subject_test)

#Extracts only the measurements on the mean and standard deviation for each measurement
features <- read.table("./data/UCI HAR Dataset/features.txt")
measurements <- grep("-(mean|std)\\(\\)", features[, 2])
x_ds <- x_ds[, measurements]

#Uses descriptive activity names to name the activities in the data set
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
y_ds[, 1] <- activities[y_ds[, 1], 2]

#Appropriately labels the data set with descriptive variable names
names(x_ds) <- features[measurements, 2]
names(y_ds) <- "activity"
names(subject_ds) <- "subject"

#Bind all data in one data set
ds <- cbind(x_ds, y_ds, subject_ds)

#Creates a second, independent tidy data set with the average of each variable for each activity and each subject
library(plyr)
tidy_data <- ddply(ds, .(subject, activity), .fun=function(x) colMeans(x[, 1:length(measurements)]))
write.table(tidy_data, "tidy_data.txt", row.name=FALSE)
