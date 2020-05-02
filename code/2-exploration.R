# Import libraries
library(dplyr)
library(tidytext)
library(wordcloud)
library(wordcloud2)
library(ggplot2)

# Create word-frequency table for wordcloud
df <- read.csv('./data/dataset_fix.csv', stringsAsFactors = F)
View(df)
text <- df[, c(1,6)]

# Create Word Frequencies
word_frequencies <- text %>%
  unnest_tokens(input = pre_processed_text, output = unigram) %>%
  count(unigram)

# EDA

# 1-gram frequency
one_gram_freq <- word_frequencies %>%
  arrange(desc(n)) %>%
  head(25) %>%
  mutate(unigram = reorder(unigram, n))

ggplot(one_gram_freq, aes(unigram, n)) +
  geom_bar(stat = "identity", fill="dark blue") +
  coord_flip()

# 2-gram frequency
two_gram_freq <- text %>%
  unnest_tokens(input = pre_processed_text, output = digram, token = "ngrams", n = 2) %>%
  count(digram, sort = T) %>%
  head(25) %>%
  mutate(digram = reorder(digram, n))

two_gram_freq

ggplot(two_gram_freq[-7, ], aes(digram, n)) +
  geom_bar(stat="identity", fill="orange") +
  coord_flip()

# 3-gram frequency
trigram_freq <- text %>%
  unnest_tokens(input = pre_processed_text, output = trigram, token = "ngrams", n = 3) %>%
  count(trigram, sort = T) %>%
  head(25) %>%
  mutate(trigram = reorder(trigram, n))

ggplot(trigram_freq[2:25,], aes(trigram, n)) +
  geom_bar(stat="identity", fill="light green") +
  coord_flip()


# Make Wordcloud
set.seed(123) # for reproducibility 
wordcloud(words = word_frequencies$word, freq = word_frequencies$n, min.freq = 1, 
          max.words=200, random.order=FALSE, rot.per=0.35, colors=brewer.pal(8, "Dark2"))

set.seed(123)
wordcloud2(word_frequencies, size = 1.6)

library(caTools)
write.gif(wordcloud2(word_frequencies), "wordcloud.gif")

set.seed(123)
wordcloud2(word_frequencies, figPath = "visualization/IPBBW.png", size = 1.5, color = "blue")

set.seed(123)
letterCloud(word_frequencies, word = "IPB")
