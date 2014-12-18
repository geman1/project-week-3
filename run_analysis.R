# This first part  merges the test and the training sets into one data set:
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt", header = FALSE)
x_test <- read.table("./UCI HAR Dataset/test/X_test.txt", header = FALSE)
y_train <- read.table("./UCI HAR Dataset/train/y_train.txt", header = FALSE)
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt", header = FALSE)
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt", header = FALSE)
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt", header = FALSE)
X <- rbind(X_train, x_test)
Y <- rbind(y_train, y_test)
S <- rbind(subject_train, subject_test)

# Part 2 extracts the measurements on the mean and standard deviation for each measurement
features <- read.table("./UCI HAR Dataset/features.txt")

names(features) <- c('feature_id', 'feature_name')
features_ID <- grep("-mean\\(\\)|-std\\(\\)", features$feature_name) 
x <- x[, features_ID] 
names(x) <- gsub("\\(|\\)", "", (features[features_ID, 2]))

# part 3 use descriptive activity names to name the activities in the data set.
# part 4 labels accordingly the data set with descriptive activity names.
activities <- read.table("./UCI HAR Dataset/activity_labels.txt")
names(activities) <- c('act_id', 'act_name')
y[, 1] = activities[y[, 1], 2]
names(y) <- "Activity"
names(s) <- "Subject"
tidy_data <- cbind(S, Y, X)
write.table (tidy_data, file="tidy_data", row.name=FALSE)

# part 5 creates a second, independent tidy data set with the average of each variable for each activity and each subject from the data set in step 4
avg <- tidy_data[, 3:dim(tidy_data)[2]] 
avg_tidy_data <- aggregate(avg,list(tidy_data$Subject, tidy_data$Activity), mean)
names(avg_tidy_data)[1] <- "Subject"
names(avg_tidy_data)[2] <- "Activity"
write.table(avg_tidy_data, file="avg_tidy_data", row.name=FALSE)
