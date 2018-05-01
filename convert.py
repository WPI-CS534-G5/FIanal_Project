import pandas as pd

# Read In Data
headers = ['ip', 'app', 'device', 'os', 'channel', 'click_time', 'attributed_time', 'is_attributed']
df = pd.read_csv('sub_3.csv')
df.columns = headers

# Calculate IP Counts
df_ip_counts = df.groupby('ip')['ip'].transform('count')  # type: pd.Series
df_ip_counts.rename('ip_count')

# Add IP Counts Column
df = pd.concat([df, df_ip_counts], axis=1)  # type: pd.DataFrame

# Save to CSV
df.columns = ["V1", "V2", "V3", "V4", "V5", "V6", "V7", "V8", "V9"]
df.to_csv('ip_counts.csv', index=None)
