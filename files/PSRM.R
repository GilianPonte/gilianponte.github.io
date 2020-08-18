rm(list = ls())
library(arules)
library(ggplot2)
library(matlib)

## Load data
data("AdultUCI")

## change names to make a model and divide data set based on race
names(AdultUCI) = make.names(names(AdultUCI))
AdultUCI = na.omit(AdultUCI)
AdultUCI$income = ifelse(AdultUCI$income == "small", 0, 1)
AdultUCI$workclass = as.integer(AdultUCI$workclass)

## change variables and make simple model
model = glm(as.formula("income ~ age + workclass + education + education.num + marital.status + occupation + relationship + race + sex + capital.gain + capital.loss + hours.per.week + native.country"), data = AdultUCI, family = "binomial")
summary(model)
stargazer::stargazer(model)

## get predictions from model
AdultUCI$predictionprob = predict(model, AdultUCI, type = "response")
AdultUCI$prediction = ifelse(AdultUCI$predictionprob > .5, 1, 0)

## calculate accuracy per race
X <- split(AdultUCI, AdultUCI$race)
AdultUCIWhite = X$White
AdultUCIOther = X$Other
AdultUCIBlack = X$Black
AdultUCIAsianPacIslander = X$`Asian-Pac-Islander`
AdultUCIAmerIndianEskimo = X$`Amer-Indian-Eskimo`

## accuracy per race
Whiteaccuracy = sum(AdultUCIWhite$prediction == AdultUCIWhite$income)/nrow(AdultUCIWhite)
Whiteaccuracy
Otheraccuracy = sum(AdultUCIOther$prediction == AdultUCIOther$income)/nrow(AdultUCIOther)
Otheraccuracy
Blackaccuracy = sum(AdultUCIBlack$prediction == AdultUCIBlack$income)/nrow(AdultUCIBlack)
Blackaccuracy
AsianPacIslanderaccuracy = sum(AdultUCIAsianPacIslander$prediction == AdultUCIAsianPacIslander$income)/nrow(AdultUCIAsianPacIslander)
AsianPacIslanderaccuracy
AmerIndianEskimoaccuracy = sum(AdultUCIAmerIndianEskimo$prediction == AdultUCIAmerIndianEskimo$income)/nrow(AdultUCIAmerIndianEskimo)
AmerIndianEskimoaccuracy

## overall accuracy
overallaccuracy = sum(AdultUCI$prediction == AdultUCI$income)/nrow(AdultUCI)

accuracy = rbind(Whiteaccuracy, Otheraccuracy, Blackaccuracy, AsianPacIslanderaccuracy, AmerIndianEskimoaccuracy)
sd(accuracy)

## false negatives
fn <- sum(AdultUCIWhite$income > AdultUCIWhite$prediction)
fn1 = fn/nrow(AdultUCIWhite)*100

fn <- sum(AdultUCIBlack$income > AdultUCIBlack$prediction)
fn2 =fn/nrow(AdultUCIBlack)*100

fn <- sum(AdultUCIAmerIndianEskimo$income > AdultUCIAmerIndianEskimo$prediction)
fn3 = fn/nrow(AdultUCIAmerIndianEskimo)*100

fn <- sum(AdultUCIAsianPacIslander$income > AdultUCIAsianPacIslander$prediction)
fn4 = fn/nrow(AdultUCIAsianPacIslander)*100

fn <- sum(AdultUCIOther$income > AdultUCIOther$prediction)
fn5 = fn/nrow(AdultUCIOther)*100
fnoverall = rbind(fn1, fn2, fn3, fn4, fn5)
sd(fnoverall)
ggplot2::ggplot(AdultUCI, aes(x=race, y = income)) + geom_col()


# Gram schmidt ------------------------------------------------------------
## Gram Schmidt
X = cbind(AdultUCI$race, AdultUCI$income)
gs = GramSchmidt(X, normalize = F)
gs

AdultUCI$incomeGRAM = gs[,1]
AdultUCI$raceGRAM = gs[,2]

## change variables and make simple model
model = glm(as.formula("income ~ age + workclass + education + education.num + marital.status + occupation + relationship + raceGRAM + sex + capital.gain + capital.loss + hours.per.week + native.country"), data = AdultUCI, family = "binomial")
summary(model)

AdultUCI$predictionprobGRAM = predict(model, AdultUCI, type = "response")
AdultUCI$predictionGRAM = ifelse(AdultUCI$predictionprobGRAM > .5, 1, 0)
X <- split(AdultUCI, AdultUCI$race)

AdultUCIWhite = X$White
AdultUCIOther = X$Other
AdultUCIBlack = X$Black
AdultUCIAsianPacIslander = X$`Asian-Pac-Islander`
AdultUCIAmerIndianEskimo = X$`Amer-Indian-Eskimo`

## accuracy per race
Whiteaccuracy = sum(AdultUCIWhite$predictionGRAM == AdultUCIWhite$income)/nrow(AdultUCIWhite)
Whiteaccuracy
Otheraccuracy = sum(AdultUCIOther$predictionGRAM == AdultUCIOther$income)/nrow(AdultUCIOther)
Otheraccuracy
Blackaccuracy = sum(AdultUCIBlack$predictionGRAM == AdultUCIBlack$income)/nrow(AdultUCIBlack)
Blackaccuracy
AsianPacIslanderaccuracy = sum(AdultUCIAsianPacIslander$predictionGRAM == AdultUCIAsianPacIslander$income)/nrow(AdultUCIAsianPacIslander)
AsianPacIslanderaccuracy
AmerIndianEskimoaccuracy = sum(AdultUCIAmerIndianEskimo$predictionGRAM == AdultUCIAmerIndianEskimo$income)/nrow(AdultUCIAmerIndianEskimo)
AmerIndianEskimoaccuracy

accuracy = rbind(Whiteaccuracy, Otheraccuracy, Blackaccuracy, AsianPacIslanderaccuracy, AmerIndianEskimoaccuracy)
sd(accuracy)

overallaccuracy = sum(AdultUCI$predictionGRAM == AdultUCI$income)/nrow(AdultUCI)
overallaccuracy     

## plots
ggplot2::ggplot(AdultUCI, aes(x = race)) + geom_density()
ggplot2::ggplot(AdultUCI, aes(x=raceGRAM, y = incomeGRAM, fill = race, color = race)) + geom_density(position = "identity")
ggplot2::ggplot(AdultUCI, aes(x=race, y = ..count.., fill = race, color = race)) + geom_density()

cdplot(AdultUCI$incomeGRAM, as.factor(AdultUCI$raceGRAM))

## false negative, you are credit worthy however you dont receive credit
fn <- sum(AdultUCI$income > AdultUCI$predictionGRAM)
fncompletedata = fn/nrow(AdultUCI)*100


fn <- sum(AdultUCIWhite$income > AdultUCIWhite$predictionGRAM)
fn1 = fn/nrow(AdultUCIWhite)*100

fn <- sum(AdultUCIBlack$income > AdultUCIBlack$predictionGRAM)
fn2 = fn/nrow(AdultUCIBlack)*100

fn <- sum(AdultUCIAmerIndianEskimo$income > AdultUCIAmerIndianEskimo$predictionGRAM)
fn3 = fn/nrow(AdultUCIAmerIndianEskimo)*100

fn <- sum(AdultUCIAsianPacIslander$income > AdultUCIAsianPacIslander$predictionGRAM)
fn4 = fn/nrow(AdultUCIAsianPacIslander)*100

fn <- sum(AdultUCIOther$income > AdultUCIOther$predictionGRAM)
fn5 = fn/nrow(AdultUCIOther)*100

fnoverall = rbind(fn1, fn2, fn3, fn4, fn5)
sd(fnoverall)

