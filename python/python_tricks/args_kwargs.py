# *Args & **kwargs
# Args: Extra positional arguments as tuples
# kwargs: Extra keyword arguments as dictionary

def trace(f):
	@functools.wraps(f)
	def decorated_function(*args, **kwargs):
		print(f, args, kwargs)
		result = f(*args, **kwargs)
		print(result)
	return decorated_function

@trace
def greet(greeting, name):
	return '{}, {}!'.format(greeting, name)

greet('Hello', 'Bob')

# Function argument Unpacking
# * or ** for unpacking sequences of tuples/lists/dictionaries

