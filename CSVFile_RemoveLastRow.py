'''
Remove last row of csv file
'''


import os
import pandas as pd


# path = r'L:\MIT\Projects\RetailSonarPredictModule\geocoder_input_f1000.csv'
path = r'L:\MIT\Projects\RetailSonarPredictModule\geocoder_input_f2000.csv'

df = pd.read_csv(path, delimiter=';')

print(df.info())

