rm(list = ls())
library(ggplot2)
library(dplyr)

data = read.csv2("C:/Users/Gilia/Dropbox/PhD/Projects/2nd project - data collection/features_privacy.csv")
summary(data)

## if randomization is perfect then ATT = ATE
data %>%
  group_by(RESP_TREATED) %>%
  summarise(REVENUE = mean(RESP_REVENUE),
            REVENUE_sd = sd(RESP_REVENUE)/n(),
            n = n())

## the average treatment effect (ATE) of a physical flyer is 2.815
## alternatively we estimate the ATE with regression:
summary(lm("RESP_REVENUE ~ RESP_TREATED", data)) # average treatment effect is 2.815.

## Did randomization go well?
## estimate the propensity to treatment. we need to assume functional form and estimator to explain treatment. 
## if randomization is successful most of them are insignificant.
model_treatment = glm("RESP_TREATED ~ AGE_BUCKET + DAYS_SINCE_REG + GENDER  + PROVINCE + MIN_BALANCE_6_MONTHS + MAX_BALANCE_6_MONTHS + AVG_BALANCE_6_MONTHS + PARTNER_REDEMPTION_RATIO_12_MONTHS", data = data, family = "binomial")
summary(model_treatment)

## predict the treatment propensity
data$treatment_propensity = predict(model_treatment, data, type = "response")
summary(data$treatment_propensity)

## plot the propensity to treatment of treatment group and control group.
data$RESP_TREATED = as.factor(data$RESP_TREATED)
data %>% ggplot(aes(x = treatment_propensity, fill = RESP_TREATED)) + geom_density(alpha=0.2) + theme_minimal() + xlim(min(data$treatment_propensity),max(data$treatment_propensity))
data %>% ggplot(aes(x = treatment_propensity)) + facet_wrap(~RESP_TREATED) + geom_density(alpha=0.2) + theme_minimal() + xlim(min(data$treatment_propensity),max(data$treatment_propensity))

# Inverse Propensity Weighting
data$ipw_weights = ifelse(data$RESP_TREATED == 1, 1/data$treatment_propensity, 1/(1/data$treatment_propensity))

# weight the estimates with the inverse of being treated
summary(lm("RESP_REVENUE ~ RESP_TREATED", data = data, weights = ipw_weights))
## ATE 
coef(lm("RESP_REVENUE ~ RESP_TREATED", data = data, weights = ipw_weights))[2]
