'''
Show SQL Files where word is in text.
'''

import os
import os.path
import sys


never_to_be_found = "aclmkjqsdfpojqsldkfj1346843131315"
# get search words as command line input
word2 = never_to_be_found
word3 = never_to_be_found
if len(sys.argv) == 2:
    word = str(sys.argv[1]).upper().strip()
    print("\n>> Searching for '{}' in SQL queries.".format(word))
elif len(sys.argv) == 3:
    word = str(sys.argv[1]).upper().strip()
    word2 = str(sys.argv[2]).upper().strip()
    print("\n>> Searching for '{}' & '{}' in SQL queries.".format(word, word2))
elif len(sys.argv) > 3:
    word = str(sys.argv[1]).upper().strip()
    word2 = str(sys.argv[2]).upper().strip()
    word3 = str(sys.argv[3]).upper().strip()
    print("\n>> Searching for '{}' & '{}' & '{}' in SQL queries.".format(word, word2, word3))    
else:
    print("\n>> No search word given. Please provide search word as argument.\n")
    sys.exit()


# all SQL files in U:/ & L:/MIT/
file_list = []
for dirpath, dirnames, filenames in os.walk("U:\\"):
    for filename in [f for f in filenames if f.endswith(".sql")]:
        f = os.path.join(dirpath, filename)
        #print(f)
        file_list.append(f)

for dirpath, dirnames, filenames in os.walk("L:\\MIT\\"):
    for filename in [f for f in filenames if f.endswith(".sql")]:
        f = os.path.join(dirpath, filename)
        #print(f)
        file_list.append(f)
        
print(">> Found {} SQL queries.".format(len(file_list)))


print("\n>> FILES FOUND:")
# find word in SQL queries
list_lines = []
total_lines = 0
def FindWordSQL(file_name):

    global total_lines
    global list_lines
    
    # read file
    with open(file_name, 'r') as f:
        content = [f.strip().replace('\n','').replace(' ','').upper() for f in f.readlines()]
        #print(len(content))
        
    cnt = 0  #print file once if result found
    lines = []
    for line in content:
        if word in line or word2 in line or word3 in line:
            if cnt == 0:
                print('-->> ' + file_name)
                cnt += 1
            full_line ="Ln {}: {}".format(content.index(line), line)
            lines.append(full_line) 

    # update list of lines if results
    if len(lines) > 0:
        list_lines.append([file_name,lines])
        total_lines += len(lines)


for f in file_list:
    FindWordSQL(f)
#print(list_lines)


# print lines if user input 'Y'
answer = input("\nDo you want to see all ({}) lines found? (Y/N)\n>>> ".format(total_lines))
if answer.strip().upper() == 'Y':
    print()
    for result in list_lines:
        print('\nFILE: -->> ' + result[0])
        for r in result[1]:
            print(r)


print('\nDone.\n')




        
