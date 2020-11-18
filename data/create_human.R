# Yurii Batrak 18 November 2020
# Preprocess the input data set for exercise 5 of the IODS course, part 1

library(dplyr)

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

gii <- gii %>% mutate(
    edu2Ratio = edu2F/edu2M
  , labRatio  = labF/labM)

merged <- inner_join(hd, gii, by = 'country')
dim(merged)

write.csv(merged, file='data/human.csv', row.names=FALSE)
