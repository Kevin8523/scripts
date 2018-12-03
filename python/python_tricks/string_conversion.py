# String Conversion in Classes
# Add a __str__ dunder method to allow printing
# Reccomends to always implement a __repr__  in your classes

Class Car:
	def __init__(self,color,mileage):
		self.color = color
		self.mileage = mileage
		
	def __repr__(self):
		return (f'{self.__class__.__name__}('
			f'{self.color!r}, {self.mileage!r})')

	def __str__(self):
		return f'a {self.color} car'