install.packages("bnlearn")
install.packages("caret")
install.packages("naivebayes")
install.packages("e1071")
install.packages("randomForest")
install.packages("neuralnet")

library(bnlearn)
library(caret)
library(naivebayes)
library(e1071)
library(randomForest)
library(neuralnet)

#These are the model functions. 
#This is assuming that the data is already split into training and test sets

#Bayesian Network
network = hc(training) #Learn Structure
fittedNetwork = bn.fit(network, training) #Learning Parameters
BN_pred = predict(fittedNetwork, "Glioblastoma", test)
BN_results = sum(BN_pred == test$Glioblastoma)/length(BN_pred)

#Classical Naive Bayes
CNB_mod = naive_bayes(Glioblastoma ~ ., data = training)
CNB_pred = predict(CNB_mod, test, type = "class")
CNB_results = sum(CNB_pred == test$Glioblastoma)/length(CNB_pred)

#KNN
KNN_mod = knn3(Glioblastoma ~ ., data = training, k = 25)
KNN_pred = predict(KNN_mod, test, type = "class")
KNN_results = sum(KNN_pred == test$Glioblastoma)/length(KNN_pred)

#SVM
SVM_mod = svm(Glioblastoma ~ ., data = training)
SVM_pred = predict(SVM_mod, test, type = "class")
SVM_results = sum(SVM_pred == test$Glioblastoma)/length(SVM_pred)

#Random Forest
RF_mod = randomForest(Glioblastoma ~ ., data = training)
RF_pred = predict(RF_mod, test, type = "class")
RF_results = sum(RF_pred== test$Glioblastoma)/length(RF_pred)

#Artifical Neural Network
ANN_mod = train(Glioblastoma ~ ., data = training, method = "nnet")
ANN_pred = predict(ANN_mod, test, type = "raw")
ANN_results = sum(ANN_pred == test$Glioblastoma)/length(ANN_pred)


