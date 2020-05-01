# Topic Modelling with LDA
# install.packages("topicmodels")
library(dplyr)
library(ggplot2)
library(topicmodels)
library(tidytext)

# Import the data
df <- read.csv('dataset_fix.csv', stringsAsFactors = F)
View(df)
text <- tibble(document=1:10000, text = df$pre_processed_text)
text

# Create Document Term Matrix
dtm <- text %>%
  unnest_tokens(input = text, output = word) %>%
  count(document, word) %>%
  cast_dtm(document, word, n)


# Tuning model
mod_log_lik = numeric(10)
mod_perplexity = numeric(10)
for (i in 2:10) {
  mod = LDA(dtm, k = i, method = "Gibbs",
            control=list(alpha = 0.5, iter = 1000, seed = 123, thin = 1))
  mod_log_lik[i] = logLik(mod)
  mod_perplexity[i] = perplexity(mod, dtm)
}


# Evaluation
plot(1:10, mod_log_lik, type="b", xlab="k", ylab="Model Likelihood")
plot(1:10, mod_perplexity, type="b", xlab="k", ylab="Model Perplexity")

# Create the model
mod_fix <- LDA(dtm, k = 6, method = "Gibbs",
               control = list(alpha = 0.5, iter = 1000, seed = 123, thin = 1))

# Show the top words for each topic
tweet_topics <- tidy(mod_fix, matrix = "beta")
tweet_topics

tweet_topics_top_terms <- tweet_topics %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  arrange(topic, -beta)

tweet_topics_top_terms %>%
  mutate(term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = factor(topic))) +
  geom_col(show.legend = F) +
  facet_wrap(~ topic, scales = "free") +
  coord_flip() +
  scale_x_reordered()
