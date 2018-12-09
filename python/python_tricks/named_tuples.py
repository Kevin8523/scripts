# Named Tuples
# Extension of tuples

from collections import namedtuple
Car = namedtuple('Car', 'color mileage')

# Also can pass as a list
Car = namedtuple('Car' [
	'color',
	'mileage',
])

my_car = Car('red',3812.4)
my_car.color
my_car.mileage
