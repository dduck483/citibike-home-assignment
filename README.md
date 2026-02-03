# citibike-home-assignment

How to set up and run the pipeline:

● Pre-requisuites: Install latest version of python via python.org
Install: pip for python via cmd python3 -m pip install
Package required to run python scripts: duckdb, Path, requests, pandas via cmd: pip install <packagename>
Download the citibike data file here: https://s3.amazonaws.com/tripdata/2014-citibike-tripdata.zip and store in the path suitable for downloads. I.e. /Users/<YourUser>/Downloads/rootproject/data/2014-citibike-tripdata

Briefly explain how you approached the problem:

● Python scripts used to import data with the help of AI. Data manipulation done via DuckDB CLI.

What you would do differently if you had to do it again

● Create and run everything in a Docker container.

How you think we can improve this challenge:

● The challenge should be tailored to the data set for the exact data set to match the questions.

PART A:

Written answers to the technical questions listed below:

1. If we keep policy records in JSONB format, what are the trade-offs compared to using a
normalised table schema?

JSONB format is beneficial if there is a need for API heavy querying. Meaning, all data can be delivered in one single query. This is useful when delivering audit logs or user specific data.

Data is semi-structured and allows for an evolving or agile approach when the data model is maturing.

Trade-offs:

- Slower query performance when it comes to the heavier relational queries

- Unclear structure of data and requires more investment in normalising data into a readable format

2. What data quality checks are critical before exposing data to actuaries?

- Complete: All data provided should be complete as per the internal business use case required.
- Accurate: Records should reflect the correct figures in order to drive and make the correct decisions to provide relatively accurate premiums to a client.
- Consistency and timeliness: SLA's agreed to with tech teams should be adhered to. In the event data cannot be provided within SLA's, processes should be outlined to communicate this.

3. Suppose policy events arrive late or back-dated. How would you make the pipeline
idempotent?

In a relational database ETL pipeline, data will could flow as follows:

	- Extract data from source/s. Data will land in an "Extract" schema
  - Write and use "Upsert"  procedures to ensure records are inserted if records does not exist or updated if records does exist. This information can land in a "Stage" schema
  - Build out fact and dimensional tables to include an "error" pipeline in the event a duplicate does come from the staging schema, and output the erroneous records into an error table for further investigation
 
4. If data grows 100×, what would you change in the pipeline (infra, partitioning, modelling)?

 - Optimise code first before throwing more money at infrastructure
 - Extract source data at less business critical times to ensure their is less strain on the datasources
 - Look at the ROI if horizontal or vertical infrastructure scaling would make sense for the pipeline, however, adding more processing power does not always equate to faster data ingestion
 - Partitioning would be effective when extracting and storing data in subsets. This is helpful if datasets have data ranges. This way data can be incrementally loaded.

5. How would you design a daily "active policies" history table (SCD2-style) from event data?

Type 2 Slowing Changing Dimension should have two key columns. 

 - An "effective_date" column: The column indicates is the current record is still active. Depending on the use case, this could either NULL or have a such as "1900-01-01".
 - The "is_current" column. This column indicates if records are current. In theory, there should be only one unique policy id with a "Y" flag stating the record is current for a particular policy.


PART B:

1. Refer to B1 - Trips By Day Per Product.sql file
2. Refer to B2 - Premium Per Day.sql file
3. Refer to B3 - Daily Rainfal Trips.sql
4. Refer to B4 - Different Season Rate.sql

PART C:

1. Refer to C1 - fact_trip.sql file
2. Refer to C2 - aggregated_exposure_daily.sql file
