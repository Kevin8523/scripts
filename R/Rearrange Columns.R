
###################################################
## Rearrange Columns
###################################################

# Read in Data
df <- iris
head(df)

# Rearrange columns in a df
df <- df[c(4,1,2,3)]
head(df)
