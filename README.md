The run_analysis.R R script contained in this repository does the required manipulations on the test and train data to get the required tidy dataset as required in this assignment.
This script has been written with the assumption that the 'UCI HAR Dataset' folder used in this assignment resides within the working directory of the system it is being run in.
The script executes the following steps:
1. First it loads the required dplyr package (assuming it is already installed)
2. Next it sets the working directory to the UCI HAR Dataset folder where the required folders and files reside
3. Next it reads the txt files activity_labels and features. Here we also modify the column names in the activity_labels dataframe for ease in merging later
4. Next the working directory is set to the 'test' folder to read the files residing here
5. Then we read the x_test, y_test and subj_test txt files
6. Then we change the column names of 'x_test' dataframe using the 'features' dataframe
7. We rename the column names in the 'subj_test' and 'y_test' dataframes as these will be combined with 'x_test' going ahead
8. We select only those subset of variables in 'x_test' that have mean() or std() in them as we need only the mean and standard deviation variables
9. Then we combine the subj_test, y_test and the subsetted x_test using cbind()
10. After this we set the working directory to the 'train' folder and repeat the steps that we carried out for 'test' folder (steps 5-9) changing the names as required
11. We combine the train and test dataframes to one dataset using rbind
12. Then we bring in the activity names to this combined dataset by merging with the 'activity_labels' dataframe on the activity_id column (this we had earlier defined in activity_labels during column name change and also in y_test/y_train)
13. Remove the () and - symbols from variable name as these were causing issues with summarise
14. Then create a new tidy dataset based on the combined dataset by grouping by subject_id and activity_name and then use summarise to take average of all numeric variables
15. Finally we change the working directory to 'UCI HAR Dataset' folder and write the new tidy dataset as a txt file to this folder

I have chosen this format for tidy data set as it satisfies the caveat of each variable being in a separate column and each row corresponding to an observation for a subject and an activity and also each variable having a properly descriptive name
I have chosen not to narrow down the format by defining another column for X,Y,Z directions as this would result in inducing NAs in some of the data for variables that dont have these directions
I have not created a separate key column for mean and standard deviation as this would be bringing a variable component into a separate record
