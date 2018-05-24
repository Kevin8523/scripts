
###################################################
## Renaming & Rearrange Columns
###################################################

# Read in Data
df <- iris
head(df)

# Renaming Columns
colnames(df) <- c("s_length", "_width", "p_length", "p_width", "species")
head(df)

# Rearrange columns in a df
df <- df[c(4,1,2,3)]
head(df)
