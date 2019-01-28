'''
Random password generator.
'''
import numpy as np
import string

# Full list of possible characters
full_string = string.ascii_letters + string.digits
length = len(full_string)
#print(full_string)
#print(len(full_string))

# generate random sequence of n characters
pw = ''
for i in range(14):
    r = np.random.randint(length)
    pw += full_string[r]

print(pw)
