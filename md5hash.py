'''

Generating MD5 Hashes.
https://www.geeksforgeeks.org/md5-hash-python/


encode() : Converts the string into bytes to be acceptable by hash function.
digest() : Returns the encoded data in byte format.
hexdigest() : Returns the encoded data in hexadecimal format.

'''


import hashlib



# OR encode text

text = 'Daniel'

result = hashlib.md5(text.encode())   # .encode()

print("Hashing '{}' into MD5 results in : {}".format(text, result.hexdigest()))




# OR provide string in bytes


text_byte = b'Daniel'     # b'text

result = hashlib.md5(text_byte)

print('Hashing "{}" into MD5 results in : {}'.format(text_byte, result.hexdigest()))
