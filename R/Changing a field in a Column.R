
###################################################
# Changing a Field in a Column
###################################################

df <- read.csv(url("https://raw.githubusercontent.com/justmarkham/pandas-videos/master/data/imdb_1000.csv"))
head(df)
levels(df$content_rating)
df$content_rating[df$content_rating == "NOT RATED"] <- "R"

head(df)

