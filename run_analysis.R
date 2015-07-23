#Download the file and put the file in the data folder
fileUrl <- "http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip",method="auto")

#Unzip the file
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#Read data from the files
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
#Create 'x' data set
x_data <- rbind(x_train, x_test)
#Create 'y' data set
y_data <- rbind(y_train, y_test)
#Create 'subject' data set
subject_data <- rbind(subject_train, subject_test)

#Extracts only the measurements on the mean and standard deviation for each measurement
features <- read.table("./data/UCI HAR Dataset/features.txt")
Data <- grep("-(mean|std)\\(\\)", features[, 2])
x_data <- x_data[, Data]
names(x_data) <- features[Data, 2]

#Uses descriptive activity names to name the activities in the data set
activities <- read.table("./data/UCI HAR Dataset/activity_labels.txt")
y_data[, 1] <- activities[y_data[, 1], 2]
#correct column name
names(y_data) <- "activity"

#Appropriately labels the data set with descriptive variable names
names(subject_data) <- "subject"
#bind all data in one data set
new <- cbind(x_data, y_data, subject_data)

#Create a second, independent tidy data set with the average of each variable
#for each activity and each subject
library(plyr)
tidy <- ddply(new, .(subject, activity), function(x) colMeans(x[, 1:66]))
write.table(tidy, file = "tidy_data.txt",row.name=FALSE)
