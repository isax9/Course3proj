library(data.table)
library(reshape2)
setwd("C:/Users/isaxena/Desktop/Personal Documents/Coursera/Course 3 Data/course project/UCI HAR Dataset")
path <- getwd()
activityLabels <- fread(file.path(path, "activity_labels.txt"), col.names = c("classLabels", "activityName"))
features <- fread(file.path(path, "features.txt"), col.names = c("index", "featureNames"))

## Read train dataset
X_train <- fread(file.path(path, "train/X_train.txt"))
trainSubjects <- fread(file.path(path, "train/subject_train.txt"), col.names = c("SubjectNum"))
trainActivities <- fread(file.path(path, "train/Y_train.txt"), col.names = c("Activity"))
train <- cbind(trainSubjects, trainActivities, X_train)

## Read test dataset
X_test <- fread(file.path(path,"test/X_test.txt"))
testSubjects <- fread(file.path(path, "test/subject_test.txt"), col.names = c("SubjectNum"))
testActivities <- fread(file.path(path, "test/Y_test.txt"), col.names = c("Activity"))
test <- cbind(testSubjects, testActivities, X_test)

## Merge train and test datasets
merged <- rbind(train,test)

## Extracting only the mean and std dev measurements
featuresWanted <- grep("(mean|std)\\(\\)", features[, featureNames])
measurements <- features[featuresWanted, featureNames]
Filtered <- merged[, c(1,2,2+featuresWanted), with = FALSE]

## Use descriptive activity names to name activities in data set
Filtered[["Activity"]] <- factor(Filtered[, Activity], 
    levels = activityLabels[["classLabels"]], labels = activityLabels[["activityName"]])

## Labeling dataset with descriptive variable names
k <- names(Filtered)
k2 <- gsub("V","",k[3:length(k)])
k3 <- features[as.numeric(k2),2]
k4 <- k3[["featureNames"]]
names(Filtered)[3:length(k)] <- k4

## Creating tidy data set with average of each variable for each activity and subject
Filtered[["SubjectNum"]] <- as.factor(Filtered[, SubjectNum])
Filtered <- reshape2::melt(data = Filtered, id = c("SubjectNum", "Activity"))
Filtered <- reshape2::dcast(data = Filtered, SubjectNum + Activity ~ variable, mean)

## Exporting text file
write.table(Filtered,file="Final.txt",row.name=FALSE)
