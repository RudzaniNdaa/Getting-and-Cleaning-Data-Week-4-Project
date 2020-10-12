## getting and loading data
if(!file.exists("data")) {
  dir.create("data")
}

fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fileUrl, destfile = "./data/dataset.zip")
?unzip
samsung_data <- unzip(zipfile = "./data/dataset.zip", exdir = "./data")

##Store data
?read.table
x_train <- read.table(file = "./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table(file = "./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table(file = "./data/UCI HAR Dataset/train/subject_train.txt")
x_test <- read.table(file = "./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table(file = "./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table(file = "./data/UCI HAR Dataset/test/subject_test.txt")
features <- read.table(file = "./data/UCI HAR Dataset/features.txt")
activitylabels <- read.table(file = "./data/UCI HAR Dataset/activity_labels.txt")

##load package
library(tidyverse)

## renaming variables
colnames(x_test) <- as.character(features[,2])
colnames(x_train) <- as.character(features[,2])
colnames(subject_test) <- "SubjectID"
colnames(subject_train) <- "SubjectID"
colnames(y_test) <- "ActivityiD"
colnames(y_train) <- "ActivityiD"
colnames(activitylabels) <- c("ActivityiD","ActivityType")

## merging data
?bind_cols
Training_data <- bind_cols(x_train, y_train, subject_train)
Testing_data <- bind_cols(x_test, y_test, subject_test)
?bind_rows
# NB: bind by rows because data has same column names 
Final_data <- bind_rows(Training_data, Testing_data)

## Extracts only the measurements on the mean and 
## standard deviation for each measurement.
Filtered_final <- Final_data %>% 
  select(contains(c("mean","std")))

## data set with average of each variable
Average_final <- Filtered_final %>% 
  summarise_if(is.numeric, mean) 

## writing the Average_final data set into a text file
write.table(Average_final, "Average_final.txt", row.names = FALSE)
