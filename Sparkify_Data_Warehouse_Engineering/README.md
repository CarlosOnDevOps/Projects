# Data Engineering: Building Sparkify's Music Data Warehouse
#### Prepared by: Jose Carlos Moreno Ramirez
#### Institution: Western Governors University
#### Course: Data Wrangling - D309 
#### Project: Data Modeling with PostgreSQL
---
## Table of Contents

- [Introduction](#intro)
- [Description](#describe)
- [Project Datasets](#data)
  - [Song Dataset](#song)
  - [Log Dataset](#log)
- [Schema for Song Play Analysis](#schema)
  - [Fact Table](#fact)
  - [Dimension Tables](#dim)
- [Processing Song Data](#p_song)
- [Processing Log Data](#p_log)
- [Files](#files)
- [Software Requirements](#sw_reqs)
- [Conclusion](#conclusion)

---
<a id="intro"></a>

## Introduction

Sparkify, a forward-thinking startup, is on a mission to gain valuable insights from the wealth of data they've accumulated through their new music streaming application. Their analytics team has a burning desire to comprehend the listening habits of their users. However, there's a significant roadblock: they currently lack an efficient method to query their data, which is stored within a directory of JSON logs containing user activity on the app, as well as a separate directory housing JSON metadata for the app's song catalog.

Recognizing the need to harness this data for insights, Sparkify has enlisted the expertise of a data engineer. That's where you come in. Your task is to architect a Postgres database complete with meticulously designed tables, finely tuned to optimize queries for in-depth song play analysis. This project empowers you to craft a robust database schema and build a powerful ETL (Extract, Transform, Load) pipeline to facilitate the analysis process. To validate the effectiveness of your work, you'll have the opportunity to run queries provided by Sparkify's analytics team and compare your results with their expected outcomes.

---
<a id="describe"></a>

## Description

In this interesting project, you'll put your newfound knowledge of data modeling with Postgres to the test while also flexing your data engineering muscles by building a solid ETL (Extract, Transform, Load) pipeline using Python's capability. Your aim is to create an all-encompassing data solution that handles the complexities of data modeling and analysis.

To complete this task, you will begin on a journey to develop a star schema, which is a well-structured design comprised of fact and dimension tables. This schema is tailored to a certain analytical focus, giving you the key to extracting meaningful insights from data.

The building of an effective ETL pipeline is at the heart of this project. This pipeline will act as a link between raw data stored in files in two local directories and a pristine, optimized Postgres database. You'll coordinate the seamless movement of data, transforming it along the way into meaningful, actionable insights, armed with the powerful pair of Python and SQL.

By the end of the project, you'll not only have a perfectly optimized database schema, but also a robust data pipeline ready to take on the difficult world of data analytics. Your newly acquired abilities will be put to the test as you execute queries supplied by Sparkify's analytics team, with the satisfaction of comparing your findings to their expectations.

---
<a id="data"></a>

## Project Datasets

<a id="song"></a>

### Song Dataset

The first dataset is derived from the [Million Song Dataset](https://labrosa.ee.columbia.edu/millionsong/) in JSON format. Each file contains information about songs and their respective artists. These files are organized based on the first three letters of each song's track ID. For instance, here are the paths to two sample files:

<pre>
data/song_data/A/B/C/TRABCEI128F424C983.json
data/song_data/A/A/B/TRAABJL12903CDCF1A.json
</pre>

And below is an example of what a single song file, TRAABJL12903CDCF1A.json, looks like.

<pre>
{"num_songs": 1, "artist_id": "ARJIE2Y1187B994AB7", "artist_latitude": null, "artist_longitude": null, "artist_location": "", "artist_name": "Line Renaud", "song_id": "SOUPIRU12A6D4FA1E1", "title": "Der Kleine Dompfaff", "duration": 152.92036, "year": 0}
</pre>

<a id="log"></a>
### Log Dataset

The second dataset comprises log files in JSON format. These logs are generated using an event simulator linked [here](https://github.com/Interana/eventsim) and are based on the songs dataset mentioned earlier. These logs simulate user activity on a music streaming application and are created according to specific configurations.

---
<a id="schema"></a>
## Schema for Song Play Analysis
We will create a star schema optimized for querying song play analysis. This schema includes the following tables:

<a id="fact"></a>
### Fact Table

1. **songplays** - Records in log data associated with song plays, i.e., records with page `NextSong`
    - songplay_id
    - start_time
    - user_id
    - level
    - song_id 
    - artist_id 
    - session_id
    - location
    - user_agent

<a id="dim"></a>

### Dimension Tables

1. users - User information:
    - user_id
    - first_name
    - last_name
    - gender
    - level
    
2. songs - Song information:
    - song_id
    - title
    - artist_id
    - year
    - duration

3. artists - Artist information:
    - artist_id
    - name
    - location
    - latitude
    - longitude
    
4. time - Time information: Timestamps of records in **songplays** broken down into specific units.
    - start_time
    - hour
    - day
    - week
    - month
    - year
    - weekday

We conduct Extract, Transform, and Load (ETL) operations on data from the song_data and log_data directories to construct these tables.

---
<a id='p_song'></a>
### Processing Song Data
To create the songs and artists tables, we start by extracting data from the song_data directory. Below is a snippet of the data structure:

<pre>
{
    "artist_id": "AR36F9J1187FB406F1",
    "artist_latitude": 56.27609,
    "artist_location": "Denmark",
    "artist_longitude": 9.51695,
    "artist_name": "Bombay Rockers",
    "duration": 230.71302,
    "num_songs": 1,
    "song_id": "SOBKWDJ12A8C13B2F3",
    "title": "Wild Rose (Back 2 Basics Mix)",
    "year": 0
}
</pre>

We select the relevant columns and insert data into the respective tables as shown below:

```python
# Extracting song data
song_data = df[['song_id', 'title', 'artist_id', 'year', 'duration']].values[0].tolist()
# Output looks like: ['SOBKWDJ12A8C13B2F3',
 'Wild Rose (Back 2 Basics Mix)',
 'AR36F9J1187FB406F1',
 0,
 230.71302]

# Extracting artist data
artist_data = df[["artist_id", "artist_name", "artist_location", "artist_latitude", "artist_longitude"]].values[0]
# Output looks like: array(['AR36F9J1187FB406F1', 'Bombay Rockers', 'Denmark', 56.27609, 9.51695], dtype=object)

# Creating a cursor
cur = conn.cursor

# Inserting data into songs table
cur.execute(song_table_insert, song_data)
conn.commit()

cur.execute(artists_table_insert, song_data)
conn.commit()

# Note: `conn` represents the connection to the Postgres database and should be properly configured with the host, dbname, user, and password.

# Note: The variables `song_table_insert` and `artist_table_insert` correspond to SQL queries defined in the `sql_queries.py` file.
```

---
<a id='p_log'></a>

### Processing Log Data

In this section, we'll perform the ETL (Extract, Transform, Load) process on the log data files located in the *log_data* directory. Our goal is to create the remaining two-dimensional tables: `time` and `users`, as well as the `songplays` fact table.

Each log file contains JSON-formatted records that represent user activity in a music streaming app. To build our tables, we'll follow these steps:

1. **Filter Records**: We'll first filter the log records to include only those with the `page` value equal to `'NextSong'`, indicating that a user has played a song.

2. **Extract Timestamps**: We'll extract the `ts` (timestamp) column from the log records and convert it into a datetime format using Python's datetime functions. This will enable us to break down the timestamp into various time units.

3. **Create Time Data**: We'll create a DataFrame (`time_df`) to hold the time data, including columns for `start_time`, `hour`, `day`, `week of year`, `month`, `year`, and `weekday`. This data will be used for the `time` dimension table.

4. **Extract User Data**: We'll extract user-related information from the log records, including `userId`, `firstName`, `lastName`, `gender`, and `level`. This data will populate the `users` dimension table.

5. **Query Song Data**: For the `songplays` fact table, we need to determine the `song_id` and `artist_id` based on the `title`, `artist_name`, and `duration` from the log records. We'll execute the `song_select` query to retrieve this information.

6. **Insert Data**: We'll insert the relevant data into the `songplays` fact table, including columns like `start_time`, `user_id`, `level`, `song_id`, `artist_id`, `sessionId`, `location`, and `userAgent`.

7. **Load Data into Tables**: Finally, we'll insert the processed data into their respective tables (`time`, `users`, and `songplays`) in the PostgreSQL database.

This ETL process ensures that our database contains well-organized data for future analysis and querying. The `song_select` query is essential for connecting log data with song and artist data, as the log files themselves do not contain song and artist IDs.

By performing this ETL process, we're creating a foundation for valuable insights and analytics on user interactions with songs in the music streaming app.

---
<a id='files'></a>

## Files

The project directory contains the following key files:

- **create_tables.py**: This script is responsible for dropping and creating the necessary tables in the PostgreSQL database. Running this file ensures that the tables are reset before each execution of the ETL (Extract, Transform, Load) scripts.

- **etl.ipynb**: An interactive Jupyter Notebook that demonstrates the ETL process for a single file from the *song_data* and *log_data* directories. It provides a step-by-step walkthrough of data extraction, transformation, and loading into the database tables.

- **etl.py**: This Python script automates the ETL process by reading and processing files from both *song_data* and *log_data* directories, subsequently loading the data into their respective tables in the PostgreSQL database. The script is based on the concepts explored in the *etl.ipynb* notebook.

- **sql_queries.py**: A central repository for storing all SQL queries required for table creation, data insertion, and data selection. This modular approach makes it easier to manage and maintain SQL queries.

- **test.ipynb**: Another Jupyter Notebook that allows you to check the integrity of the database by displaying the first few rows of each table. It serves as a quick way to verify that the ETL process was successful.

---
<a id="sw_reqs"></a>
## Software Requirements

To successfully execute this project, you need the following software requirements:

- **Python 3**: This project is developed using Python, and it's essential to have Python 3 or a compatible version installed.

- **Required Libraries**: Ensure that the necessary Python libraries and dependencies mentioned in the *requirements.txt* file are installed. You can use the following command to install these dependencies:
  
- **PostgreSQL and pgAdmin 4**: Your tables and data will be created within the PostgreSQL environment. For instructions on how to install and configure your server, reference my blog [How to Install PostgreSQL and pgAdmin 4 - Simplified](https://medium.com/@cmor3/how-to-install-postgresql-and-pgadmin-4-simplified-270e0b32a05b)

---
<a id="conclusion"></a>

## Conclusion
In this project, we have successfully created a PostgreSQL database from two JSON data directories: *song_data* and *log_data*. The ETL (Extract, Transform, Load) process involved extracting data from these directories, performing data transformations and filtering, and finally inserting the transformed data into the appropriate tables within the database.

This clean and structured data is now ready for use in ad-hoc queries, basic aggregations, and analytics. The project's modular design and use of SQL queries in the *sql_queries.py* file make it easy to extend and adapt for future data processing needs.