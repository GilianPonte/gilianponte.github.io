
---
title: "A Very Simple Membership Inference Attack"
published: true
layout: archive
editor_options:
  chunk_output_type: inline
---

*20 March, 2022*

In this post, I show you in R how easy it is to infer whether an observation was part of the training dataset. This is known as a membership inference attack (see e.g., Carlini et al. 2021). Inferring whether an individual is part of the training dataset may not seem like a significant privacy violation, but it is actually connected with a theoretical privacy definition: differential privacy.

## The Setting

Consider the case where you have access to a complete dataset of customers. Scientific papers often require firms to publish the trained model they used to predict a certain outcome variable. Let's say, in this case, whether a customer left the firm (churn). While this prediction problem may not seem privacy-sensitive, our attack could also be applied to the prediction of a disease.

First, let's load some packages (which I assume you have installed).

```r
rm(list = ls())
library(rpart.plot)
library(data.table)
library(tidyverse)
library(ggplot2)
```

The first step is to load all the data. The data is available at: [membership_inference_data.RData](https://github.com/GilianPonte/membership_inference/blob/main/membership_inference_data.RData "membership_inference_data.RData") and should be placed in your working directory.

```r
## Load all required objects
load("/membership_inference_data.rData")
```

The following files have been loaded into your working directory:

1. The churn data, where you do not know which observation was in the training set or test set.

```r
print(head(churn2)) ## Churn dataset with 1,666 obs.
```

2. A trained model. In this case, we will work with a decision tree trained to predict churn.

```r
rpart.plot(tree)
```

## The Membership Inference Attack

The model was trained by an analyst who assumed the following data generating process:

$$
Churn = f(AccountLength, IntlPlan, VMailPlan, DayMins, DayCalls, EveMins, EveCalls, NightMins, NightCalls, IntlMins, IntlCalls, CustServCalls)
$$

In other words, churn is some function of several explanatory variables used by an analyst to predict whether a customer churns. In R, this looks as follows:

```r
independent <- "AccountLength + IntlPlan + VMailPlan + DayMins + DayCalls + EveMins + EveCalls + NightMins + NightCalls + IntlMins + IntlCalls + CustServCalls"
BaseFormula <- as.formula(paste0("Churn ~ ", independent))
print(BaseFormula)
```

Next, we use the trained model to predict over all the observations.

```r
predictions <- predict(tree, newdata = churn2, type = "prob") # Obtain predictions
print("Churn predictions")
head(predictions[1,2])

print("True churn")
head(churn2$Churn[1])
```

The big assumption that researchers make is that the observations used in the training set will have a smaller prediction error (though this may not always be the case, e.g., with outliers, but it is generally effective). Next, we use the predictions from the trained model to calculate the error:

$$
error = churn - predictions
$$

This looks as follows in R:

```r
churn2$Churn = as.numeric(churn2$Churn) - 1
error = churn2$Churn - predictions[,2]
print(head(error))
```

Take the absolute value of the error, then sort the error from high to low. It is advised to take the absolute value of the error because the true churn probability can be underestimated or overestimated. In R:

```r
error = abs(error)
plot(error)
```

We sort the error from low to high, assuming that low error implies presence in the training set.

```r
sorted = data.frame(sort(error, decreasing = F)) # Sort ascending
sorted = as.data.frame(setDT(sorted, keep.rownames = TRUE)[]) # Row numbers to a column in data frame
colnames(sorted) = c("rn","error")
ggplot(sorted, aes(x = as.numeric(reorder(rn,-error)), y = as.numeric(error))) + geom_point() + ylab("Error") + xlab("Row Number") + theme(axis.text.x = element_text(angle = -90))
```

We simply select the first 1,666 observations and say they are in the training set!

```r
in_training = sorted[1:1666,] # Get the first 1,666 observations with the lowest error
in_training$rn = as.numeric(in_training$rn) # Make row number numeric
in_training$train_prediction = 1 # Assign label that the data point is in the training set
```

We combine the predictions with the original dataset.

```r
churn2$rn = as.numeric(row.names(churn2)) # Store row number
churn2$train = c(rep(1, 1666), rep(0, 1667)) # Assign true labels
accuracy = left_join(churn2, in_training) # Join predictions/error with the original dataset, based on row number
accuracy[is.na(accuracy$train_prediction),22] = 0 # Values that are missing = 0 (not in the training set)
head(accuracy[,c(20,22)])
```

Finally, we calculate the accuracy of our membership inference attack!

```r
print(sum(accuracy$train_prediction == churn2$train) / 3333 * 100) ## 80% accuracy!
```

We have identified 80% of the individuals in the training set correctly!
