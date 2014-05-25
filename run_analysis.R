#Download data for project
fileUrl <-"http://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, destfile = "Dataset.zip", method = "curl")

#Step 1 -> Merges the training and the test sets to create one data set.
Test <- read.table ("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
Testlabels <- read.table ("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
Testsubjects <-read.table ("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
Training <- read.table ("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
TrainLabel <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
Trainsubject <-read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)
joinData <- rbind(Test,Training)
joinLabel <-rbind(Testlabels,Trainlabel)
joinSubject <-rbind(Testsubjects,Trainsubject)

#Step 2 -> Extracts only the measurements on the mean and standard deviation for each measurement.
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE)
measurement <- grep("mean\\(\\)|std\\(\\)", features[, 2])
joinData <- joinData [,measurement]
names(joinData) <-features [measurement,2]
#Step 3 ->Uses descriptive activity names to name the activities in the data set
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE)
activities[, 2] <- tolower(gsub("_", "", activities[, 2]))
activLabel <- activities[joinLabel[,1],2]
joinLabel[, 1] <- activLabel
names(joinLabel) <- "activity"
#Step 4 -> Appropriately labels the data set with descriptive activity names.
names(joinSubject) <- "subject"
cleanData <- cbind(joinSubject,joinLabel,joinData)
write.table(cleanData, "clean_data.txt")

#Step5 -> Creates a second, independent tidy data set with the average of each 
#variable for each activity and each subject.
DT <- data.table(cleanData)
tidy<-DT[,lapply(.SD,mean),by="activity,subject"]
write.table(tidy,"tidy_data.txt")

