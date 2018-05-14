rm(list = ls())
library(neuralnet)
library(data.table)
library(dplyr)

## setseed for randomization
set.seed(123)

## load data
fashion_train <- fread("C:/Users/Gilia/Documents/fashion_train.csv")
fashion_test <- fread("C:/Users/Gilia/Documents/fashion_test.csv") 
fashiondata <- rbind(fashion_test, fashion_train)
fashiondata <- fashiondata %>% filter(label == 0 | label == 1 | label == 2)
str(fashiondata)

## save the label for after scaling
label <- fashiondata$label 
fashiondata$label <- NULL
summary(label)

## Standardizing data for the NN
maxs <- apply(fashiondata, 2, max) 
mins <- apply(fashiondata, 2, min)
scaled <- as.data.frame(scale(fashiondata, center = mins, scale = maxs - mins))

# Encode as a one hot vector multilabel data
labels <- cbind(label, class.ind(as.factor(label)))

# Set labels name
colnames(labels) <- c("label", "l0", "l1","l2")
fashiondata <- cbind(labels, scaled)

# Random sampling
samplesize = 0.90 * nrow(fashiondata)
index = sample(seq_len(nrow(fashiondata)), size = samplesize )

# Create training and test set
fashion_train = fashiondata[index,]
fashion_test = fashiondata[-index,]

# remove label from training and test data
fashion_test$label <- NULL
fashion_train$label <- NULL

# check if label is removed and scaling and sampling worked
str(fashion_train)
str(fashion_test)

# neural net
n <- names(fashion_train)
f <- as.formula(paste("l0 + l1 + l2 ~", paste(n[!n %in% c("l0", "l1", "l2")], collapse = " + ")))

# fit your neural network (this might take some time)
neuralnetwork <- neuralnet(f, data = fashion_train, hidden = 2, linear.output = F)

# check the weights of your neural network
plot(neuralnetwork)

# predict for test data
pr.nn <- neuralnet::compute(neuralnetwork, fashion_test[, 3:786])
pr.nn$net.result
results <- as.data.frame(pr.nn$net.result)

# Examine accuracy of test set
resultsrounded <- round(results)

# get the column with highest probability
original_values <- max.col(fashion_test[,1:3])
test_values <- max.col(results)

# calculate accuracy
mean(test_values == original_values)
