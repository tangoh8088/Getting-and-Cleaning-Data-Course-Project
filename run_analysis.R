##Download zip file
if (!file.exists("data")){ 
  url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(url, "data")
}

##Unzip zip file
if (!file.exists("UCI HAR Dataset")) { 
  unzip("data") 
}

##Get activity labels and features
actlab <- read.table("UCI HAR Dataset/activity_labels.txt")
actlab$V2 <- as.character(actlab$V2)
features <- read.table("UCI HAR Dataset/features.txt")
features$V2 <- as.character(features$V2)

##Load data sets
trainset <- read.table("UCI HAR Dataset/train/X_train.txt")
trainlab <- read.table("UCI HAR Dataset/train/y_train.txt")
trainsub <- read.table("UCI HAR Dataset/train/subject_train.txt")

testset <- read.table("UCI HAR Dataset/test/X_test.txt")
testlab <- read.table("UCI HAR Dataset/test/y_test.txt")
testsub <- read.table("UCI HAR Dataset/test/subject_test.txt")

##Edit features names
featuresnames <- gsub("-mean", "Mean", features$V2)
featuresnames <- gsub("-std", "Std", features$V2)
featuresnames <- gsub("[-()]", "", features$V2)

##Merge data sets
train <- cbind(trainset, trainlab, trainsub)
test <- cbind (testset, testlab, testsub)
datset <- rbind(train,test)

##Extract only measurements on the mean and standard deviation
featuressub <- grep(".*[mM]ean.*|.*[sS]td.*",features$V2)
featuresnew <- features[featuressub,]
colsneed <- c(featuressub,562,563)
newdat <- datset[,colsneed]
colnames(newdat) <- c(featuresnew$V2, "activity", "subject")
colnames(newdat) <- tolower(colnames(newdat))

##Convert activities and subjects into factors
newdat$activity <- factor(newdat$activity, levels = actlab[,1], labels = actlab[,2])
newdat$subject <- as.factor(newdat$subject)

##Create second, independent tidy data set
meltnewdat <- melt(newdat, id = c("subject", "activity"))
newdatave <- dcast(meltnewdat, subject+activity ~ variable,mean)

write.table(newdatave, "tidy.txt", row.names = FALSE)
