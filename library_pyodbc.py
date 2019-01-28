'''

Tricks on Python Library : PYODBC

'''

import pyodbc
import pandas as pd


# connection to SQL SERVER
def Query_JBC_BI(sql_query): 
    
    con = pyodbc.connect("Driver={SQL Server};"
                      "Server=biprod;"
                      "Database=JBC_BI;"
                      "Trusted_Connection=yes;")

    df = pd.read_sql_query(sql_query, con)
    con.close()

    return df # returns query in dataframe
