## Training With R ##

# requiring 'caret' library
library(caret)
# random num generator (setting te seed make sure to output the same random sequence of numbers)
set.seed(122515)

# cols needed for training (as vector)
featuredCols = c("ARR_DEL15", "DAY_OF_WEEK", "CARRIER", "DEST", "ORIGIN", "DEP_TIME_BLK")

# create a new subset of onTimeData that only need these cols. 
# we unchange onTimeData to make it possible to reuse it again in another way if needed.
onTimeDataFiltered = onTimeData[,featuredCols]

# split into training and testing data
# make sure we have correct % of data rows in the training and test data
# make sure we have the same ratio of True / False as in the ARR_DEL_15
# caret 'createDataPartition': 
# . ensure the ARR_DEL_15 feature in training and test data, 70%
# . we only want 70% of data for training
# . not create list but only 1 item per row
inTrainRows = createDataPartition(onTimeDataFiltered$ARR_DEL15, p=0.7, list = FALSE)

# check data
head(inTrainRows, 10)
# 70% of onTimeData
trainDataFiltered = onTimeDataFiltered[inTrainRows,]
# the rest 30% of onTimeData
testDataFiltered = onTimeDataFiltered[-inTrainRows,]
# verify porpotion of training data frame (70%) relative to the original data
nrow(trainDataFiltered) / ( nrow(trainDataFiltered) + nrow(testDataFiltered) )
# outputs 0.70
# verify porpotion of testing data frames (30%) relative to the original data
nrow(testDataFiltered) / ( nrow(testDataFiltered) + nrow(trainDataFiltered) )
# outputs 0.30
