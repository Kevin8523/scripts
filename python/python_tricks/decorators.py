# Decorator
# Allows you to extend or modify a function/method/class without permanently modifying original code
# Extend or wrap another function and let you execute code before and after the wrapped function runs
# closures: function that remembers the value from the enclosing lexical scope, even when the program flow is no longer in that scope


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
