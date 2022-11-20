# run "pip install pandas lightgbm sklearn numpy" first
import pandas as pd
import lightgbm as lgb
from sklearn import tree
from sklearn.model_selection import cross_validate
import numpy as np

df = pd.read_csv('2015_IMS_ADS.nt.csv')
df = df.drop(columns=['V1'])

target_columns = [
  'FT_1',
  'FT_2',
  'FT_3',
  'FT_4',
  'FT_5',
  'FT_6',
  'W_1',
  'W_2',
  'W_3',
  'W_4',
  'W_5',
  'W_6',
  'LF_3',
  'LF_5']

target_column = ['FT_1']
targets = df[target_column]

# Drop rows where the target value is NaN.
invalid_index = df[df['FT_1'].isna() == True].index
train_df = df.drop(invalid_index)

# Replace NaN with -100, this may or may not help.
x_data = train_df.drop(columns = target_columns)
x_data[x_data.isna()] = -100
y_data = train_df[target_column]

# Do the cross validation
cv_scores = []
for _ in range(100):
    clf = tree.DecisionTreeRegressor(max_depth=20)
    cv_scores.append(np.mean(cross_validate(clf, x_data, y_data, cv=2,scoring=('neg_mean_squared_error'))['test_score']))
print(np.mean(cv_scores), np.std(cv_scores))