---
title:  "Scraping with R"
---

# Scraping with R
*16 October, 2017*

Today I would like to show you that you don't have to be an expert at coding in order to scrape some data from the web. I will try to show you how you can scrape prices from webshops. However, this tutorial could also be used in case of scraping other content.

## Summary
1. Level of programming: Beginner/Intermediate
2. Programming language: R 
3. Reading time: 10 min
4. If you don't want to read my whole explanation on how to scrape, you can find the piece of code [here](https://github.com/GilianPonte/gilianponte.github.io/blob/master/scrapingexample.R) and start scraping yourself.


# Introduction
Scraping is a time-saving skill. It makes you save time for more important things in your daily routine work or hobbies (for example: getting coffee for your colleagues). More important in my experience, for most companies it enables the company to analyse its competitors' pricing strategy, product availability or collect reviews to do a sentiment analysis. In this case, we will scrape some prices from a Dutch webshop (please don't sue me). This case is pure for educational purposes...


# Let's start scraping
![giphy][cat]

[cat]: https://media.giphy.com/media/yjeAgye5hbFAc/giphy.gif

To scrape in R, my personal favourite library is "rvest". It makes scraping very easy. Let me show you. To load the library use the following script:

```{r}
## in case you haven't installed "rvest" yet, this may take some time
install.packages("rvest")

## load rvest
library("rvest")
```
To get to know more about the "rvest" package, you can click [here](https://cran.r-project.org/web/packages/rvest/rvest.pdf).


## Basic settings 
Next up, you want to set your basic settings for the sake of simplicity. You will need to set your working directory (in which folder you want to save your files). In this case we will just name it my Documents folder on my pc. The second line of code makes sure we do not use a scientific way of notating numbers. Which is really useful when working with product numbers. In this case, product numbers could also be referred to as EAN's or UPC's (Universal Product Codes).

```{r}
setwd("C:/Users/gilianponte/Documents")
options(scipen= 999)
```

> If you are copying this piece of code, don't forget to edit it to your personal pc. Remember that you must use the forward slash / or double backslash \\ in R! The Windows format of single backslash will not work.


## Loading product numbers
In this case you will need a .csv file containing all product numbers you want to scrape data of. Load them as a [data frame](https://stat.ethz.ch/R-manual/R-devel/library/base/html/data.frame.html) in R with the following line of code. Make sure the file is in your working directory.

```{r}
productnumbers <- read.csv("UniqueProductCodes.csv")
```

The result of this should look like this in Rstudio.


| Unique Product Codes |
|----------------------|
| 9781491910290        |
| 9781593273842        |
| 9781491910399        |


> In the data frame you can remove the header.


Moreover, I recommend making a data frame where you want to store your scraping data in. In this example we will only scrape the product price. If you would like to scrape additional data, you simply just add more columns in your data frame here.


```{r}
pricedata <- data.frame(EAN = productnumbers$EAN, Price = NA, stringsAsFactors=FALSE)
```


## Competitors website
Now we have everything set to collect the data from our victims' website. Let's get down to the real scraping. For this we will need a loop, since we have multiple EAN's we want to scrape. If you are not familiar with loops, [here](https://www.r-bloggers.com/how-to-write-the-first-for-loop-in-r/) is a very useful instruction to learn or to better understand it. 

In our loop we call our earlier defined data frame with the EAN's to iterate over all the EAN's in the data frame with:


```{r}
for (i in 1:nrow(pricedata)) {
## do stuff
}
```

The ```nrow``` function counts the number of rows in our data frame with unique product numbers (i.e., EAN or UPC). Therefore, the loop will start with the first EAN (row number one) in our data frame and end when it has used the last EAN in our scraper.


## Inside the loop
In the first line of code inside the loop, we want to load the first EAN from our data frame.

```{r}
EAN <- as.character(pricedata[i,1])
```

Next up, we want to load the competitors website its url. Most websites offer to search for EAN's or product numbers and then load the page of the concerning product directly. Try to find the url that performs a search query and directly loads the product page. In this case we will use a website which does offer the instant search method.

> Sometimes you will need to go to the network tab of the developer section in your browser, to check what the real search url is. In this case, I have done this for you.

With the function ```read_html``` in the second line we "load" the page. There is some error handling in the second line. If you don't understand this piece of code, I recommend reading [this](https://www.r-bloggers.com/error-handling-in-r/) article about error handling.

```{r}
url <- paste0("https://www.bol.com/nl/s/algemeen/zoekresultaten/Ntt/",EAN,"/N/0/Nty/1/search/true/searchType/qck/defaultSearchContext/media_al/sc/media_all/index.html")

result <- tryCatch({pdp <- read_html(url)}, error = function(err) {error <- err})
```


## Collect data from pages (CSS Selector tool)
Now that we have loaded the page, we can start extracting the pieces of information we would like to collect.

> Remember this is still inside the loop. 

This step requires some extra steps in your browser. To extract the right pieces of data you will need a CSS Selector tool, which is available [here](http://selectorgadget.com/). With this selector you will need to select the parts of a page as stated in the following image:


![example](https://i.imgur.com/EslEU0Y.png)


In this example the CSS Selector tells us that the *.promo-price* should be used as an identifier in our scraper. In the next example of code, I show you how to select this piece of website and extract it. In this example we automatically place the scraped data in our pre-created data frame with: ```pricedata[i,1]```. In ```[i,1]``` i indicates the row number the data should be placed in and the number 1 indicates the column.

The total piece of code concerning the extracting in the loop should look like this:

```{r}
  try(pricedata[i,2] <- pdp %>% html_nodes(".promo-price") %>% html_text())
```


## Share your data
To share your data you could write your data in a .csv file. I recommend doing this with the following piece of code, outside your loop.

```{r}
write.csv(pricedata, file = pricedata.csv)
```


# Conclusion
To summarize, your scraper should look something like this:

```{r}
## in case you haven't installed "rvest" yet
install.packages("rvest")

## load rvest
library("rvest")

## basic settings
setwd("C:/Users/gilianponte/Documents")
options(scipen= 999)

## load product numbers
productnumbers <- read.csv("EAN.csv")

## create a data frame to store data
pricedata <- data.frame(EAN = productnumbers$EAN, Price = NA, stringsAsFactors=FALSE)

## looping
for (i in 1:nrow(pricedata)) {
  EAN <- as.character(pricedata[i,1])
  url <- paste0("https://www.bol.com/nl/s/algemeen/zoekresultaten/Ntt/",EAN, "/N/0/Nty/1/search/true/searchType/qck/defaultSearchContext/media_al/sc/media_all/index.html")
  result <- tryCatch({pdp <- read_html(url)}, error = function(err) {error <- err})
  try(pricedata[i,2] <- pdp %>% html_nodes(".promo-price") %>% html_text())
}

## write your data in a .csv file
write.csv(pricedata, file = pricedata.csv)
```

With this instruction so far you should be able to collect prices of multiple product numbers, also called EAN's. How you would like to share your collected data really depends on the use case you have defined. In this case you could send the pricing data to your pricing tool or just analyse the differences between your prices and the competitors. 

A little more intense but also a very interesting use case could be analysing the pricing strategy of your competitor over time. Therefore you need to schedule your script and make sure it runs every day. 

### Thanks for reading, Gilian

