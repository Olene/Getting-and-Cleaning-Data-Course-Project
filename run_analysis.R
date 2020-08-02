# Download and unzip data
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file( url, destfile = "data.zip" )
unzip("data.zip")

# Set working directory
setwd("C:/Users/Олена/Documents/Data Scienca/UCI HAR Dataset")

# Read features and activity labels
features <- read.table("./features.txt")
activity_labels <- read.table("./activity_labels.txt")

# Read test data
x_test   <- read.table("./test/X_test.txt")
y_test   <- read.table("./test/Y_test.txt") 
sub_test <- read.table("./test/subject_test.txt")

# Read train data
x_train   <- read.table("./train/X_train.txt")
y_train   <- read.table("./train/Y_train.txt") 
sub_train <- read.table("./train/subject_train.txt")

# Merges the training and the test sets to create one data set.
x_total   <- rbind(x_train, x_test)
y_total   <- rbind(y_train, y_test) 
sub_total <- rbind(sub_train, sub_test) 

# Extracts only the measurements on the mean and standard deviation for each measurement.
nfeatures <- features[grep(".*mean\\(\\)|std\\(\\)", features[,2], ignore.case = FALSE),]
x_total      <- x_total[,nfeatures[,1]]

# Uses descriptive activity names to name the activities in the data set
colnames(y_total) <- "activity"
y_total$activitylabel <- factor(y_total$activity, labels = as.character(activity_labels[,2]))
activitylabel <- y_total[,-1]

# Appropriately labels the data set with descriptive variable names.
colnames(x_total) <- features[nfeatures[,1],2]

# From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
colnames(sub_total) <- "subject"
total <- cbind(x_total, activitylabel, sub_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)