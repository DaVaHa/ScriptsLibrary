'''

PYTHON LIBRARY : os

'''


import os


# working directory
os.getcwd()

# list files in directory
os.listdir(path)

# rename files
os.rename(old_file_path_name, new_file_path_name)

# search in directories #default=topdown
os.walk(path)

for dirpath, dirnames, filenames in os.walk("U:\\"):
    for filename in [f for f in filenames if f.endswith(".py")]:
        f = os.path.join(dirpath, filename)
        print(f)

