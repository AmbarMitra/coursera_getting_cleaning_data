#load required packages
library(dplyr)

##set the working directory to the UCI HAR Dataset folder where the required folders files reside
#read the txt files activity_labels and features
setwd("./UCI HAR Dataset")
activity_labels <- read.table("activity_labels.txt")
#modify the column names in the activity_labels dataframe for ease in merging later
activity_labels <- activity_labels %>% rename(activity_id = V1, activity_name = V2)
features <- read.table("features.txt")

##set the working directory to the test folder to read the files residing here
#read the x_test, y_test and subj_test txt files and carry out required manipulations
setwd(paste0("./test"))
x_test <- read.table("X_test.txt")
y_test <- read.table("y_test.txt")
subj_test <- read.table("subject_test.txt")
#change the column names of x_test dataframe using the features dataframe
names(x_test) <- features$V2
#rename the column names in the subj_test and y_test dataframes as these will be combined with x_test going ahead
subj_test <- subj_test %>% rename(subject_id = V1)
y_test <- y_test %>% rename(activity_id = V1)
#select only those subset of variables in x_test that have mean() or std() in them
#for mean() I have used the regular expression [m][e][a][n][(][)] as there are variable names containing 'mean' that are not mean()
x_test_lim <- x_test[,grepl("[m][e][a][n][(][)]", names(x_test))|grepl("std()", names(x_test))]
#combine the subj_test, y_test and the subsetted x_test
test <- cbind(subj_test, y_test, x_test_lim)

##set the working directory to the train folder to read the files residing here
#read the x_train, y_train and subj_train txt files and carry out required manipulations
setwd(paste0("../"))
setwd(paste0("./train"))
x_train <- read.table("X_train.txt")
subj_train <- read.table("subject_train.txt")
y_train <- read.table("y_train.txt")
#change the column names of x_train dataframe using the features dataframe
names(x_train) <- features$V2
#rename the column names in the subj_train and y_train dataframes as these will be combined with x_train going ahead
subj_train <- subj_train %>% rename(subject_id = V1)
y_train <- y_train %>% rename(activity_id = V1)
#select only those subset of variables in x_train that have mean() or std() in them
#for mean() I have used the regular expression [m][e][a][n][(][)] as there are variable names containing 'mean' that are not mean()
x_train_lim <- x_train[,grepl("[m][e][a][n][(][)]", names(x_train))|grepl("std()", names(x_train))]
#combine the subj_train, y_train and the subsetted x_train
train <- cbind(subj_train, y_train, x_train_lim)

#combine the train and test dataframes to one dataset using rbind
test_train_dataset <- rbind(test, train)
#bring in the activity names by merging with the activity_labels dataframe on the activity_id column
test_train_dataset <- merge(test_train_dataset, activity_labels, by = "activity_id", all.x = TRUE, all.y = FALSE)
#remove the () and - symbols from variable name as these were causing issues with summarise
names(test_train_dataset) <- gsub("\\()", "", names(test_train_dataset))
names(test_train_dataset) <- gsub("-", "", names(test_train_dataset))
#create a new tidy dataset based on the test_train_dataset by grouping by subject_id and activity_name and then use summarise to take average of all numeric variables
new_dataset <- test_train_dataset %>% group_by(subject_id, activity_name) %>% summarize(avgTimeBodyAcceleration_mean_X = mean(tBodyAccmeanX),
                                                                                        avgTimeBodyAcceleration_mean_Y = mean(tBodyAccmeanY),
                                                                                        avgTimeBodyAcceleration_mean_Z = mean(tBodyAccmeanZ),
                                                                                        avgTimeBodyAcceleration_std_X = mean(tBodyAccstdX),
                                                                                        avgTimeBodyAcceleration_std_Y = mean(tBodyAccstdY),
                                                                                        avgTimeBodyAcceleration_std_Z = mean(tBodyAccstdZ),
                                                                                        avgTimeGravityAcceleration_mean_X = mean(tGravityAccmeanX),
                                                                                        avgTimeGravityAcceleration_mean_Y = mean(tGravityAccmeanY),
                                                                                        avgTimeGravityAcceleration_mean_Z = mean(tGravityAccmeanZ),
                                                                                        avgTimeGravityAcceleration_std_X = mean(tGravityAccstdX),
                                                                                        avgTimeGravityAcceleration_std_Y = mean(tGravityAccstdY),
                                                                                        avgTimeGravityAcceleration_std_Z = mean(tGravityAccstdZ),
                                                                                        avgTimeBodyAcceleration_mean_X = mean(tBodyAccJerkmeanX),
                                                                                        avgTimeBodyAcceleration_mean_Y = mean(tBodyAccJerkmeanY),
                                                                                        avgTimeBodyAcceleration_mean_Z = mean(tBodyAccJerkmeanZ),
                                                                                        avgTimeBodyAcceleration_std_X = mean(tBodyAccJerkstdX),
                                                                                        avgTimeBodyAcceleration_std_Y = mean(tBodyAccJerkstdY),
                                                                                        avgTimeBodyAcceleration_std_Z = mean(tBodyAccJerkstdZ),
                                                                                        avgTimeBodyGyro_mean_X = mean(tBodyGyromeanX),
                                                                                        avgTimeBodyGyro_mean_Y = mean(tBodyGyromeanY),
                                                                                        avgTimeBodyGyro_mean_Z = mean(tBodyGyromeanZ),
                                                                                        avgTimeBodyGyro_std_X = mean(tBodyGyrostdX),
                                                                                        avgTimeBodyGyro_std_Y = mean(tBodyGyrostdY),
                                                                                        avgTimeBodyGyro_std_Z = mean(tBodyGyrostdZ),
                                                                                        avgTimeBodyGyroJerk_mean_X = mean(tBodyGyroJerkmeanX),
                                                                                        avgTimeBodyGyroJerk_mean_Y = mean(tBodyGyroJerkmeanY),
                                                                                        avgTimeBodyGyroJerk_mean_Z = mean(tBodyGyroJerkmeanZ),
                                                                                        avgTimeBodyGyroJerk_std_X = mean(tBodyGyroJerkstdX),
                                                                                        avgTimeBodyGyroJerk_std_Y = mean(tBodyGyroJerkstdY),
                                                                                        avgTimeBodyGyroJerk_std_Z = mean(tBodyGyroJerkstdZ),
                                                                                        avgTimeBodyAccelerationMagnitude_mean = mean(tBodyAccMagmean),
                                                                                        avgTimeBodyAccelerationMagnitude_std = mean(tBodyAccMagstd),
                                                                                        avgTimeGravityAccelerationMagnitude_mean = mean(tGravityAccMagmean),
                                                                                        avgTimeGravityAccelerationMagnitude_std = mean(tGravityAccMagstd),
                                                                                        avgTimeBodyAccelerationJerkMagnitude_mean = mean(tBodyAccJerkMagmean),
                                                                                        avgTimeBodyAccelerationJerkMagnitude_std = mean(tBodyAccJerkMagstd),
                                                                                        avgTimeBodyGyroMagnitude_mean = mean(tBodyGyroMagmean),
                                                                                        avgTimeBodyGyroMagnitude_std = mean(tBodyGyroMagstd),
                                                                                        avgTimeBodyGyroJerkMagnitude_mean = mean(tBodyGyroJerkMagmean),
                                                                                        avgTimeBodyGyroJerkMagnitude_std = mean(tBodyGyroJerkMagstd),
                                                                                        avgFrequencyBodyAcceleration_mean_X = mean(fBodyAccmeanX),
                                                                                        avgFrequencyBodyAcceleration_mean_Y = mean(fBodyAccmeanY),
                                                                                        avgFrequencyBodyAcceleration_mean_Z = mean(fBodyAccmeanZ),
                                                                                        avgFrequencyBodyAcceleration_std_X = mean(fBodyAccstdX),
                                                                                        avgFrequencyBodyAcceleration_std_Y = mean(fBodyAccstdY),
                                                                                        avgFrequencyBodyAcceleration_std_Z = mean(fBodyAccstdZ),
                                                                                        avgFrequencyBodyAccelerationJerk_mean_X = mean(fBodyAccJerkmeanX),
                                                                                        avgFrequencyBodyAccelerationJerk_mean_Y = mean(fBodyAccJerkmeanY),
                                                                                        avgFrequencyBodyAccelerationJerk_mean_Z = mean(fBodyAccJerkmeanZ),
                                                                                        avgFrequencyBodyAccelerationJerk_std_X = mean(fBodyAccJerkstdX),
                                                                                        avgFrequencyBodyAccelerationJerk_std_Y = mean(fBodyAccJerkstdY),
                                                                                        avgFrequencyBodyAccelerationJerk_std_Z = mean(fBodyAccJerkstdZ),
                                                                                        avgFrequencyBodyGyro_mean_X = mean(fBodyGyromeanX),
                                                                                        avgFrequencyBodyGyro_mean_Y = mean(fBodyGyromeanY),
                                                                                        avgFrequencyBodyGyro_mean_Z = mean(fBodyGyromeanZ),
                                                                                        avgFrequencyBodyGyro_std_X = mean(fBodyGyrostdX),
                                                                                        avgFrequencyBodyGyro_std_Y = mean(fBodyGyrostdY),
                                                                                        avgFrequencyBodyGyro_std_Z = mean(fBodyGyrostdZ),
                                                                                        avgFrequencyBodyMagnitudeAcceleration_mean = mean(fBodyAccMagmean),
                                                                                        avgFrequencyBodyMagnitudeAcceleration_std = mean(fBodyAccMagstd),
                                                                                        avgFrequencyBodyAccelerationJerkMagnitude_mean = mean(fBodyBodyAccJerkMagmean),
                                                                                        avgFrequencyBodyAccelerationJerkMagnitude_std = mean(fBodyBodyAccJerkMagstd),
                                                                                        avgFrequencyBodyGyroMagnitude_mean = mean(fBodyBodyGyroMagmean),
                                                                                        avgFrequencyBodyGyroMagnitude_std = mean(fBodyBodyGyroMagstd),
                                                                                        avgFrequencyBodyGyroJerkMagnitude_mean = mean(fBodyBodyGyroJerkMagmean),
                                                                                        avgFrequencyBodyGyroJerkMagnitude_std = mean(fBodyBodyGyroJerkMagstd))


#change the working directory to UCI HAR Dataset folder and write the new tidy dataset as a txt file
write.table(new_dataset, "tidy_dataset.txt", row.names = FALSE)

