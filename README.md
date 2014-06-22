#Markdown file for run_analysis.R
===================================

#library packages required : plyr, sqldf,tcltk, reshape2 and Hmisc

#Steps:
#=====
#Part 1:
#Read all relevant files into dataframes
#Relevant files are the feature translation file, activity label file and for the test and training data, the subject file, data(X) file and activity(Y) list file
#Set the column names on the test and train data (X) files from the values in the feature file.
#Strip out any special characters and trim the files to only include those columns with mean() and std() values
#Assign descriptive column names to the subject and activity list files for train and test
#Combine the subject, activity list and the data file using cbind() for test and train files separately
#Merge the test and train combined files by rows using sql function 
# Add activity label by activity number 

#Part 2:
#Transform to a narrow dataframe using melt function to assist in average calculation
# Using dcast function, transform back to a wide package with the averages for the mean and std deviation columns by subject and activity number
#Save resulting dataframe into a text file Tidyfile.txt using Write.table functio

#Reading the file Tidyfile.txt:
#File has 68 columns and 180 rows
#File has headers included for each column
#Use read.table with header=TRUE to read file into a dataframe

