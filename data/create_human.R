# Yurii Batrak 18 November 2020
# Preprocess the input data set for exercise 5 of the IODS course, part 1

library(dplyr)
library(stringr)

url_prefix <- 'http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets'
hd  <- read.csv(paste(url_prefix, 'human_development.csv', sep='/'), stringsAsFactors = F)
gii <- read.csv(paste(url_prefix, 'gender_inequality.csv', sep='/'), stringsAsFactors = F, na.strings = "..")

str(hd)
dim(hd)

str(gii)
dim(gii)

names(hd) <- c(
    'hdiRank'
  , 'country'
  , 'hdi'          # Human development index
  , 'lifeE'        # Life expectancy at birth
  , 'eduE'         # Expected years of education
  , 'eduMean'      # Mean years of education
  , 'gni'          # Gross national income per capita
  , 'gniRMinusHdiR'# GNI per capita rank minus HDI rank
  )
names(gii) <- c(
    'giiRank'
  , 'country'
  , 'gii'          # Gender inequality index
  , 'mmRatio'      # Maternal mortality ratio
  , 'adlBirthRate' # Adolescent birth rate
  , 'parliamentF'  # Percent representation in parliament
  , 'edu2F'        # Population with secondary education, Female
  , 'edu2M'        # Population with secondary education, Male
  , 'labF'         # Labour force participation rate, Female
  , 'labM'         # Labour force participation rate, Male
  )

# Add new variables:
#   edu2Ratio --  ratio of Female and Male populations with secondary education
#   labRatio  --  ratio of labour force participation of Female and Male population
gii <- gii %>% mutate(
    edu2Ratio = edu2F/edu2M
  , labRatio  = labF/labM)

# Merge the input data sets to produce the final output
merged <- inner_join(hd, gii, by = 'country')
dim(merged)

# Transform GNI to numeric form
merged$gni <- merged$gni %>% str_replace(pattern=",", replace ="") %>% as.numeric

# Drop last 7 obs because they represent regions and not individual countries
last <- nrow(merged) - 7
merged <- merged[1:last, ]

columns_to_keep <- c(
    'country'
  , 'edu2Ratio'
  , 'labRatio'
  , 'eduE'
  , 'lifeE'
  , 'gni'
  , 'mmRatio'
  , 'adlBirthRate'
  , 'parliamentF'
)

# Select only the needed variables and drop NA obs
merged <- merged %>% select(one_of(columns_to_keep)) %>% filter(complete.cases(merged))

# Set the column names
rownames(merged) <- merged$country
merged <- merged %>% select(-country)

write.csv(merged, file='human.csv', row.names=TRUE)
