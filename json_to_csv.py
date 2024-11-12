import pandas as pd
import json

df = pd.read_json('gears.json')
print(df)

# df_json = pd.json_normalize(df)
df.to_csv("gears.csv", encoding='utf-8')
