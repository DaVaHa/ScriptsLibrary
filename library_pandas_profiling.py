'''

Tricks on Python Library : PANDAS_PROFILING

Generates profile report from DataFrame : data types, unique/missing values, statistics,...

https://github.com/pandas-profiling/pandas-profiling
pip install pandas-profiling
'''


#We recommend generating reports interactively by using the Jupyter notebook.
#Start by loading in your pandas DataFrame, e.g. by using

import pandas as pd
import pandas_profiling

#To display the report in a Jupyter notebook, run:
pandas_profiling.ProfileReport(df)

#To retrieve the list of variables which are rejected due to high correlation:
profile = pandas_profiling.ProfileReport(df)
rejected_variables = profile.get_rejected_variables(threshold=0.9)

#If you want to generate a HTML report file, save the ProfileReport to an object and use the to_file() function:
profile = pandas_profiling.ProfileReport(df)
profile.to_file(outputfile=r"U://MIT/Python/PandasProfiling.html")
