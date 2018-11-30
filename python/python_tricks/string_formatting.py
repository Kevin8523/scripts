# String Formatting: 
# 4 ways: Old, New, Literal, Template
# Rule of Thumb: Use Literal (python 3.6+) unless strings are user-supplied then use Template Strings

errno = 50159747054
name = 'Bob'

# Old Style
'Hello %s' % name

# New Style
'Hello {}'.format(name)
'Hey {name}, there is a {errno} error!'.format(name=name, errno=errno)

# Literal String Interpolation (Python 3.6+) >> Formatted String Literals
# Allows embedded Python expressions inside string constants
f'Hello, {name}!'

a = 5
b = 10
f'Five plus ten is {a + b} and not {2 *(a + b)}.'

def greet(name,question):
	return f"Hello {name}, {question}?"

# Template Strings
# Useful for user generated inputs
from string import Template
t = Template('Hey, $name!')
t.substitute(name=name)