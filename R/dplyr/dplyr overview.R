
###################################################
## Working with dplyr
# How to ...
#   - select columns:               select()
#   - filter rows:                  filter()
#   - add new variables:            mutate()
#   - sort your data:               arrange()
#   - summarize your data:          summarize()
#   - group / aggregate your data:  group_by()
###################################################

library(dplyr)

df <- read.csv(url("https://raw.githubusercontent.com/justmarkham/pandas-videos/master/data/imdb_1000.csv"))
head(df)

# Select columns
df %>%
  select(title,star_rating, content_rating) %>%
  head()

# Select Distinct
df %>%
  distinct(title,star_rating, content_rating) %>%
  head()

# Filter
df %>%
  filter(content_rating == 'R') %>%
  head() 

# Mutate
df %>%
  mutate(movie_length_hrs = duration / 60)

head(df)

# Arrange
df %>%
  arrange(desc(duration)) %>%
  head(5)

# Summarize
df %>%
  summarize(mean(duration)) # median, max, min, sd

# Group By
df %>%
  group_by(genre,content_rating) %>%
  filter(star_rating > 8.5) %>%
  summarise(count = n())
