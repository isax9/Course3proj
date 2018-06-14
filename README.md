The attached script works by importing the test and train datasets and loading them into data tables.
Subsequently, these two datasets are merged, and then only the measurements containing "mean" or "std" are extracted from them.
The activity numbers in the activity column are replaced explicitly by the activity names
The variable names (column names) are replaced by the corresponding measurement name, to make the columns more descriptive
Finally the data set is melted and casted to summarize the means for each variable, for each activity and subject
The tidy data set above is exported to text file
