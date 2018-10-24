# Change the format of Pulse_ file downstairs
import easygui
import pandas as pd
import numpy as np
# Read csv and get index of lines with nan... and without nan
filenameData = easygui.fileopenbox()
df = pd.read_csv(filenameData, sep=';', header=None)
idx = df.index[df[df.columns[1]].isnull()]
idx2 = df.index[df[df.columns[1]].notnull()]
# Shift values at idx lines to the second column
df.loc[idx, 1] = df.loc[idx, 0].values
df.loc[idx, 0] = np.nan
# Hardcore way to work with time
df.loc[idx2, 0] = df.loc[idx2, 0].apply(lambda x: float(x.split(':')[0])*3600+float(x.split(':')[1])*60+float(x.split(':')[2]))
# Calculate the step for arange and create arange
step = (df.iloc[idx2[-1], 0]-df.iloc[idx2[0], 0])/(idx2[-1]-idx2[0])
df[0] = np.arange(df.iloc[0, 0], df.iloc[0, 0]+step*df[0].size, step)
df[0] = df[0].apply(lambda x: str(int(x//3600))+':'+str(int((x%3600)//60))+':'+str(round(x%60, 8)))
df[0] = pd.to_datetime(df[0])
# Create one more column fot the pulse data
df['Pulse'] = 0

# Read second csv. Replace Data with Pulse
filenamePulse = filenameData.strip(filenameData.split('/')[-1]) + filenameData.split('/')[-1].replace('Data', 'Pulse')
df2 = pd.read_csv(filenamePulse, sep= ';', header = None)
df2[0] = df2[0].apply(lambda x: float(x.split(':')[0])*3600+float(x.split(':')[1])*60+float(x.split(':')[2]))
# This cycle works with number of lines in pulse file
for i in range(df2[0].size):
    start = float(df2.iloc[i, 0])
    initialDelay = float(str(df2.iloc[i, 1]).split(':')[1])
    width = float(str(df2.iloc[i, 1].split(':')[2]))
    deltaPulse = float(str(df2.iloc[i, 1].split(':')[3]))
    number = int(str(df2.iloc[i, 1].split(':')[4]))
    # This one is for the number of pulses in each line
    for k in range(number):
        time = start+initialDelay+deltaPulse*k+width*k
        # Create an arange with time for the
        npArrange = np.arange(time, time+width, step)
        dfToAdd = pd.DataFrame(data=[npArrange, np.ones(len(npArrange))]).T
        dfToAdd[0] = dfToAdd[0].apply(lambda x: str(int(x//3600))+':'+str(int((x%3600)//60))+':'+str(round(x%60,8)))
        dfToAdd[0] = pd.to_datetime(dfToAdd[0])
        # Another df, but in fact I'll use only last column
        temp_df = pd.merge_asof(df,dfToAdd,on=0,tolerance=pd.Timedelta('1ms'))
        df['Pulse'] = df['Pulse'] + temp_df[temp_df.columns[-1]].fillna(0)
outputFilename = filenameData.strip(filenameData.split('/')[-1]) + filenameData.split('/')[-1].replace('Data', 'Merged')
df.to_csv(outputFilname)