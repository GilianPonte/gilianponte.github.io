# Measuring and comparing predictive power of churn estimation methods
*26th of June 2018*

![Churn](https://d2mkz4zdclmlek.cloudfront.net/images/articles/what-is-customer-churn.png)

# Summary
This article presents a comparative study of churn estimation methods. Telecommunication providers can no longer rely on a steady customer base. Machine learning methods are applied to the problem of customer churn in the telecommunications industry. A logistic regression, decision trees, bagging, boosting and a neural network are estimated and evaluated by comparative performance measures. The results show that bagging performs better than decision trees, boosting, neural network and a logistic regression.

1. Keywords: Churn, machine learning, logistic regression, neural network, bagging, boosting, decision tree, gini coefficient, top decile lift and hit rate.
2. Programming language: R
3. Reading time: 10 min
4. This article is part of a larger paper, which is available upon request.
5. The R code is available [here](https://github.com/GilianPonte/gilianponte.github.io/blob/master/ChurnData.R).


# Introduction

Customer relationship management is a strategy based on of building, managing and strengthen the relationship with customers (Vafeiadis, et al., 2015). Predicting churn and preventing customers from churning can save companies hundreds of thousands of dollars (Neslin, et al., 2006). The cost of attracting new customers is twelve times the cost of retaining your existing customers. Moreover, service providers can no longer rely on a steady customer base. In telecom service industries churn rates range from 23.4% to 46% (Neslin, et al., 2006). 

This makes customer churn a significant problem for companies. Hence, getting a clear view of which customers are likely to churn enables companies to focus on customers that are likely to churn and reactivate them (Neslin, et al, 2006). This study uses a dataset from an anonymous telecom provider.

# Problem statement

Numerous studies have described methods for predicting customer churn (Kim & Yoon, 2004: Ahn, Han & Lee, 2006: Neslin, et al., 2006: Risselada, Verhoef & Bijmolt, 2010: Nie, et al., 2011: Lu, Lin, Lu & Zhang, 2014:  Vafeiadis, et al., 2015). Predicting customer churn entails a decision in terms of a nominal variable, where zero describes no cancellation of the contract and one means the customer cancelled the contract. 

Methods that become relevant when the dependent variable, churn or no churn, is a binary decision are decision trees, logistic regression, neural networks, random forest, support vector machines, bagging and boosting (Neslin, et al., 2006: Günther, et al., 2011: Vafeiadis, et al., 2015). Respectively, all of these techniques when estimated have proved to have predictive power for predicting customer churn. However, there is little knowledge of modern techniques for predictive customer churn. Modern techniques need to be explored to find methodologies that might possess more predictive power (Neslin, et al., 2006: Risselada, Verhoef & Bijmolt, 2010). 

Au et al. (2003) propose that neural networks outperform decision trees on large datasets. Also, experimental results showed that a neural network outperformed logistic regression and decision trees for churn prediction (Mozer et al., 2000). Ha, Cho & Maclachlan (2005) find that a neural network outperforms boosting and bagging. Therefore, this study compares the predictive power of a neural network with a decision tree, a logistic regression, bagging and boosting to predict churn using the dataset of an anonymous telecom provider.

# Decision tree
All the variables available in the dataset are used for the estimation of the decision tree presented in figure 2 is estimated. As in the following formula:

*Pr⁡(Churn)~ f(AccountLength, TotalCharge, TotalCalls, TotalMinutes, IntlPlan, VoiceMailPlan, VoiceMailMessage, DayMinutes, DayCharge, DayCalls, EveMinutes, EveCharge, EveCalls, NightMinutes, NightCharge, NightCalls, CustServCalls)*

The probability of churning is a function of all the variables available in the dataset. All the variables in the dataset were added, as decision trees are very robust and are not able to identify significant variables, but only judges them on importance (Bishop, 2006). 

![varimportancedecisiontree](https://i.imgur.com/IfCWVNS.png)

*Figure 1, the variable importance of the decision tree*

Based on information gain, splitting the dataset based on the total a customer was charged lead to the highest information gain and therefore is the most important variable, as presented in figure 1. Moreover, it is used as the first variable to split the decision tree as visible in figure 2.

![decisiontree](https://i.imgur.com/o66MBlg.png)

*Figure 2, estimation of the decision tree.*

Figure 2 could be interpreted as, when a customer has a total charge of 35 euros and called the customer service more than 4 times, the customer is .94 likely to stay. For example, when a customer has called for 70 minutes in one month and was charged 120 cents per minute, the total charge would be 84 dollars. Also, the customer has a voicemail plan. This means that customer has a probability of 96 percent to stay with the company. This shows how easy it is to interpret a decision tree.

The decision tree was able to predict 94.84% of all the customers’ status correctly. The decision tree is better at identifying the customers with a high churn rate from other customers than the logistic regression, as the top decile lift is 6.47. However, the overall performance of the decision tree is weaker compared to the logistic regression, as the Gini coefficient is .53.


# Logistic regression 

In table 1, two logistic models are presented. The first logistic estimation includes all the available variables in the telecom dataset, which results in model one. A check for highly correlated variables are included in Appendix B. This resulted in a high correlation between minutes called and charge. Therefore, these two variables are not added to the estimation at the same time in all the models.

The Akaike information criterion (AIC), which indicates a goodness of fit of the logistic regression meanwhile penalizing for adding variables, has a value of 1628. While the Bayesian information criteria (BIC) which accounts for the sample size, resulted in a value of 1713. Model one was able to predict 84.65% of all the customers correctly (Akaike, 1974). 

*Table 1, estimation of the logistic regression*

![logisticregression](https://i.imgur.com/ztteLu0.png)

Removing all the insignificant variables resulted in the estimation presented in model two. This estimation has an AIC value of 1627, a lower BIC compared to model one of 1692 and is able to predict 84.89% of all customers correctly. It is not possible to interpret the coefficients of the logistic regression, in the same way as a linear regression. Only the signs of the logistic regression give a direction to the variable on the probability of a customer churning. The total charge, having an international plan, the number of day, evening and night calls, and the number of calls to customer service have a positive effect on the probability to churn. While the total number of calls, the total number of minutes called, having a voicemail plan, number of daytime, evening minutes reduce the probability of a customer churning.

Marginal effects are calculated to describe the impact of the variables on churn. Marginal effects describe the change in churn probability, as x increases with one unit, holding all other variables in the model constant or at average observation (Torres-Reyna, 2014). Table two shows the marginal effects of model two from the logistic regression. This table shows the same directional effect as described before, however now it is possible to describe the impact of the variables on churn.

*Table 2, marginal effects*

![marginaleffects](https://i.imgur.com/jPkXy9a.png)

For example, as the total charge of a customer increases with one dollar, the probability of a customer churning increases with 1.95 percent. Moreover, when a customer calls more in total, the probability of churning decreases with 1.42 percent. 

Model three in table one is a result of the fit on the important variables from the decision tree, see table 1. Compared to the other models, the AIC and BIC are significantly higher. Also, this model was less good in identifying top churners and the performance of the overall model was weaker. Surprisingly, the hit rate of the model was comparable to the other models. Therefore, the estimation of model two is used to compare the logistic regression with the decision tree, bagging, boosting and a neural network.

# Bagging and boosting

Bagging creates multiple decision trees over subsets of the telecom dataset and aggregates the outcomes of these trees to estimate the probability of churning (Breiman, 1996). All the variables that are in the dataset are used to estimate the churn probability. With these variables, the model was able to predict the customer status 94.84% of all customers correctly. The estimation method resulted in a comparable top decile lift of 6.47. However, the overall performance of the bagging method is higher than the decision tree and logistic regression, as the Gini coefficient is .74. The relative variable importance in relative percentages is visible in figure 3. It shows that, as in the decision tree, the total charge, voicemail plan and customer service calls are very important variable to estimate customer churn.  

![bagging](https://preview.ibb.co/bZBBs8/variableimportancebagging.png)

*Figure 3, the relative importance of variables for bagging in percentage.*

Using the boosting estimation method, 94.96% of all customer statuses are predicted correctly. The ability to separate the high probability churners from the other customers of the model is equal to the bagging model. However, the overall performance of the model is better compared to all previous described estimation methods (Gini coefficient is .77). The variable importance of the boosting estimation is presented in figure 4. Where it also shows that the total amount of money charged was most important. However less important than in the bagging estimation. Here seems to be more of a distribution among the importance of the variables.

![boosting](https://preview.ibb.co/g8at5T/variableimportanceboosting.png)

*Figure 4, the relative importance of variables for boosting in percentage.*

# Neural network
The neural network is estimated on data scaled by a min-max scale to a fixed range from zero to one. This improves the predictive performance and time of the neural network to estimate (Sola & Sevilla, 1997). In figure 5, the variables are displayed as the input of the neural network, by one hidden layer, 5 neurons and biases (B1 and B2) the values of the inputs are transformed into an output in the form of probability of a customer to churn. 

![neuralnetwork](https://preview.ibb.co/jJed5T/neuralnetwork.png)

*Figure 5, estimation of the neural network.*

All variables are included in the estimation of the neural network. By estimating the model, the model adjusts the neurons and biases until the squared error between the estimated churn probability and actual churn value 0 or 1 (Mitchell, 1997: Bishop, 2006). On the test data, the estimation resulted in a top decile lift of 5.69, a Gini coefficient of 0.77 and a hit score of 92%.

# Conclusion and discussion

Churn prediction is very important for enterprises in a competitive market to retain valuable customers, as the telecom sector. Therefore, to build an effective churn prediction model, which has a certain level of predictive power is relevant (Tsai & Lu, 2009).
Au et al. (2003) proposed that neural network would overperform decision trees in predicting customer churn. Mozer et al. (2000) presented that neural networks outperform a logistic regression and a decision tree. Ha, Cho & Maclachlan (2005) proposed that also bagging and boosting would be outperformed by a neural network. Therefore, the need to compare modern machine learning techniques in terms of predictive power is evident. As displayed in figure 6, the neural network did perform in terms of overall performance (Gini coefficient). 

![conclusion](https://image.ibb.co/mPWfKo/conclusion.png)

*Figure 6, overall performance of the machine learning algorithms.*

However, the neural network estimation did not overperform the other estimations in terms of separating the top churners from other customers (Top Decile Lift), the amount of correct predicted churn statuses and overall time to train the model. 

The most competitive estimation methods are the bagging and boosting methods. These methods outperform the other estimations, except for the neural network in terms of the Gini coefficient. However, the top decile lift is more important for managers than the Gini coefficient and the hit rate, because a manager wants to find a model that finds those people that are the most likely to churn. These customers that are most likely to churn are targeted by the managers to convince them of becoming a loyal customer. Considering the time it takes to create a bagging or boosting model, the decision tree is competitive in terms of top decile lift. However, choosing a decision tree might imply that the overall prediction is weaker compared to boosting and bagging.

Moreover, hit rate appeared to be a weak measurement of the predictive power of the logistic regression. Where in model three, the hit rate remained equal to the other estimations, the Gini coefficient and top decile lift decreased. 

## Managerial implications

Out of all the methods evaluated in this paper in the context of estimating churn, bagging and boosting are most advisable for managers to estimate churn. Especially due to the high ability to discover the customers that are most likely to churn (TDL). 
There are numerous methods available to estimate a binary decision (i.e., churn). Out of these methods, managers have to evaluate each method in terms of multiple performance measures. Just evaluating the estimations in terms of hit rate is not sufficient. A variety of performance measurements should also be included in the analysis of which estimation method has the highest predictive power.

Managers should profit from the understandability of decision trees. They are easy to interpret or evaluate why customers churn, due to its structure. Neural networks are harder to interpret as it is a collection of adjustments by nodes and biases that lead to a probability. 

## Limitations

First, this paper did not focus on the staying power of predictive models. This means that the model estimates are not evaluated over a certain time period. This implies that the predictive power of boosting and bagging may decline over time. Neslin, et al. (2006) describes that model last at least three months. In that time practitioners do not need to develop a new model. However, future research should test for longer time periods.

Second, the results of the predictive power of the estimations may be dependent on the data provided. Trees tend to perform better on larger data sets (Perlich, Provost, and Simonoff 2004).

Third, the dataset on churn is limited, in this case, the data was from the telecom industry. However, future research should also investigate other variables, data and industries. Also, new estimation methods should be evaluated and be compared in terms of its predictive power.

Finally, there might be interaction effects among the variables used, which have not been discovered. For example, the account length might moderate the minutes called of customers. Future research could look for interaction effects, besides looking at the main effects.


# References

1. Ahn, J.-H., Han, S.-P., & Lee, Y.-S. 2006. Customer churn analysis: Churn determinants and mediation effects of partian defection in the Korean mobile telecommunications service industry. Telecommunications Policy (30), 552-568.
2. Akaike, H. 1974. A new look at the statistical model identification. IEEE Transactions on Automatic Control, 19(6): 716–723.
3. Au, W. H., Chan, K., & Yao, X., 2003. A novel evolutionary data mining algorithm with applications to churn prediction. IEEE Transactions on Evolutionary Computation, 7(6), 532–545.
4. Bijmolt, T. H. A., Leeflang, P. S. H., Block, F., Eisenbeiss, M., Hardie, B. G. S., et al. 2010. Analytics for Customer Engagement. Journal of Service Research, 13(3): 341–356.
5. Bishop, C. M. 2006. Pattern recognition and machine learning. New York.: Springer.
6. Breiman, L. 1996. Bagging predictors. Machine Learning, 24(2): 123–140.
7. Günther, C.-C., Tvete, I. F., Aas, K., Sandnes, G. I., & Borgan, Ø. 2011. Modelling and predicting customer churn from an insurance company. Scandinavian Actuarial Journal, 2014(1): 58–71.
8. Ha, K., Cho, S., & Maclachlan, D. 2005. Response models based on bagging neural networks. Journal of Interactive Marketing, 19(1): 17–30.
9. Holtrop, N., Wieringa, J. E., Gijsenberg, M. J., & Verhoef, P. C. 2017. No future without the past? Predicting churn in the face of customer privacy. International Journal of Research in Marketing, 34(1): 154–172.
10. Hssina, B., Merbouha, A., Ezzikouri, H., & Erritali, M. 2014. A comparative study of decision tree ID3 and C4.5. International Journal of Advanced Computer Science and Applications, 4(2). http://doi.org/10.14569/specialissue.2014.040203.
11. Kim, H.-S., & Yoon, C.-H. 2004. Determinants of subscriber churn and customer loyalty in the Korean mobile telephony market. Telecommunications Policy, 28(9-10): 751–765.
12. Lecun, Y., Bengio, Y., & Hinton, G. 2015. Deep learning. Nature, 521(7553): 436–444.
13. Lu, N., Lin, H., Lu, J., & Zhang, G. 2014. A Customer Churn Prediction Model in Telecom Industry Using Boosting. IEEE Transactions on Industrial Informatics, 10(2): 1659–1665.
14. Malhotra, N. K. 2010. Marketing research: an applied orientation. New York: Pearson.
15. Mitchell, T. 1997. Machine learning. New York: McGraw-Hill.
16. Mozer, M.C., Wolniewicz, R, Grimes, D.B., Johnson E., Kaushansky H. 2000. Predicting subscriber dissatisfaction and improving retention in the wireless telecommunications industry, IEEE Trans. Neural Netw. 11(3) 690–696.
17. Neslin, S. A., Gupta, S., Kamakura, W., Lu, J., & Mason, C. H. 2006. Defection Detection: Measuring and Understanding the Predictive Accuracy of Customer Churn Models. Journal of Marketing Research, 43(2): 204–211.
18. Nie, G., Rowe, W., Zhang, L., Tian, Y., & Shi, Y. 2011. Credit card churn forecasting by logistic regression and decision tree. Expert Systems with Applications, 38(12): 15273–15285.
19. Perlich, C., Provost, F., & Simonoff, J. S. 2003. Tree Induction vs. Logistic Regression: A Learning-Curve Analysis. Journal of Machine Learning Research, 4: 211–255.
20. Ricci, F., Rokach, L., Shapria, B., & Kantor, P. B. 2010. Recommender systems handbook. Springer: New York Inc.
21. Risselada, H., Verhoef, P. C., & Bijmolt, T. H. 2010. Staying Power of Churn Prediction Models. Journal of Interactive Marketing, 24(3): 198–208.
22. Sola, J., & Sevilla, J. 1997. Importance of input data normalization for the application of neural networks to complex industrial problems. IEEE Transactions on Nuclear Science, 44(3): 1464–1468.
23. Torres-Reyna, O. 2014, December. Logit, Probit and Multinomial Logit models in R. Data & statistical services. Lecture presented at the Logit, Probit and Multinomial Logit models in R.
24. Tsai, C.-F., & Lu, Y.-H. 2009. Customer churn prediction by hybrid neural networks. Expert Systems with Applications, 36(10): 12547–12553.
25. Vafeiadis, T., Diamantaras, K. I., Sarigiannidis, G., & Chatzisavvas, K. C. 2015. A comparison of machine learning techniques for customer churn prediction. Simulation Modelling Practice and Theory, 55: 1–9.
26. Verhoef, P. P. C., & Wieringa, D. J. E. 2011. Churn: Welke klanten dreigen weg te lopen? https://www.rug.nl/cic/downloads/rugcic_rapport_201101_churn.pdf.
