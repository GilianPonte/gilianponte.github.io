rm(list = ls())
library(LaplacesDemon)
library(ggplot2)
library(dplyr)
library(data.table)

it = 30000 # the number of iterations we want to apply the randomized mechanism.
datasets = c() # dataset to store the result of applying dp.
set_of_epsilon = c(0.01,1,13) # the epsilons we want to satisfy.

for (epsilon in set_of_epsilon){
  ## count exercise. define to adjacent data sets (x and x') of 1,000 observations.
  # this is dataset x.
  x = c(seq(from = 1, to = 1, length.out = 500), seq(from = 0, to = 0, length.out = 500))
  
  ## analysis M is to count how many objects are in x.
  sum(x)
  
  ## now we add laplace noise to ensure differential privacy. Why is it called a randomized mechanism?
  # fill in the question marks
  sum(x) + rlaplace(1, 0, 1/epsilon)
  
  ## each time we run the query, we obtain a different result.
  # try to think about the following: why do we need multiple iterations here?
  counts = c()
  for (i in 1:it){
    ## print the number of iterations to track progress.
    if(i %% 10000 == 0){
      print(i)
    }
    count = sum(x) + rlaplace(1, 0, 1/epsilon) # fill in the question marks, in line with line 21.
    counts = rbind(counts, count) # this just saves the results.
  }
  
  counts = as.data.frame(counts)
  counts$dataset = "data set" # we call this data set because it is the scenario of x. Next we need scenario x'.
  
  ## now we fist differ one observation.
  x = c(seq(from = 1, to = 1, length.out = 499), seq(from = 0, to = 0, length.out = 500))
  
  countsx = c()
  for (i in 1:it){
    ## print
    if(i %% 10000 == 0){
      print(i)
    }
    count = sum(x) + rlaplace(1, 0, 1/epsilon) # apply the same level of differential privacy as before.
    countsx = rbind(countsx, count)
  }
  
  countsx = as.data.frame(countsx)
  countsx$dataset = "adjacent data set"
  
  data = rbind(counts, countsx)
  data$epsilon = paste0("epsilon = ",as.character(epsilon))
  datasets = rbind(datasets, data)
}


datasets = setDT(datasets, keep.rownames = TRUE)[] # sets rownames as a column

p <- datasets %>% ggplot(aes(x=V1, color = dataset)) + 
  geom_density() + xlab("outcomes") + facet_wrap(. ~epsilon, scales = "free_y", ncol = 5) + xlim(c(495,505)) + 
  theme_minimal(base_size = 12) + ylab("Density") + scale_color_manual(values=c("red","black")) + theme(legend.text=element_text(size=13), axis.text=element_text(size=13),axis.title=element_text(size=13), strip.text.x = element_text(size = 13)) + theme(legend.position="right",legend.title = element_text(size = 13, colour="black"))

p
