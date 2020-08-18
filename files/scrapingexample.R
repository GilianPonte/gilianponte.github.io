library("xml2")
library("rvest")
library("stringr")


rm(list = ls())
setwd("/root/rscripts/dashboarding/adwords")
##GET DATE###
today <- format(Sys.time(), "%Y.%m.%d")
date <- paste (today, "00:00:00")
gsub("-",".", date)
options(scipen = 999)

##LOAD###
dataean <- read.csv("/root/rscripts/dashboarding/adwords/EAN.csv")


##SCRAPE###
pricedata <- data.frame(EAN = dataean$EAN, Catalogusid = NA, Title = NA, Componist = NA, Label = NA, Uitgave = NA, Producttekst = NA, Length = NA, Producttype = NA, Tracks = NA, stringsAsFactors=FALSE)


for (i in 1:nrow(pricedata)) {
  EAN <- as.character(pricedata[i,1])
  url <- paste0("https://www.muziekweb.nl/Muziekweb/Cat/SingleSearch/Search?q=",EAN, "&catalogue=")

  Sys.sleep(1)
  result <- tryCatch({pdp <- read_html(url)}, error = function(err) {error <- err})
  
  #SKIP ERROR 404 & 503
  if(class(result$message) == "character"){
    print(result$message)
    next
  } 
  
  #else if (any(result$message) == "")
  
  print(paste(i,url))
 
  try(pricedata[i,2] <- pdp %>% html_nodes(".cat-albumid") %>% html_text())
  try(pricedata[i,3] <- as.character(pdp %>% html_nodes(".cat-albumtitle") %>% html_text()))
  try(pricedata[i,4] <- pdp %>% html_nodes("#album .cat-performers span") %>% html_text())
  try(pricedata[i,5] <- pdp %>% html_nodes(".cat-orderinfo a span") %>% html_text())
  try(pricedata[i,6] <- pdp %>% html_nodes(".cat-albumrelease .cat-label+ span") %>% html_text())
  try(pricedata[i,7] <- as.character(pdp %>% html_nodes(".cat-article-text") %>% html_text()))
  try(pricedata[i,8] <- as.character(pdp %>% html_nodes(".cat-playtime") %>% html_text()))
  try(pricedata[i,9] <- as.character(pdp %>% html_nodes(".cat-product .cat-label+ span") %>% html_text()))
  try(pricedata[i,10] <- as.character(pdp %>% html_nodes("#album-tracks") %>% html_text()))
  
}
