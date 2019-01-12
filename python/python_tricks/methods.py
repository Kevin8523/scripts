# Instance Methods, Class Methods, Static Methods, 
# Instance Method: Can modify object's state and modify class state. Takes a parameter self
# Class Method: Can't modify object instance state, but can modify class state that applies across all instances of the class
#				Takes a cls paramter that points to the class (NOT the object instance) when method is called
# Static Method: Can't modify object state or class state. Primary a way to namespace your methods

class MyClass:
	def method(self):
		return 'instance method called', self

	@classmethod
	def classmethod(cls):
		return 'class method called', cls

	@staticmethod
	def staticmethod():
		return 'static method called

# Instance: Need a class and can access the instance through self
obj = MyClass()
obj.method()

# Class
obj.classmethod()

# Example of Class methods with factory functions
class Pizza:
	def __init__(self, ingredients):
		self.ingredients = ingredients
	
	def __repr__(self):
		return f'Pizza({self.ingredients!r})'
		@classmethod
		def margherita(cls):
			return cls(['mozzarella', 'tomatoes'])
		
		@classmethod
		def prosciutto(cls):
			return cls(['mozzarella', 'tomatoes', 'ham'])


# Example of Static Methods
import math
class Pizza:
	def __init__(self, radius, ingredients):
		self.radius = radius
		self.ingredients = ingredients
	
	def __repr__(self):
		return (f'Pizza({self.radius!r}, '
			f'{self.ingredients!r})')
	
	def area(self):
		return self.circle_area(self.radius)
	
	@staticmethod
	def circle_area(r):
		return r ** 2 * math.pi

p = Pizza(4, ['mozzarella', 'tomatoes'])
p.area()
Pizza.circle_area(4)