fil <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"

download.file(fil, destfile = "W4.zip")

unzip("W4.zip") 

getwd()
library("data.table")


M <- read.table("UCI HAR Dataset/features.txt")
M[,2] <- as.character(M[,2])
MS <- grep(".*mean.*|.*std.*", M[,2])
MSN <- M[MS,2]
P <- read.table("UCI HAR Dataset/test/X_test.txt")[MS]
PA <- read.table("UCI HAR Dataset/test/Y_test.txt")
PS <- read.table("UCI HAR Dataset/test/subject_test.txt")
P <- cbind(PS, PA, P)

##Verify nrow is the same

T <- read.table("UCI HAR Dataset/train/X_train.txt")[MS]
TA <- read.table("UCI HAR Dataset/train/Y_train.txt")
TS <- read.table("UCI HAR Dataset/train/subject_train.txt")
T <- cbind(TS, TA, T)

##Verify nrow is the same

L <- read.table("UCI HAR Dataset/activity_labels.txt")
L[,2] <- as.character(L[,2])
Tabla <- rbind(T, P)
colnames(Tabla) <- c("subject", "activity", MSN)
library(reshape2)
Tabla$activity <- factor(Tabla$activity, levels = L[,1], labels = L[,2])
Tabla$subject <- as.factor(Tabla$subject)
Tablaj <- melt(Tabla, id = c("subject", "activity"))
Tablap <- dcast(Tablaj, subject + activity ~ variable, mean)
write.table(Tablap, file = "tidy.txt", row.names = FALSE)