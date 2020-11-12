# Yurii Batrak 9 November 2020
# Preprocess the input data set for exercise 3 of the IODS course
# Original dataset is retrieved from https://archive.ics.uci.edu/ml/datasets/Student+Performance

library(dplyr)

input_mat <- read.table('data/student-mat.csv', sep=';', header=TRUE)
input_por <- read.table('data/student-por.csv', sep=';', header=TRUE)

# List of variables for joining two data sets
join_by <- c(
    "school"
  , "sex"
  , "age"
  , "address"
  , "famsize"
  , "Pstatus"
  , "Medu"
  , "Fedu"
  , "Mjob"
  , "Fjob"
  , "reason"
  , "nursery"
  , "internet")

math_por <- inner_join(input_mat, input_por, by = join_by, suffix=c('.mat', '.por'))
alc <- select(math_por, one_of(join_by))

# Merge the rest of the variables
mat_names <- input_mat %>% colnames
notjoined_columns <- mat_names[!mat_names %in% join_by]
notjoined_columns

for(column_name in notjoined_columns) {
  two_columns <- select(math_por, starts_with(column_name))
  first_column <- select(two_columns, 1)[[1]]

  if(is.numeric(first_column)) {
    alc[column_name] <- round(rowMeans(two_columns))
  } else {
    alc[column_name] <- first_column
  }
}

# Define the high alcohol consumption variable based on the responses
# about the workday and weekend alcohol consumption.
alc <- alc %>% mutate(alc_use = (Dalc + Walc)/2, high_use = alc_use > 2)

glimpse(alc)

out_file_name <- 'alc.csv'
write.csv(alc, file=out_file_name, row.names=FALSE)
