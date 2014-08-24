# The working directory has the be the parent directory of this file

# 1)Merges the training and the test sets to create one data set. 
# read the testing data from several sources:
testDataX<-read.table("UCI HAR Dataset/test/X_test.txt")

testDataY<-read.table("UCI HAR Dataset/test/y_test.txt")

testDataSubject<-read.table("UCI HAR Dataset/test/subject_test.txt")
#combine all the test data:
testData<-cbind(testDataSubject,testDataY,testDataX) #subject movement measurements

# read the training data from several sources:
trainDataX<-read.table("UCI HAR Dataset/train/X_train.txt")

trainDataY<-read.table("UCI HAR Dataset/train/y_train.txt")

trainDataSubject<-read.table("UCI HAR Dataset/train/subject_train.txt")
# combine all the training data:
trainData<-cbind(trainDataSubject,trainDataY,trainDataX)

# making sure the dimensions match:
dim(trainData)
dim(testData)

# merging the testing and training data:
allData<-rbind(testData,trainData)


features <-read.table("UCI HAR Dataset/features.txt",stringsAsFactors = FALSE)

# making sure the dimensions match:
dim(allData)
dim(features)

# 4) Appropriately labels the data set with descriptive variable names. 
namesVector<-c("subject","movement",features$V2)

names(allData)<-namesVector

# 2) Extracts only the measurements on the mean and standard deviation for each measurement. 

meanStdIDX<-grep("mean|std|movement|subject",names(allData))

dataMeanStd <- allData[meanStdIDX]


# 3) Uses descriptive activity names to name the activities in the data set
# read the activity_labels  containing the types of movements

activityLabels <-read.table("UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE)

# assign the activities to the data
names(activityLabels)<-c("movement","movementString")

dataMeanStdActivityLabels<-merge(activityLabels,dataMeanStd,all=TRUE)

# 5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

library(reshape2)

meltData <- melt(dataMeanStdActivityLabels, id=c("subject","movement","movementString"))

tidyData <- dcast(meltData, subject + movement + movementString ~ variable, mean)

# saving the tidy data
write.table(tidyData, file="tidyData.txt", row.names=FALSE)

