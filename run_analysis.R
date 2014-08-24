

testDataX<-read.table("UCI HAR Dataset/test/X_test.txt")

testDataY<-read.table("UCI HAR Dataset/test/y_test.txt")

testDataSubject<-read.table("UCI HAR Dataset/test/subject_test.txt")

testData<-cbind(testDataSubject,testDataY,testDataX) #subject movement measurements


trainDataX<-read.table("UCI HAR Dataset/train/X_train.txt")

trainDataY<-read.table("UCI HAR Dataset/train/y_train.txt")

trainDataSubject<-read.table("UCI HAR Dataset/train/subject_train.txt")

trainData<-cbind(trainDataSubject,trainDataY,trainDataX)

dim(trainData)
dim(testData)

allData<-rbind(testData,trainData)

features <-read.table("UCI HAR Dataset/features.txt",stringsAsFactors = FALSE)

dim(allData)
dim(features)

namesVector<-c("subject","movement",features$V2)

names(allData)<-namesVector

meanStdIDX<-grep("mean|std|movement|subject",names(allData))

dataMeanStd <- allData[meanStdIDX]

activityLabels <-read.table("UCI HAR Dataset/activity_labels.txt",stringsAsFactors = FALSE)

names(activityLabels)<-c("movement","movementString")

dataMeanStdActivityLabels<-merge(activityLabels,dataMeanStd,all=TRUE)


library(reshape2)

meltData <- melt(dataMeanStdActivityLabels, id=c("subject","movement","movementString"))

tidyData <- dcast(meltData, subject + movement + movementString ~ variable, mean)

write.table(tidyData, file="tidyData.txt", row.names=FALSE)

