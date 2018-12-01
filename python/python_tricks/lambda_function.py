# Lambdas
# Quick way to do a function
# Also work as lexical closures >> Nested functions 
# Be careful when using lambda functions, you want to keep your code clean

# Lambda function to add
add = lambda x, y: x + y
add(5,3)

# Calling lambda function inline
(lambda x,y: x+y) (5,3)

# Compared to a function
def add(x + y):
	return x + y
add(5,3)

# More examples of the lambda function
tuples = [ (1,'d'), (2,'b'), (3,'c'), (4,'a') ]
sorted(tuples, lambda x: x[1])