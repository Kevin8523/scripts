
###################################################
# Creating a Function
###################################################
dataset <- iris

# Create a Function
##################################
# function(param1, ..., paramN) {
#   expr1
#   .
#   .
#   .
#   exprM
# }
##################################

normalize <- function(x) {
   return((x - min(x)) / (max(x) - min(x)))
}
