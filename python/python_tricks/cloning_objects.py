# Cloning Objects
# Shallow vs Deep copies
# Shallow: References, but a new record will not be in the copied obj
# Deep: Creates a copy of the object >> Independent of original obj

# Shallow Copies
xs = [[1,2,3], [4,5,6], [7,8,9]]
ys = list(xs) # creates a shallow copy

xs.append(['new sublist'])
xs
ys

xs[1][0] = 'X'
xs
ys


# Deep Copies
import copy
xs = [[1,2,3], [4,5,6], [7,8,9]]
zs = copy.deepycopy(xs)

xs[1][0] = 'X'
xs
zs