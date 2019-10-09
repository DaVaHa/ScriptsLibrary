"""

Append CSV files into one file.


"""




import os
import pandas as pd



# paths
path = r'L:\MARKETING\Data\de mannen\2- Campagnes\1. Folder\2. Aantallen & selectie doorgeven\Selectie zips\2019\Recuperatie Vilvoorde & Genesius\Reminder\\'

# parameters & files
dataframes = []
columns_wanted = ['CARDNUMBER','PREFERRED_SHOPID','COUNTRY','LANG']
csv_files = [f for f in os.listdir(path) if 'BEBE' in f and f.endswith('.csv')]
print(csv_files)

print('\n>> REMOVING "-characters from files:')
# remove " from files
for f in csv_files:
    
    print("Processing : {}".format(f))
    try:
        
        # read content
        file = open(path + '\\' + f, 'r')
        text = file.read()
        file.close()

        # overwrite new content : " 
        fo = open(path + '\\' + f, 'w')
        fo.write(text.replace('"', ''))
        fo.close()

        # read content again
        file = open(path + '\\' + f, 'rb')
        txt = file.read()
        file.close()

        # replace NULL bytes
        fo = open(path + '\\' + f, 'wb')
        fo.write(txt.replace(b'\x00', b''))
        fo.close()

    except Exception as e:
        print("ERROR : {}".format(str(e)))



print('\n>> READING CSV FILES:')
# loop over files & append to list of dataframes
for f in csv_files:

    print("Processing : {}".format(f))
    try:



        # process csv file
        df = pd.read_csv(path + '\\' + f,
                         #error_bad_lines=False,
                         encoding='latin1',
                         usecols=columns_wanted)


        df.dropna(inplace=True)  # drop empty cards & storeid
        df['CARDNUMBER'] = df['CARDNUMBER'].astype(int)
        df['PREFERRED_SHOPID'] = df['PREFERRED_SHOPID'].astype(object)

        # filename break
        winkel = f[:f.find('_')]  # 'Vilvoorde'
        f2 = f[f.find('_')+1:]
        actie = f2[:f2.find('_')]
        f3 = f2[f2.find('_')+1:]
        segment = f3[:f3.find('.')]
        
        # actie : punten / procent
        df['ACTIE'] = actie
        
        # winkel
        df['WINKEL'] = winkel

        # segment
        df['SEGMENT'] = segment

        # check
        if len(df) == len(df.dropna()):
            print("Check no NAs : OK")
        else:
            print("CHECK NOT OK : df - {} vs df.dropna() - {}".format(len(df), len(df.dropna())))

        #print(df.head(5))

        dataframes.append(df)

    except Exception as e:
        print("ERROR : {}".format(str(e)))




print('\n>> EXPORTING COMBINED CSV FILE:')
# combine all dataframes
df_all = pd.concat(dataframes)

print(df_all.info())
print(df_all.head(10))
print(df_all.tail(10))

print(df_all[['CARDNUMBER', 'ACTIE','WINKEL', 'SEGMENT']].groupby(['ACTIE','WINKEL', 'SEGMENT']).count())

df_all.to_csv(path+'RecuperatieReminderSGRVilvoorde.csv', index=False)



'''

=> Rename files.

import os
# paths
path = r'L:\MIT\Projects\FolderAnalyse\WinterSint18\\'

files = [f for f in os.listdir(path) if f.endswith('.csv')]
print(files)
for f in files:
    new_name = f.replace('.csv', '_Folder.csv')
    os.rename(path + f, path + new_name)


'''
