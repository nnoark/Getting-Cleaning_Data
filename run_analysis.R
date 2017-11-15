filename <- "getdata_projectfiles_UCI HAR Dataset.zip"

# Unzip filename
unzip(filename)

# Read Feature Files & Activity Files(both X & Y)

Xtrn <- read.table("./UCI HAR Dataset/train/X_train.txt")

Ytrn <- read.table("./UCI HAR Dataset/train/Y_train.txt")

Xts <- read.table("./UCI HAR Dataset/test/X_test.txt")

Yts <- read.table("./UCI HAR Dataset/test/Y_test.txt")

# Now time to read the Subject Files, Activity Lists, and the Feature Names

subTrn <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subTst <- read.table("./UCI HAR Dataset/test/subject_test.txt")

actLbl <- read.table("./UCI HAR Dataset/activity_labels.txt")
ftrName <- read.table("./UCI HAR Dataset/features.txt")

# Merging the X training data with X test data and the
# Y training data with Y test data

xMerged <- rbind(Xtrn, Xts)
yMerged <- rbind(Ytrn, Yts)

# Next, we merge the Subject data

subMrg <- rbind(subTrn, subTst)

# Then give names to each of the variables

names(subMrg) <- "subject"

names(yMerged) <- "activity"

names(xMerged) <- ftrName$V2

# Now merge all data

all_data <- cbind(xMerged, yMerged, subMrg)

# Next, extract the measurements on the mean and standard deviation on the 
# measurements

features_mean_std <- ftrName$V2[grep("mean\\(\\)|std\\(\\)", ftrName$V2)]

selectedColumns <- c(as.character(features_mean_std), "subject", "activity" )
all_data <- subset(all_data, select=selectedColumns)

all_data$activity <- actLbl[all_data$activity, 2]

## Getting closer. Add descriptive variable names to the data set


names(all_data) <-gsub("^t", "time", names(all_data))
names(all_data) <-gsub("^f", "frequency", names(all_data))
names(all_data) <-gsub("Acc", "accelerometer", names(all_data))
names(all_data) <-gsub("Gyro", "gyroscope", names(all_data))
names(all_data) <-gsub("Mag", "magnitude", names(all_data))
names(all_data) <-gsub("BodyBody", "body", names(all_data))

# Finally, create the tidy data set from all_data with the means of every variable in 
# each activity and subject

tidy_data <- ddply(all_data, .(subject, activity), function(x) colMeans(x[, 1:66]))

write.table(tidy_data, "tidy.txt", row.names = FALSE)
