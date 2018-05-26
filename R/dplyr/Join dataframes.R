
###################################################
## Read Data into R
###################################################
library(dplyr)

# load data from URL
df1 = data.frame(CustomerId = c(1:6), Product = c(rep("Toaster", 3), rep("Radio", 3)))
df2 = data.frame(CustomerId = c(2, 4, 6), State = c(rep("Alabama", 2), rep("Ohio", 1)))
head(df1)
head(df2)

df_join <- inner_join(df1, df2, by = "CustomerId")
head(df_join)

df_join2 <- left_join(df1, df2, by = "CustomerId", all.x = TRUE)
head(df_join2)
