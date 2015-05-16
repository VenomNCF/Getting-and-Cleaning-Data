#This script reads, cleans, and outputs tidy data

##Get data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/dataset.zip")
mydata = unzip(zipfile="./data/Dataset.zip",exdir="./data")
setwd("./data/UCI HAR Dataset")

##Define individual training and test sets
Labels_Test <- read.table("./test/y_test.txt", col.names="label")
Subject_Test <- read.table("./test/subject_test.txt",col.names="subject")
Data_Test <- read.table("./test/X_test.txt")
Labels_Train <- read.table("./train/y_train.txt",col.names="label")
Subject_Train <- read.table("./train/subject_train.txt",col.names="subject")
Data_Train <- read.table("./train/X_train.txt")
Features <- read.table("features.txt",strip.white=TRUE, stringsAsFactors=FALSE)

##Merge data into one dataset
newdataset <- rbind(cbind(Subject_Test, Labels_Test, Data_Test),
              cbind(Subject_Train, Labels_Train, Data_Train))

##Extract mean and standard deviation for each measurement
FeaturesMeanStdDev <- Features[grep("mean\\(\\)|std\\(\\)", Features$V2), ]
DataMeanStdDev <- newdataset[,c(1,2,FeaturesMeanStdDev$V1+2)]

##Name activities in the dataset
Labels_Activity<-read.table("activity_labels.txt", stringsAsFactors=FALSE)
LabelNames <- Labels_Activity[DataMeanStdDev$label,2]

##Label with descriptive variable names
VarNames <- c("subject", "label", FeaturesMeanStdDev$V2)
VarNames <- tolower(gsub("[^[:alpha:]]", "", VarNames))

##Create tidy dataset
newdataset2 <- aggregate(DataMeanStdDev[, 3:ncol(DataMeanStdDev)],by=list(subject = DataMeanStdDev$subject, 
                               label = DataMeanStdDev$label),mean)

write.table(format(newdataset2,scientific=T),"tidydataset.txt",row.name=FALSE,col.names=FALSE,quote=2)

