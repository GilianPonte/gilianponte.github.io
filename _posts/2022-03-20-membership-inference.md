---
title: "Your first membership inference attack"
published: true
layout: archive
editor_options:
  chunk_output_type: inline
---
*20 March, 2022*

In this post, I show you in R how easy it is to infer whether an observation was part of the training data set. Something the scientific community calls a membership inference attack (see e.g., Carlini et al. 2021). To infer whether an individual is part of the training data set may not seem as such a big privacy violation but it is actually connected with a theoretical privacy definition: differential privacy. 

## The setting
Consider the case where you have assess to a complete data set of customers. As a requirement scientific papers of firms publish the trained model that they used to predict a certain outcome variable. Let's say in this case whether a customer left the firm (churn). In this case the prediction problem is not that privacy-sensitive but our attack could be applied to the prediction of a disease as well.

Let's first load some packages (which I assume you have installed).

```{r}
rm(list = ls())
library(rpart.plot)
library(data.table)
library(tidyverse)
library(ggplot2)
```

The first step is to load all the data. The data is available at: [membership_inference_data.RData](https://github.com/GilianPonte/membership_inference/blob/main/membership_inference_data.RData "membership_inference_data.RData") and place it in your working directory.

```{r}
## load all required objects
load("/membership_inference_data.rData")
```

The following files have been loaded into your working directory:

1. The churn data of which you do not know which observation was in the training set or test set.

```{r}
print(head(churn2)) ## churn data set with 1,666 obs.
```

2. A trained model. In this case we will work with a decision tree that is trained to predict churn.

```{r}
rpart.plot(tree)
```

## The membership inference attack
The model was trained by an analyst that assumed the following data generating process:

$Churn = f(AccountLength, IntlPlan, VMailPlan, DayMins, DayCalls, EveMins, EveCalls, NightMins, NightCalls, IntlMins, IntlCalls, CustServCalls)$.

In other words, churn is some function of some explanatory variables that are used by an analyst to predict whether a customer churns. In R this looks as follows:

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

The big assumption that researchers make is that the observations that are used in the training set will have a smaller prediction error (this may not always be the case, e.g., outliers. But this is generally very effective). Next, we use the predictions from the trained model to calculate the error: $error = churn - predictions$. This looks as follows in R:

```{r}
churn2$Churn = as.numeric(churn2$Churn)-1
error = churn2$Churn - predictions[,2]
print(head(error))
```

Take the absolute value of the error, then sort the error from high to low. I advice to take the absolute value of the error because the true churn probability can be underestimated or overestimated. In R:

```{r}
error = abs(error)
plot(error)
```

We sort the error from low to high. Assuming that low error implies presence in the training set.

```{r}
sorted = data.frame(sort(error, decreasing =F)) # sort descending.
sorted = as.data.frame(setDT(sorted, keep.rownames = TRUE)[]) # row numbers to a column in data frame.
colnames(sorted) = c("rn","error")
ggplot(sorted, aes(x = as.numeric(reorder(rn,-error)), y = as.numeric(error))) + geom_point() + ylab("error") + xlab("row number") + theme(axis.text.x = element_text(angle = -90))
```

We simply select the first 1,666 observations and say they are in training set!

```{r}
in_training = sorted[1:1666,] # get the first 1,666 observations that have the highest loss
in_training$rn = as.numeric(in_training$rn) # make row number numeric
in_training$train_prediction = 1 # assign label that the data point is in training set.
```

We combine the predictions with the original data set.

```{r}
churn2$rn = as.numeric(row.names(churn2)) # store row number.
churn2$train = c(rep(1, 1666), rep(0,1667)) # assign true labels.
accuracy = left_join(churn2, in_training) # join predictions/error with the original data set, based on row number. 
accuracy[is.na(accuracy$train_prediction),22] = 0 # the values that are missing = 0. In other words, they are not in the training set.
head(accuracy[,c(20,22)])
```

and we can calculate the accuracy of our membership inference attack!

```{r}
print(sum(accuracy$train_prediction == churn2$train)/3333 * 100) ## 80% accuracy!
```

We have identified 80% of the individuals in the trainingset as part of the training set!
