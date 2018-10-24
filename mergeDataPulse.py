# Write comments
# Change the format of Pulse_ file downstairs
# Add the UI box for retriebvng csv files
import pandas as pd
import numpy as np
df = pd.read_csv('Data_10-19-2018_15-12-59.csv', sep=';', header=None)
idx = df.index[df[df.columns[1]].isnull()]
idx2 = df.index[df[df.columns[1]].notnull()]
df.loc[idx ,1] = df.loc[idx,0].values
df.loc[idx ,0] = np.nan
#df[0] = pd.to_datetime(df[0],format='%H:%M:%S.%f')
df.loc[idx2 ,0] = df.loc[idx2,0].apply(lambda x: float(x.split(':')[0])*3600+float(x.split(':')[1])*60+float(x.split(':')[2]))
step = (df.iloc[idx2[-1],0]-df.iloc[idx2[0],0])/(idx2[-1]-idx2[0])
df[0] = np.arange(df.iloc[0,0],df.iloc[0,0]+step*df[0].size,step)
df[0] = df[0].apply(lambda x: str(int(x//3600))+':'+str(int((x%3600)//60))+':'+str(round(x%60,8)))
df[0] = pd.to_datetime(df[0])
df['Pulse'] = 0


df2 = pd.read_csv('Pulse_10-19-2018_15-12-59.csv', sep= ';', header = None)
df2[0] = df2[0].apply(lambda x: float(x.split(':')[0])*3600+float(x.split(':')[1])*60+float(x.split(':')[2]))
for i in range(df2[0].size):
	start = float(df2.iloc[i,0])
	initialDelay = float(str(df2.iloc[i,1]).split(':')[1])
	width = float(str(df2.iloc[i,1].split(':')[2]))
	deltaPulse = float(str(df2.iloc[i,1].split(':')[3]))
	number = int(str(df2.iloc[i,1].split(':')[4]))	
	for k in range(number):
		time = start+initialDelay+deltaPulse*k+width*k
		npArrange = np.arange(time, time+width, step)
		dfToAdd = pd.DataFrame(data=[npArrange, np.ones(len(npArrange))]).T
		dfToAdd[0] = dfToAdd[0].apply(lambda x: str(int(x//3600))+':'+str(int((x%3600)//60))+':'+str(round(x%60,8)))
		dfToAdd[0] = pd.to_datetime(dfToAdd[0])
		temp_df = pd.merge_asof(df,dfToAdd,on=0,tolerance=pd.Timedelta('1ms'))

		df['Pulse'] = df['Pulse'] + temp_df[temp_df.columns[-1]].fillna(0)

df.to_csv('output.csv')