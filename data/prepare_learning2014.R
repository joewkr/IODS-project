# Yurii Batrak 4 November 2020
# Preprocess the input data set for exercise 2 of the IODS course

library(dplyr)

# The raw input data set consists of a table with 60 variables represented by
# 183 observations. Of these 60 rows the first 56 corresponds to the individual
# questions. The last for row provide some additional information about the
# students, their grades and general attitude towards statistics.
input_data_path <- 'http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt'
input_data <- read.table(input_data_path, sep='\t', header=TRUE)

# Combine grades from individual questions to corresponding variables
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

input_data$deep <- input_data %>% select(deep_questions     ) %>% rowMeans()
input_data$surf <- input_data %>% select(surface_questions  ) %>% rowMeans()
input_data$stra <- input_data %>% select(strategic_questions) %>% rowMeans()

# Convert all column names to lowercase
names(input_data) <- tolower(input_data %>% names())

# Select the required subset of the data by taking only the variables we need
# and excluding observations with 0 points.
out_columns <- c('gender', 'age', 'attitude', 'deep', 'stra', 'surf', 'points')
processed <- input_data %>% select(all_of(out_columns)) %>% filter(points > 0)

# Scale the attitude, which is a combinational variable, back to original units
processed$attitude <- processed$attitude/10

out_file_name <- 'learning2014.csv'
write.csv(processed, file=out_file_name, row.names=FALSE)

# Check that written data set is healthy
processed2 <- read.csv(out_file_name)
if (all.equal(processed, processed2)) {
  print('Written datset is healthy')
} else {
  print('Written datset is NOT healthy')
}

str(processed2)
head(processed2)
