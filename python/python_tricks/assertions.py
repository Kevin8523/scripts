# Assertions:
# If the assert condition is true >> nothing happens, if it is false >> raised an optional error message
# USE CASE 1: 
# Good for detecting errors in python programs >> Good for debugging
# Should be used on unrecoverable errors in programs, not used for signaling expected error conditions
# Syntax: "assert" expression1 ["," expression2]
# PITFALLS:
# Using on Data validation & Useless assertions
def apply_discount(product,discount):
	price = int(product['price'] * (1.0 - discount))
	assert 0 <= price <= product['price']
	return price
