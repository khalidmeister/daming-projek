library(dplyr)
library(tm)

# Get the data
df <- read.csv('./data/full-text.csv')
head(df)
dim(df)

# Pre-process
text <- df$corona.text

set.seed(123)
sample(text, 50)

# To Lowercase
text <- tolower(text)

# Remove Mentions, Links, Hashtags, and Emojis
text <- gsub("rt", "", text)
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
#alay <- read.csv(paste(getwd(), "/data/bahasa-alay.csv", sep=""), stringsAsFactors = F)
#slangword <- function(x) Reduce( function(x,r) gsub(alay$old[r], alay$new[r], x, fixed=T), seq_len(nrow(alay)), x)
#clean <- slangword(text)

#set.seed(123)
#sample(clean, 50)


# Remove Stopwords
stop_id <- scan(paste(getwd(), "/data/stopwords-id.txt", sep=""), character(), sep="\n")
stop_id

clean <- removeWords(text, stop_id)
clean <- gsub("^\\s+", "", clean)
clean <- gsub("\\s+$", "", clean)
clean <- gsub("[ |\t]+", " ", clean)

set.seed(123)
sample(clean, 50)

write.csv(clean, "clean-utf.csv", fileEncoding = "UTF-16LE")

# Create Document Term Matrix
# Sampling dulu
set.seed(123)
fix <- sample(clean, 10000)

View(fix)
dtm <- TermDocumentMatrix(Corpus(VectorSource(fix)))
matrix <- as.matrix(dtm) 
words <- sort(rowSums(matrix),decreasing=TRUE) 
cloud_data <- data.frame(word = names(words),freq=words)
write.csv(cloud_data, 'not-big-data-dtm.csv')

# EDA
library(wordcloud)
library(wordcloud2)
set.seed(1234) # for reproducibility 
wordcloud(words = df$word, freq = df$freq, min.freq = 1, 
          max.words=200, random.order=FALSE, rot.per=0.35, colors=brewer.pal(8, "Dark2"))
wordcloud2(data=df)

df

# Topic Modelling with LDA