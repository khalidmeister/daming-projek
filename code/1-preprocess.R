library(dplyr)
library(tm)

# Get the data
df <- read.csv('./data/full-text.csv', stringsAsFactors = F)
df$date <- as.Date(df$corona.created_at)
df$corona.created_at <- NULL
colnames(df) <- c("id", "screen_name", "text", "rt", "like", "date")
df <- df[c(6, 1:5)]
head(df)
str(df)
dim(df)
View(df)
df %>%
  count(date)

# Pre-process
text <- df$text

set.seed(123)
sample(text, 50)

# To Lowercase
text <- tolower(text)

# Remove Mentions, Links, Hashtags, and Emojis
text <- gsub("@\\w+", "", text)
text <- gsub("https?.+", "", text)
text <- gsub("#\\w+", "", text)
text <- gsub("<.+>", "", text)

# Remove punctuations, numbers, and escape sequences
text <- gsub("[[:punct:]]", " ", text)
text <- gsub("\n", " ", text)
text <- gsub("^\\s+", "", text)
text <- gsub("\\s+$", "", text)
text <- gsub("[ |\t]+", " ", text)
text <- gsub("\\d", "", text)

# Remove Kata Alay (Ini nanti aja, hasilnya agak kacau)
# alay <- read.csv(paste(getwd(), "/data/bahasa-alay.csv", sep=""), stringsAsFactors = F)
# slangword <- function(x) Reduce( function(x,r) gsub(alay$old[r], alay$new[r], x, fixed=T), seq_len(nrow(alay)), x)
# clean <- slangword(text)

# set.seed(123)
# sample(clean, 50)


# Remove Stopwords
stop_id <- scan(paste(getwd(), "/data/stopwords-id.txt", sep=""), character(), sep="\n")
stop_id
clean <- removeWords(text, stop_id)
clean <- gsub("^\\s+", "", clean)
clean <- gsub("\\s+$", "", clean)
clean <- gsub("[ |\t]+", " ", clean)

# Cek hasil akhir
set.seed(123)
sample(clean, 50)

# Masukkan ke dataset
df["pre_processed_text"] <- clean
df <- df[c(2,1,3,4,7,5,6)]
str(df)

# Stopword disimpan untuk sentiment analysis
# clean_with_stopword <- text
# df["pre_processed_text"] <- clean_with_stopword
# df <- df[c(2,1,3,4,7,5,6)]
# str(df)


# Sampling tweet yang digunakan
set.seed(123)
num_rows <- sample(df$id, 10000)
df_fix <- df[num_rows, ]

# Create output data
write.csv(df_fix, "dataset_fix_stopword_exist.csv")
