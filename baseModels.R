
# Load the required libraries
library(class)
library(readr)
library(MASS)
library(e1071)
set.seed(1)

# Load a subsmaple
targetData <- read_csv("ip_counts.csv")

targetData <- targetData[sample(nrow(targetData)), ] 
# Re-assign the labels originally removed during partitioning
names(targetData) <- c('ip', 'app', 'device', 'os', 'channel','click_time', 'attributed_time', 'is_attributed','ip_counts')
# Subset selection
#targetData <- trainData[sample(10000), ]
# Convert the datetime to numeric value
targetData$click_time <- as.numeric(targetData$click_time)  

# Split the data to training and test set
Idx <- sample(floor(nrow(targetData) * 0.8))
trainSet <- targetData[Idx,]
testSet <- targetData[-Idx,]


trainSample=trainSet
summary(trainSample)

#########
#########

# Logistic Regression 

#########
#########

#Train
logReg = glm(is_attributed ~ ip+app+device+os+channel, data = trainSample,family = "binomial")
#Test
pred=predict(logReg, testSet, type="response")
#Output
probs = rep(1, length(pred))  #Error
probs[pred > 0.5] = 0
table(probs, !testSet$is_attributed)
mean(probs != testSet$is_attributed)

#########
#########

# LDA

#########
#########

#Train
modelLDA = lda(is_attributed ~ ip+app+device+os+channel, data = trainSample)
#Test
pred = predict(modelLDA, testSet)$class
#Output
table(pred, testSet$is_attributed)
mean(pred == testSet$is_attributed)


#########
#########

#   QDA

#########
#########

#Train
qdaFit = qda(is_attributed~ip+app+device+os+channel, data = trainSample)
#Test
pred = predict(qdaFit, testSet)$class
#Output
table(pred, testSet$is_attributed)
QDA = mean(pred == testSet$is_attributed)
mean(pred == testSet$is_attributed)


#########
#########

# KNN

#########
#########

#Train
knn3 <- knn(trainSample, testSet, trainSample$is_attributed, k=3)
#Test
sum(testSet$is_attributed == knn3) / nrow(testSet)


#########
#########

# SVM

#########
#########

#Train
SVM_LIN <- svm(is_attributed~ip+app+device+os+channel, trainSample, kernel = "linear", cost = 0.01)
#Test
pred <- predict(SVM_LIN, testSet)
probs = rep(1, length(pred))  #Error
probs[pred > 0.5] = 0
table(probs, !testSet$is_attributed)
mean(probs != testSet$is_attributed)




