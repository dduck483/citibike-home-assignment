import duckdb
from pathlib import Path

csv_path = Path.home() /'Users/<YourName>/Downloads/rootproject/data/2014-citibike-tripdata'

# Connect (creates the .duckdb file if it doesn't exist)
con = duckdb.connect('Users/<YourName>/Downloads/rootproject/database/mydb.duckdb')

for csv_file in csv_path.glob("*.csv"):
    #Output which file is loading.
    print(f"Loading file {csv_file} \n")
    #CREATE TABLE IF NOT EXISTS avoids overwriting an existing table.
    con.execute(f'''CREATE TABLE IF NOT EXISTS trip_data AS SELECT * FROM read_csv_auto('{csv_file}')''')

print(f"2014 trip data loaded")

con.close()
