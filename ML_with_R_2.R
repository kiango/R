## Training With R ##

# requiring 'caret' library and loading it
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
# . we only want 70% of data for training (p=0.7)
# . not create list but only 1 item per row (list = FALSE)
inTrainRows = createDataPartition(onTimeDataFiltered$ARR_DEL15, p=0.7, list = FALSE)

# check data
head(inTrainRows, 10)
# 70% of onTimeData
trainDataFiltered = onTimeDataFiltered[inTrainRows,]
# the rest 30% of onTimeData (by setting '-' before inTRainRows)
testDataFiltered = onTimeDataFiltered[-inTrainRows,]
# verify portion of training data frame (70%) relative to the original data
nrow(trainDataFiltered) / ( nrow(trainDataFiltered) + nrow(testDataFiltered) )
# outputs 0.70
# verify portion of testing data frames (30%) relative to the original data
nrow(testDataFiltered) / ( nrow(testDataFiltered) + nrow(trainDataFiltered) )
# outputs 0.30


# To train the model , use the Caret training function 'train'
# 'ARR_DEL15' name of the columns we try to project
# '~' separate values
# '.' (a period sign) all columns except those in the left side of tilde are used to predict the value
# data=trainDataFiltered training data frame
# method="glm" caret method is set to generalized linear regression (glm)
logisticRegModel = train(ARR_DEL15 ~ . ,data=trainDataFiltered, method="glm", family="binominal")
# get the generated statistics
logisticRegModel

# evaluate predictive capabilities of the model by 
# calling the predict function passing the 
# trained model (logisticRegModel) and the
# test data frame (testDataFiltered)
# It returns an object contains the predictions (logRegPrediction)
# ... we want to evaluate the flight delays ...
logRegPrediction = predict(logisticRegModel, testDataFiltered)
# when predictions are ready we can evaluate how well the model predicts flight delays
# using caret's confucionMatrix function (error matrix, provides statistics about the predictive model)
# we pass prediction object and the cols we are predicting into it:
logRegConfMat = confusionMatrix(logRegPrediction, testDataFiltered[, "ARR_DEL15"])
logRegConfMat

# confMatrix shows in the test data:
# no of flights with no delays in the test data and the model predict they will not be delayed:  7681 (A)
# were delayed and the model predicted it will not be delayed : 1900 (B)
# not delayed in the flight data but the model predicted that it would be delayed: 18 (C)
# were delayed and the model predict it would be delayed 38 (D)
# based on these confMatrix infor the statistics and standard measurements are calculated:
# Accuracy = A + D / # of test rows = A + D / A+B+C+D. ... 80% accuracy !

# Sensitivity: how the model predicts when there is no delay when it is no delay
# Sensitivity = A / A + C = 0.997 ... Excellent !

# Specificity: models ability to predict if there is delay when there is a delay
# Specificity = D / B+D = 0.0196 ... means the predicted delays of 38 is much smaller than the actual delays 1900!

# pos pred value : 0.8 no delay probability, good!
# neg pred value : 0.67, means there will be a delay probability, it is a poor accuracy!
