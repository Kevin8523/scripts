# With Statement
# Good for running something and then end it, resource management
# Usually used to replace try & finally

# With Statement:
with open('hello.txt','w') as f:
	f.write('hello, world!')

# Without With Statement:
f = open('hello.txt','w')
try:
	f.write('Hello, World')
finally:
	f.close()


# Supporting with in your own objects
# Create __enter__ and __exit__ methods to an object if you want to use it to function as a context manager
# Context Manger - A way to manage & allocate resources