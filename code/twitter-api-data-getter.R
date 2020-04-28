# install.packages(c("rtweet", "httpuv"))
library(rtweet)
appname <- "WhatsOpinionApp"
key <- "TINz399R1XGJlgtU8v9tjVTJq"
secret <- "axmSvyfsTCGwp0ve6AqsbHzAU3UiHonOdCko4vo28xkVbwScw0"

twitter_token <- create_token(
  app = appname,
  consumer_key = key,
  consumer_secret = secret,
  access_token = "1151337842976575489-R5LFAH6l6x6XtkGDqMkIeTJ8DdwrXl",
  access_secret = "lGwD6QGZcTLOh2Ns4cSmo2RsihUETUC8UvisVMeah39gu"
)

corona <- search_tweets("virus OR corona OR covid-19 OR covid19", n = 100000, lang = "id", retryonratelimit = TRUE, include_rts = FALSE)
typeof(corona)

df <- data.frame(corona$screen_name, corona$text, corona$retweet_count, corona$favorite_count)

colnames(corona)
write.csv(df, file = "text.csv")

head(df)
