import requests
import pandas as pd
import duckdb
from pathlib import Path

# ----- 1️⃣ Settings -------------------------------------------------
LATITUDE  = 40.7128          # example location
LONGITUDE = -74.0060
YEAR      = 2014
TIMEZONE  = "UTC"

# ----- 2️⃣ Fetch historical weather ---------------------------------
url = "https://archive-api.open-meteo.com/v1/archive"
params = {
    "latitude": LATITUDE,
    "longitude": LONGITUDE,
    "start_date": f"{YEAR}-01-01",
    "end_date":   f"{YEAR}-12-31",
    "daily": "temperature_2m_max,temperature_2m_min,precipitation_sum",
    "timezone": TIMEZONE,
}
resp = requests.get(url, params=params, timeout=30)
resp.raise_for_status()
daily = resp.json()["daily"]

# ----- 3️⃣ Build a pandas DataFrame -------------------------------
df = pd.DataFrame({
    "date":       pd.to_datetime(daily["time"]),
    "temp_max":   daily["temperature_2m_max"],
    "temp_min":   daily["temperature_2m_min"],
    "precip_mm":  daily["precipitation_sum"],
})

# ---------- 4️⃣ Add season column ----------
def month_to_season(m):
    if m in (12, 1, 2):   return "Winter"
    if m in (3, 4, 5):    return "Spring"
    if m in (6, 7, 8):    return "Summer"
    return "Autumn"       # months 9‑11

df["season"] = df["date"].dt.month.apply(month_to_season)

# ---------- 5️⃣ Persist to DuckDB ----------
db_path = Path.home() / 'Users/<YourName>/Downloads/rootproject/database/mydb.duckdb'
con = duckdb.connect(db_path)

con.execute("DROP TABLE IF EXISTS weather_data_2014")
con.register("weather_tmp", df)                     # temporary view
con.execute("CREATE TABLE weather_data_2014 AS SELECT * FROM weather_tmp")
con.unregister("weather_tmp")
con.close()

# ----- 4️⃣ Load into DuckDB ----------------------------------------
#db_path = Path.home() / 'Users/<YourName>/Downloads/rootproject/database/mydb.duckdb'
#con = duckdb.connect(str(db_path))

# Drop any previous version (optional)
#con.execute("DROP TABLE IF EXISTS weather_data_2014")

# Write the DataFrame directly – DuckDB handles the conversion
#con.register("weather_df", df)          # temporary view
#con.execute("CREATE TABLE weather_data_2014 AS SELECT * FROM weather_df")
#con.unregister("weather_df")           # clean up
#con.close()

print(f"2014 weather data loaded")
