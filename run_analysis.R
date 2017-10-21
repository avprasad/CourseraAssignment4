library(dplyr)
if(!file.exists("./data")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")
# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

# load the information related to the train data set 
# note that the file is present in folder UCI HAR Dataset in the current working directory
Xtrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
Ytrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subjectTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# load the information related to test data set 
# note that the file is present in folder UCI HAR Dataset in the current working directory
Xtest <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
Ytest <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# read data description as variable names 
variableNames <- read.table("./data/UCI HAR Dataset/features.txt")

# read activity labels
activityLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt")

# 1. Merges the training and the test sets to create one data set.
XTotal <- rbind(X_train, X_test)
YTotal <- rbind(Y_train, Y_test)
subjectTotal <- rbind(Sub_train, Sub_test)

# 2. Extract only the measurements on the mean and standard deviation for each measurement.
# The regular expression is used here to pull Mean and Standard Deviation values 
variableSelect <- variable_names[grep("mean\\(\\)|std\\(\\)",variable_names[,2]),]
XTotal <- XTotal[,variableSelect[,1]]

# 3. Uses descriptive activity names to name the activities in the data set
colnames(YTotal) <- "activity"
YTotal$activitylabel <- factor(YTotal$activity, labels = as.character(activity_labels[,2]))
activitylabel <- YTotal[,-1]

# 4. Appropriately name the data set with descriptive variable names.
colnames(XTotal) <- variable_names[variableSelect[,1],2]

# 5. Using the data set created in previous step convert it into a seperate file tidydata.txt
colnames(subjectTotal) <- "subject"
total <- cbind(XTotal, activitylabel, subjectTotal)
meanTotal <- total %>% group_by(activitylabel, subject) %>% summarize_all(funs(mean))
write.table(total_mean, file = "./data/tidydata.txt", row.names = FALSE, col.names = TRUE)
