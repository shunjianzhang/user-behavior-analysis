import pandas as pd
from sqlalchemy import create_engine
columns = ['user_id','item_id','category_id','behavior_type','ts']
df = pd.read_csv('d:/个人项目/数据集/UserBehavior.csv',header = None,names=columns,nrows = 100000)

print(df.shape)
print(df.head())
print(df['behavior_type'].value_counts())
df.to_csv('UserBehavior_subset.csv',index = False)
engine = create_engine('mysql+pymysql://root:你的密码@localhost:3306/user_behavior?charset=utf8mb4')
df.to_sql('user_behavior',con=engine,if_exists='replace',index=False,chunksize=10000)

