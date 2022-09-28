---
title: "Your first membership inference attack"
published: true
layout: archive
editor_options:
  chunk_output_type: inline
-

```{r setup, include=FALSE}
rm(list = ls())
library(rpart.plot)
library(data.table)
library(tidyverse)
library(ggplot2)
```

The first step is to load all the data. The data is available at: [membership_inference_data.RData](https://github.com/GilianPonte/membership_inference/blob/main/membership_inference_data.RData "membership_inference_data.RData") and place it in your working directory.

```{r}
## load all required objects
load("C:/Users/Gilia/Dropbox/PhD/Conferences/2022/MARUG/workshop/membership_inference_data.rData")
```

The following files have been loaded into your working directory:

## Churn data

```{r}
print(head(churn2)) ## churn data set with 1,666 obs.
```

## Trained model

Decision tree used to predict churn:

```{r}
rpart.plot(tree)
```

##  Use the trained model to predict churn over the entire data set.

The model was trained as follows:

$Churn = AccountLength + IntlPlan + VMailPlan + DayMins + DayCalls + EveMins + EveCalls + NightMins + NightCalls + IntlMins + IntlCalls + CustServCalls$

```{r}
independent <- ("AccountLength + IntlPlan + VMailPlan + DayMins + DayCalls + EveMins + 
EveCalls + NightMins + NightCalls + IntlMins + IntlCalls + CustServCalls")
BaseFormula <- as.formula(paste0("Churn ~ ", independent))
print(BaseFormula)
```

Next, we use the trained model to predict over all the observations.

```{r}
predictions <- predict(tree, newdata = churn2, type = "prob") # obtain predictions
print("churn predictions")
head(predictions[1,2])

print("true churn")
head(churn2$Churn[1])
```

## Calculating the error.

We use the predictions to calculate the error: $error = churn - predictions$.

```{r}
churn2$Churn = as.numeric(churn2$Churn)-1
error = churn2$Churn - predictions[,2]
print(head(error))
```

Take the absolute value of the error, sort the error from high to low.

```{r}
error = abs(error)
plot(error)
```

We sort the error from low to high. Assuming that low error = training set!

```{r}
sorted = data.frame(sort(error, decreasing =F)) # sort descending.
sorted = as.data.frame(setDT(sorted, keep.rownames = TRUE)[]) # row numbers to a column in data frame.
colnames(sorted) = c("rn","error")
ggplot(sorted, aes(x = as.numeric(reorder(rn,-error)), y = as.numeric(error))) + geom_point() + ylab("error") + xlab("row number") + theme(axis.text.x = element_text(angle = -90))
```

## Simply select the first 1,666 observations and say they are in training set!

```{r}
in_training = sorted[1:1666,] # get the first 1,666 observations that have the highest loss
in_training$rn = as.numeric(in_training$rn) # make row number numeric
in_training$train_prediction = 1 # assign label that the data point is in training set.
```

## Combine the predictions with the original data set.

```{r}
churn2$rn = as.numeric(row.names(churn2)) # store row number.
churn2$train = c(rep(1, 1666), rep(0,1667)) # assign true labels.
accuracy = left_join(churn2, in_training) # join predictions/error with the original data set, based on row number. 
accuracy[is.na(accuracy$train_prediction),22] = 0 # the values that are missing = 0. In other words, they are not in the training set.
head(accuracy[,c(20,22)])
```

## Calculate the accuracy!

```{r}
print(sum(accuracy$train_prediction == churn2$train)/3333 * 100) ## 80% accuracy!
```
