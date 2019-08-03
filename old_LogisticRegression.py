'''
Logistic Regression.
'''
from AwesomeFunctions import ShowRunTime
from ConnectionDWH import Query_JBC_BI_Sandbox
import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
import time

import statsmodels.discrete.discrete_model as sm
from scipy import stats
stats.chisqprob = lambda chisq, df: stats.chi2.sf(chisq, df) # to make results.summary() work !!

startTime = time.time()

# load data
df = Query_JBC_BI_Sandbox("select * from dbo.CustomerOverviewFull where right(CUSTOMER_WID,1) = 3")
#print(df.info())

# create target variable
df['UpDownAmount'] = df['OmzetTotaal_17'] - df['OmzetTotaal_16']
def StijgerDaler(x):
    if x <= 0:
        return 'DALER'
    if x > 0:
        return 'STIJGER'
    
df['UpDown'] = df['UpDownAmount'].apply(StijgerDaler)
#print(df.head())

# create categories
df["Taal"] = df["Taal"].astype('category')
df["Geslacht"] = df["Geslacht"].astype('category')
df["Value16"] = df["Value16"].astype('category')
df["Segment16"] = df["Segment16"].astype('category')


# logistic regression
x_cols = ['OmzetTotaal_16', 'OmzetOnline_16', 'Stores_2016', 'Tickets_2016', 'Items_2016',
                   'OmzetKind_16', 'OmzetDames_16', 'OmzetHeren_16', 'OmzetAndere_16',
                   'Leeftijd','Kinderen', 'Taal', 'Geslacht', 'Segment16', 'Value16']

df_all = df[x_cols + ['UpDown']].dropna()
print(df_all.shape)

X = pd.get_dummies(df_all[x_cols], columns=["Taal","Geslacht", "Value16", "Segment16"])  #hot encoding
#print(X.info())
y = df_all['UpDown']
#print(y.head())

logreg = LogisticRegression()
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2, random_state=42)
logreg.fit(X_train, y_train)
#y_pred = logreg.predict(X_test)
#print(logreg.get_params())
print(pd.DataFrame(X.columns, logreg.coef_[0]))

### sm
print("\n --- STATSMODELS ---\n")
x_clms = x_cols[:11]
y_pred = y.apply(lambda x: 0 if x == 'DALER' else 1)
logit = sm.Logit(y_pred, X[x_clms])
result = logit.fit()
print(result.params)
print()
print(result.summary())


# close
print("\nDone.\n")
print(ShowRunTime(startTime, time.time()))
