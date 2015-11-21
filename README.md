Getting and Cleaning Data Course Project
===========

Summary
===========
This is an overview of the steps in run_analysis.R for Coursera Getting and Cleaning Data Course Project.
The script is designed to load HCI HAR Training and Test Datasets, supporting features, and subject files
and produce a tidy dataset containing Human Readable Activity, Subject Identifier and averages of all 'mean' and 'std' (standard deviation) variables. 

Processing Steps
===========
* Load Features file (features.txt) using read.csv function.
* Load Activity file (activity_labels.txt) using read.csv function.  Change columns in activities data frame using human readable names.
* Load Test activity set from 'test' directory.  NOTE: Use read_fwf using 'readr' library for large file processing.  Change data frame column names using 'features' names loaded from features.txt.
* Bind SUbject and Activity dataset to the data frame using cbind function.
* Repeat the same steps 4 and 5 to read 'training' data set.
* Bind Test and Training data frames using rbind.
* Subset data frame to include only columns that include 'mean' or 'std' in the name
* Change column names to make them more human readable by removing '(' and ')'
* Remove 'ActivityId', bound from activities data frame
* Use plyr to group by ActivityName and SubjectId columns
* Run summary with 'mean' function to get average for all variables
* Write tidy result (one observation per row, one variable per column) to a txt (tab delimited) file

Running Scrip
===========
* source('run_analysis.R')
* runAnalysis()