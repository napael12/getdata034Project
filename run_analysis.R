library(readr)
library(dplyr)

runAnalysis<-function() {
  
  #assume the file is in UCI HAR Dataset, otherwise set working directory
  #setwd("UCI HAR Dataset")
  
  #load features
  features<-read.csv("features.txt", header = F, sep = " ", stringsAsFactors = F, col.names = c("FeatureId", "FeatureName"))
  
  #load activity labels
  activities<-read.csv("activity_labels.txt", header = F, sep=' ')
  #name columns
  colnames(activities)<-c("ActivityId", "ActivityName")
  
  
  #load test subject
  testActivity<-read.csv("test/y_test.txt", header=F, col.names = c("ActivityId"))
 
  #load test subjects
  testSubject<-read.csv("test/subject_test.txt", header=F, col.names = c("SubjectId")) 
  
  #load test dataset 261 columns, 16 chars each
  testSet<-read_fwf("test/X_test.txt", fwf_widths(rep(16,561)), progress = interactive())
  
  #change column names
  colnames(testSet)<-features$FeatureName
  
  #bind test
  testSetA<-cbind(testSubject, testSet)
  testSetA<-cbind(testActivity, testSetA)
  
  #load train subject
  trainActivity<-read.csv("train/y_train.txt", header=F, col.names = c("ActivityId"))
  
  #load test subjects
  trainSubject<-read.csv("train/subject_train.txt", header=F, col.names = c("SubjectId")) 
  
  #load train dataset 261 columns, 16 chars each
  trainSet<-read_fwf("train/X_train.txt", fwf_widths(rep(16,561)), progress = interactive())
     
  #change column names based on features data set
  colnames(trainSet)<-features$FeatureName
  

  #bind test and training sets
  activitySet<-rbind(testActivity,trainActivity)
  subjectSet<-rbind(testSubject,trainSubject)
  resultSet<-rbind(testSet, trainSet) 
  
  
  #include only columns w. 'mean' | 'std' identifiers
  meanStdResultSet<- resultSet[, grep("mean|std", colnames(resultSet))]
  
  #attach activity and subject sets
  workSet<-cbind(activitySet, meanStdResultSet)
  workSet<-cbind(subjectSet, workSet)
  
  #cleanup column names by removing '()'
  colnames(workSet)<-gsub("\\(|\\)", "", colnames(workSet))
  
  #merge with 'friendly' activity names
  workSet<-merge(activities, workSet)
  
  #remove 'unfriendly' activity id
  workSet<-workSet[,-1]

  #group by and summarize calculating mean for all variables
  wSummary<-workSet %>%
  group_by(ActivityName, SubjectId) %>%
  summarise_each(funs(mean))
  
  #write tidy data to file (assume tab delimited 'txt' file)
  write.table(wSummary, file = "dataTidy.txt", row.names = F, sep="\t")

  print("Done!")
  
  
}

  
