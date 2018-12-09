# Class vs Instance Variable Pitfalls
# Two kind of data attributes in Python Objects: Class variables & instance variables
# Class Variables - Affects all object instance at the same time
# Instance Variables - Affects only one object instance at a time
# Because class variables can be “shadowed” by instance variables of the same name, 
# it’s easy to (accidentally) override class variables in a way that introduces bugs

class Dog:
	num_legs = 4 # <- Class Variable

	def __init__(self,name):
		self.name = name # <- Instance Variable

jack = Dog('Jack')
jill = Dog('Jill')
jack.name, jill.name

jack.num_legs, jill.num_legs

#Error Example: This will change the Class
Dog.num_legs = 6
jack.num_legs, jill.num_legs

Dog.num_legs = 4
jack.num_legs = 6

jack.num_legs, jack.__class__.num_legs


# Another example of good vs bad implementation
# Good
class CountedObject:
	num_instances = 0
	
	def __init__(self):
		self.__class__.num_instances += 1

# Bad
# WARNING: This implementation contains a bug
class BuggyCountedObject:
	num_instances = 0
	
	def __init__(self):
		self.num_instances += 1 # !!!