'''
Cleans NULL BYTE from file.
'''

import pandas as pd
import os


# Cleans NULL BYTE from file
##fi = open(path+'FULL_EXP_EMDB.csv', 'rb')
##data = fi.read()
##fi.close()
##
##fo = open(path+'EMDB_CLEAN.csv', 'wb')
##fo.write(data.replace(b'\x00', b''))
##fo.close()


####
path = r'L:\MARKETING\Data\de mannen\\'
files = [f for f in os.listdir(path) if f.endswith('.csv')]
print(files)

for f in files:
        
    file = open(path+f, 'rb')
    txt = file.read()
    file.close()
    
    fo = open(path+f.replace('.csv', '_COPY.csv'), 'wb')
    fo.write(txt.replace(b'\x00', b''))
    fo.close()
    

