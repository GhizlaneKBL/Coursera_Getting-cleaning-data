
# 1- Download and unzip the dataset:
if(!file.exists("./FinalProject")){dir.create("./FinalProject")}
fileurl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileurl, destfile = "./FinalProject/projectdataset.zip")
setwd("./FinalProject")
unzip("./projectdataset.zip") 

# 2- Load and merge the datasets:
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
test<- cbind(x_test, y_test, subject_test)

x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
train<-cbind(x_train, y_train, subject_train)

FinalData<-rbind(test, train)
rm("x_test", "y_test", "subject_test", "x_train", "y_train", "subject_train", "test", "train")


# 3- Add label:
activityLabels <- read.table("UCI HAR Dataset/activity_labels.txt")
features <- read.table("UCI HAR Dataset/features.txt")
colnames(FinalData)<- c(features[,2],"subject", "activity")
FinalData$activity <- factor(FinalData$activity, levels = activityLabels[,1], labels = activityLabels[,2])
rm("features", "activityLabels")

# 4- Extract only the data on mean and standard deviation:
NamesFD<- names(FinalData)
mean_std<- grep(".mean.|.std.|subject|activity", NamesFD)
FinalData<- FinalData[ ,mean_std]

# 5- creating a second data set with the average of each variable for each activity and each subject
FinalData_avg <- aggregate(. ~subject + activity, FinalData, mean)
FinalData_avg <- FinalData_avg[order(FinalData_avg$subject, FinalData_avg$activity), ]
write.table(FinalData_avg, "tidy.txt", row.names = FALSE, quote = FALSE)

