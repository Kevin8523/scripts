# Decorator
# Allows you to extend or modify a function/method/class without permanently modifying original code
# Extend or wrap another function and let you execute code before and after the wrapped function runs
# closures: function that remembers the value from the enclosing lexical scope, even when the program flow is no longer in that scope
# Multiple decorators start from the bottom up

# Simple case of using Decorators
def null_decorator(func):
	return function

@null_decorator
def greet():
	return 'Hello!'

greet()

# Example 2 of decorators
def uppercase(func):
	def wrapper():
		original_result = func()
		modified_result = original_result.upper()
		return modified_result
	return wrapper

@uppercase
def greet():
	return 'Hello!'

greet()

# *args & **kwargs: Use for arguments for decorators
# trace function
def trace(func):
	def wrapper(*args, **kwargs):
		print(f'TRACE: calling {func.__name__}() '
			f'with {args}, {kwargs}')

		orignal_result = func(*args,**kwargs)

		print(f'TRACE: {func.__name__}() '
			f' returned {orignal_result!r}')

		return orignal_result
	return wrapper

# functools
# Always apply the functools.wraps to the wrapper for debugging purposes
# Allows you to see the documentation 

import functools

def uppercase(func):
	@functools.wraps(func)
	def wrapper():
		return func().upper()
	return wrapper
