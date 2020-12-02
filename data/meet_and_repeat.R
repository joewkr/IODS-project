# Yurii Batrak 30 November 2020
# Preprocess the input data set for exercise 6 of the IODS course

library(dplyr)

url_prefix <- 'https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data'

# Load the data sets in the wide form
bprs <- read.table(paste(url_prefix, 'BPRS.txt', sep='/'), sep = ' ',  header = TRUE)
rats <- read.table(paste(url_prefix, 'rats.txt', sep='/'), sep = '\t', header = TRUE)

dim(bprs)
str(bprs)
summary(bprs)

# Treatment and subject id are factor variables
bprs$treatment <- factor(bprs$treatment)
bprs$subject   <- factor(bprs$subject)

# Convert the BPRS data set to the long form
bprs_long <- bprs %>% 
  gather(key = weeks, value = bprs, -treatment, -subject) %>% 
  mutate(week = weeks %>% substr(5,5) %>% as.integer)

dim(bprs_long)
str(bprs_long)
summary(bprs_long)

dim(rats)
str(rats)
summary(rats)

# Rat id and rat group are factor variables
rats$ID    <- factor(rats$ID)
rats$Group <- factor(rats$Group)

# Convert the rats data set to the long form
rats_long <- rats %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(time = WD %>% substr(3,4) %>% as.integer)

dim(rats_long)
str(rats_long)
summary(rats_long)

# Use lowercase for the column names
names(rats_long) <- names(rats_long) %>% tolower

write.csv(bprs_long, file='bprs.csv', row.names=FALSE)
write.csv(rats_long, file='rats.csv', row.names=FALSE)
