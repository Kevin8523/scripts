# Data Structures
# Dicts, Array: Lists, tuples, sets, stacks

# Dictionaries: Key Value Relationship
# Subclasses: Ordered Dictionary,
#             Default Dict (Returns default for missing values),
#             Multiple Dictionaries,
#             Read only Dictionary

# Adding an Ordered dictionary - collections module
import collections
d = collections.OrderedDict(one=1, two=2, three=3)
d

d['four'] = 4
print(d)


# Arrays
# Subclasses: Mutable Dynamic Arrays: Lists, Tuples, Basic Typed Arrays, str, bytes
# Typically just use a list and if you need more speed , specialize
