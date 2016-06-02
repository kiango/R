# Modeling data with the new algorithm 'Random Forest'.
# Random forest is an 'ensemble learning' method for classification, regression etc.
# import the randomForest
library(randomForest)

# train the model with this algorithm. We run the algorithm with standard constructor
# traindDataFiltered[-1]: creates a new data frame which excludes the first column
# the col to predict for: trainDataFiltered$ARR_DEL15
rfModel = randomForest(trainDataFiltered[-1], trainDataFiltered$ARR_DEL15, proximity = TRUE, importance = TRUE)

# using the random forest to find which flights on the test data will be delayed:
rfValidation = predict(rfModel, testDataFiltered)

# evaluate the performance of the model by look at confusion matrix
rfConfMat = confusionMatrix(rfValidation, testDataFiltered[,"ARR_DEL15"])

# check the confusion matrix now:
rfConfMat

# Evaluation:
# specificity improved 6 times from .0196 to .1197
# number of delay predictions increase from 38 to 232
