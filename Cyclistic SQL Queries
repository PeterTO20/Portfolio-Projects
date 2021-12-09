/*
		CYCLISTIC BIKE SHARING CASE STUDY

NOTE: 
--- The datasets have a different name because Cyclistic is a fictional company. For the purposes of this case study, the datasets are appropriate to answer the business questions. The data has been made available by Motivate International Inc..
--- Data License Agreement and datasets used can be found here -->   https://www.divvybikes.com/system-data
--- For the purpose of this case study, only 1 year of the most recent data at the time was used.
--- This case study consists of 12 monthly datasets which represents a year of data from 2020-11-01 to 2021-10-31.
--- For this project PostfreSQL was used to clean the data and Tableau was used for data viz.
*/





---------- ###### CLEANING THE DATA ###### ----------



---> Manually created table and columns before importing data.
---> All 12 monthly datasets imported were consolidated to this table for efficiency.
---> There are a total of 13 columns and 5,378,834 rows in the new combined dataset.
---> Note that columns start_station_id and end_station_id datatype is VARCHAR in the table being created due to the IDs being integer for the year 2020 data but changes to have text in 2021. 
CREATE TABLE cyclistic_data
(
ride_id VARCHAR PRIMARY KEY,
rideable_type VARCHAR,
started_at TIMESTAMP,
ended_at TIMESTAMP,
start_station_name VARCHAR,
start_station_id VARCHAR,
end_station_name VARCHAR,
end_station_id VARCHAR,
start_lat FLOAT,
start_lng FLOAT,
end_lat FLOAT,
end_lng FLOAT,
member_casual VARCHAR
)

---> CHECK:
SELECT 
	*
FROM 
	cyclistic_data





---> Finding duplicates in ride_id since this should be unique.
---> Found 209 duplicates in ride_id.
SELECT 
	ride_id,
	COUNT(ride_id) 
FROM 
	cyclistic_data
GROUP BY 
	ride_id  
HAVING 
	COUNT(ride_id) > 1 
	
----> Deleted duplicates.
CREATE TABLE goodcopy (LIKE cyclistic_data)

INSERT INTO goodcopy
(
ride_id,
rideable_type,
started_at,
ended_at,
start_station_name,
start_station_id,
end_station_name,
end_station_id,
start_lat,
start_lng,
end_lat,
end_lng,
member_casual
)
SELECT 
	DISTINCT ON (ride_id) ride_id,
	rideable_type,
	started_at,
	ended_at,
	start_station_name,
	start_station_id,
	end_station_name,
	end_station_id,
	start_lat,
	start_lng,
	end_lat,
	end_lng,
	member_casual
FROM cyclistic_data

---> CHECK:
SELECT 
	ride_id, 
	COUNT(ride_id) 
FROM 
	goodcopy
GROUP BY 
	ride_id  
HAVING 
	COUNT(ride_id) > 1 





---> ADDED COLUMN: MONTH
ALTER TABLE goodcopy
ADD COLUMN month_of_trip VARCHAR

UPDATE goodcopy
SET month_of_trip = TO_CHAR(started_at, 'Month') 

---> ADDED COLUMN: DOW (Days of Week)
ALTER TABLE goodcopy
ADD COLUMN DOW VARCHAR

UPDATE goodcopy
SET DOW = TO_CHAR(started_at, 'Day') 

---> ADDED COLUMN: HOUR STARTED
ALTER TABLE goodcopy
ADD COLUMN hour_started VARCHAR

UPDATE goodcopy
SET hour_started = TO_CHAR(started_at, 'HH24') 

---> ADDED COLUMN: TRIP DURATION
ALTER TABLE goodcopy
ADD COLUMN trip_duration INTERVAL

UPDATE goodcopy
SET trip_duration = (ended_at - started_at)
WHERE (ended_at - started_at) BETWEEN '00:01:00' AND '24:00:00' -- Trips that are less than 1min are not to be included as they are considered "tests" by employees or they are potentially false starts or users trying to re-check a bike to ensure it was secure; Trips over 24hrs are considered lost or stolen.

---> CHECK:
SELECT 
	*
FROM 
	goodcopy





---> Dedecting NULLs in the dataset.
---> Result: Zero nulls, except --> start_station_name (600,479 nulls), start_station_id (600,586 nulls), end_station_name (646,470 nulls), end_station_id (646,547 nulls), end_lat (4,830 nulls), end_lng (4,830 nulls), trip_duration (85,757 nulls).
SELECT
	SUM(CASE
	   	WHEN ride_id IS NULL THEN 1 ELSE 0
	   	END) AS ride_id_nulls,
	SUM(CASE
	   	WHEN rideable_type IS NULL THEN 1 ELSE 0
	   	END) AS rideable_type_nulls,
	SUM(CASE
	   	WHEN started_at IS NULL THEN 1 ELSE 0
	   	END) AS started_at_nulls,
	SUM(CASE
	   	WHEN ended_at IS NULL THEN 1 ELSE 0
	   	END) AS ended_at_nulls,
	SUM(CASE
	   	WHEN start_station_name IS NULL THEN 1 ELSE 0
	   	END) AS start_station_name_nulls,
	SUM(CASE
	   	WHEN start_station_id IS NULL THEN 1 ELSE 0
	   	END) AS start_station_id_nulls,
	SUM(CASE
	   	WHEN end_station_name IS NULL THEN 1 ELSE 0
	   	END) AS end_station_name_nulls,
	SUM(CASE
	   	WHEN end_station_id IS NULL THEN 1 ELSE 0
	   	END) AS end_station_id_nulls,
	SUM(CASE
	   	WHEN start_lat IS NULL THEN 1 ELSE 0
	   	END) AS start_lat_nulls,
	SUM(CASE
	   	WHEN start_lng IS NULL THEN 1 ELSE 0
	   	END) AS start_lng_nulls,
	SUM(CASE
	   	WHEN end_lat IS NULL THEN 1 ELSE 0
	   	END) AS end_lat_nulls,
	SUM(CASE
	   	WHEN end_lng IS NULL THEN 1 ELSE 0
	   	END) AS end_lng_nulls,
	SUM(CASE
	   	WHEN member_casual IS NULL THEN 1 ELSE 0
	   	END) AS member_casual_nulls,
	SUM(CASE
	   	WHEN trip_duration IS NULL THEN 1 ELSE 0
	   	END) AS trip_duration_nulls
FROM 
	goodcopy





---> Used filters to create a new table for clean data.
---> Removed NULLs; Used TRIM for string columns; Removed start_station_id and end_station_id as they won't be needed.
---> Filtered out trips less than 60sec and more than 24hrs:
-- *** Information about the data states that trips below 60sec should be removed due to potentially false starts or users trying to re-dock a bike to ensure it was secure; Also due to staff doing checks on the bike.
-- *** Information about the data also states that trips over 24hrs are considered lost or stolen.
CREATE TABLE trip_data_clean AS
SELECT 
	TRIM(BOTH FROM ride_id) AS ride_id,
	TRIM(BOTH FROM member_casual) AS member_casual,
	TRIM(BOTH FROM rideable_type) AS rideable_type,
	TRIM(BOTH FROM start_station_name) AS start_station_name,
	TRIM(BOTH FROM end_station_name) AS end_station_name,
	started_at,
	ended_at,
	start_lat,
	start_lng,
	end_lat,
	end_lng,
	month_of_trip,
	DOW,
	hour_started,
	trip_duration
FROM
	goodcopy
WHERE
	start_station_name IS NOT NULL
	AND start_station_id IS NOT NULL
	AND end_station_name IS NOT NULL
	AND end_station_id IS NOT NULL
	AND end_lat IS NOT NULL
	AND end_lng IS NOT NULL
	AND trip_duration IS NOT NULL
	
---> CHECK: All duplicates are removed.
SELECT 
	ride_id, 
	COUNT(ride_id) 
FROM 
	trip_data_clean
GROUP BY 
	ride_id  
HAVING COUNT 
	(ride_id) > 1 
	
---> CHECK: All NULLs are removed.
SELECT	
	SUM(CASE
		WHEN ride_id IS NULL THEN 1 ELSE 0 
	END) AS ride_id_nulls,
	SUM(CASE 
		WHEN rideable_type IS NULL THEN 1 ELSE 0 
	END) AS rideable_type_nulls,
	SUM(CASE 
		WHEN started_at IS NULL THEN 1 ELSE 0 
	END) AS started_at_nulls,
	SUM(CASE
	   	WHEN ended_at IS NULL THEN 1 ELSE 0
	   	END) AS ended_at_nulls,
	SUM(CASE
	   	WHEN start_station_name IS NULL THEN 1 ELSE 0
	   	END) AS start_station_name_nulls,
	SUM(CASE
	   	WHEN end_station_name IS NULL THEN 1 ELSE 0
	   	END) AS end_station_name_nulls,
	SUM(CASE
	   	WHEN start_lat IS NULL THEN 1 ELSE 0
	   	END) AS start_lat_nulls,
	SUM(CASE
	   	WHEN start_lng IS NULL THEN 1 ELSE 0
	   	END) AS start_lng_nulls,
	SUM(CASE
	   	WHEN end_lat IS NULL THEN 1 ELSE 0
	   	END) AS end_lat_nulls,
	SUM(CASE
	   	WHEN end_lng IS NULL THEN 1 ELSE 0
	   	END) AS end_lng_nulls,
	SUM(CASE
	   	WHEN member_casual IS NULL THEN 1 ELSE 0
	   	END) AS member_casual_nulls,
	SUM(CASE
	   	WHEN trip_duration IS NULL THEN 1 ELSE 0
	   	END) AS trip_duration_nulls
FROM 
	trip_data_clean





---------- ###### MEMBER VS CASUAL ###### ----------



---> Data used for this process:
SELECT
	ride_id,
	rideable_type,
	started_at,
	ended_at,
	start_station_name,
	end_station_name,
	start_lat,
	start_lng,
	end_lat,
	end_lng,
	member_casual,
	month_of_trip,
	DOW,
	hour_started,
	trip_duration
FROM 
	trip_data_clean
ORDER BY 
	started_at





---> Looking at OVERALL TRIP COUNT between members and casuals.
SELECT
	member_casual,
	COUNT(*)
FROM 
	trip_data_clean
WHERE
	member_casual = 'member'
	OR member_casual = 'casual'
GROUP BY 
	member_casual





---> Looking at which MONTHS have the highest TRIP COUNT for members and casual riders. 
SELECT 
	member_casual, 
	COUNT(member_casual) AS trip_count, 
	month_of_trip
FROM 
	trip_data_clean
GROUP BY 
	member_casual, 
	month_of_trip
ORDER BY 
	member_casual,
	COUNT(member_casual) DESC





---> Looking at which DAY of the week has the highest trip COUNT for members and casual riders. 
SELECT 
	member_casual, 
	COUNT(member_casual) AS trip_count, 
	dow
FROM 
	trip_data_clean
GROUP BY 
	member_casual, 
	dow
ORDER BY 
	member_casual, 
	COUNT(member_casual) DESC
	
	
	
	
	
---> Looking at what HOUR trips happen the most for members and casuals.
SELECT 
	member_casual,
	hour_started,
	COUNT(hour_started)
FROM 
	trip_data_clean
GROUP BY 
	member_casual,
	hour_started
ORDER BY 
	member_casual,
	COUNT(hour_started) DESC
	
	
	
	
	
---> Looking at the AVERAGE TRIP DURATION and MEDIAN TRIP DURATION per Days of the Week.
SELECT
	member_casual,
	dow,
	AVG(trip_duration) AS avg_trip_duration,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY trip_duration) AS meadian_trip_duration -- Median trip duration
FROM
	trip_data_clean
GROUP BY 
	member_casual,
	dow
	
	
---> Looking at the OVERALL AVERAGE TIRP DURATION 
SELECT
	member_casual,
	AVG(trip_duration) AS avg_trip_duration
FROM
	trip_data_clean
GROUP BY 
	member_casual





---> Looking at the TYPE OF BIKES that were USED the most among members and casuals. 
SELECT
	rideable_type,
	member_casual,
	COUNT(ride_id) AS count_ride
FROM
	trip_data_clean
GROUP BY 
	rideable_type, member_casual


	
	
	
---> Looking at which stations are most popular.
SELECT 
	start_station_name,
	COUNT(start_station_name)
FROM 
	trip_data_clean
GROUP BY
	start_station_name
ORDER BY
	COUNT(start_station_name) DESC


	
---------------------------------------------------------------------------------------------------------------
---> Notice the following outliers in the station name column: '351', 'DIVVY CASSETTE REPAIR MOBILE STATION' and 'HUBBARD ST BIKE CHECKING (LBS-WH-TEST)'; Removing outliers.
---> Checked how many outliers there are. Results show 9 rows with outliers.
SELECT 
	start_station_name,
	COUNT(start_station_name)
FROM 
	trip_data_clean
WHERE 
	start_station_name = '351'
	OR start_station_name = 'DIVVY CASSETTE REPAIR MOBILE STATION'
	OR start_station_name = 'HUBBARD ST BIKE CHECKING (LBS-WH-TEST)'
GROUP BY
	start_station_name

---> CHECK: Double checking total rows before removing outliers.
---> Row count: 4,432,926
SELECT 
	COUNT(*)
FROM 
	trip_data_clean

---> Removing outliers.
DELETE FROM trip_data_clean
WHERE 
	start_station_name ='351'
	OR start_station_name = 'DIVVY CASSETTE REPAIR MOBILE STATION'
	OR start_station_name = 'HUBBARD ST BIKE CHECKING (LBS-WH-TEST)'

---> CHECK: Total rows after removing outliers; Should be minus 9.
---> Row count: 4,432,917
SELECT 
	COUNT(*)
FROM 
	trip_data_clean
---------------------------------------------------------------------------------------------------------------



---> Looking at the highest START STATION used by MEMBERS.
SELECT 
	start_station_name,
	COUNT(start_station_name) AS total_count
FROM 
	trip_data_clean
WHERE 
	member_casual = 'member'
GROUP BY
	start_station_name
ORDER BY
	COUNT(start_station_name) DESC


---> Looking at the highest END STATION used by MEMBERS.
SELECT 
	end_station_name,
	COUNT(end_station_name) AS total_count
FROM 
	trip_data_clean
WHERE 
	member_casual = 'member'
GROUP BY
	end_station_name
ORDER BY
	COUNT(end_station_name) DESC


---> Looking at the highest START STATION used by CASUALS.
SELECT 
	start_station_name,
	COUNT(start_station_name) AS total_count
FROM 
	trip_data_clean
WHERE 
	member_casual = 'casual'
GROUP BY
	start_station_name
ORDER BY
	COUNT(start_station_name) DESC
	
	
---> Looking at the highest END STATION used by CASUALS.
SELECT 
	DISTINCT end_station_name,
	COUNT(end_station_name) AS total_count
FROM 
	trip_data_clean
WHERE 
	member_casual = 'casual'
GROUP BY
	end_station_name
ORDER BY
	COUNT(end_station_name) DESC
	




---> Looking at MEMBER top 10 trip count: start station, start latitude, start longitude
SELECT
	start_station_name,
	start_lat,
	start_lng,
	COUNT(*)
FROM 
	trip_data_clean
WHERE
	member_casual = 'member'
GROUP BY
	start_station_name,
	start_lat,
	start_lng
HAVING
	COUNT(*) > '10000'
ORDER BY 
	COUNT(*) DESC
LIMIT 10
	

---> Looking at MEMBER top 10 trip count: end station, end latitude, end longitude
SELECT
	end_station_name,
	end_lat,
	end_lng,
	COUNT(*)
FROM 
	trip_data_clean
WHERE
	member_casual = 'member'
GROUP BY
	end_station_name,
	end_lat,
	end_lng
HAVING
	COUNT(*) > '10000'
ORDER BY 
	COUNT(*) DESC
LIMIT 10


---> Looking at CASUAL top 10 trip count: start station, start latitude, start longitude
SELECT
	start_station_name,
	start_lat,
	start_lng,
	COUNT(*)
FROM 
	trip_data_clean
WHERE
	member_casual = 'casual'
GROUP BY
	start_station_name,
	start_lat,
	start_lng
HAVING
	COUNT(*) > '10000'
ORDER BY 
	COUNT(*) DESC
LIMIT 10


---> Looking at CASUAL top 10 trip count: end station, end latitude, end longitude
SELECT
	end_station_name,
	end_lat,
	end_lng,
	COUNT(*)
FROM 
	trip_data_clean
WHERE
	member_casual = 'casual'
GROUP BY
	end_station_name,
	end_lat,
	end_lng
HAVING
	COUNT(*) > '10000'
ORDER BY 
	COUNT(*) DESC
LIMIT 10





---------- ###### CREATING VIEWS ###### ----------

---> Looking at OVERALL TRIP COUNT between members and casuals.
CREATE VIEW overall_trip_count AS
SELECT
	member_casual,
	COUNT(*)
FROM 
	trip_data_clean
WHERE
	member_casual = 'member'
	OR member_casual = 'casual'
GROUP BY 
	member_casual

---> Looking at which MONTHS have the highest TRIP COUNT for members and casual riders. 
CREATE VIEW trip_month_count AS
SELECT 
	member_casual, 
	COUNT(member_casual) AS trip_count, 
	month_of_trip
FROM 
	trip_data_clean
GROUP BY 
	member_casual, 
	month_of_trip

---> Looking at which DAY of the week has the highest trip COUNT for members and casual riders. 
CREATE VIEW trip_dow_count AS
SELECT 
	member_casual, 
	COUNT(member_casual) AS trip_count, 
	dow
FROM 
	trip_data_clean
GROUP BY 
	member_casual, 
	dow

---> Looking at what HOUR trips happen the most for members and casuals.
CREATE VIEW trip_hour_started_count AS
SELECT 
	member_casual,
	hour_started,
	COUNT(hour_started)
FROM 
	trip_data_clean
GROUP BY 
	member_casual,
	hour_started

---> Looking at the AVERAGE TRIP DURATION and MEDIAN TRIP DURATION per Days of the Week.
CREATE VIEW trip_duration_dow AS
SELECT
	member_casual,
	dow,
	AVG(trip_duration) AS avg_trip_duration,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY trip_duration) AS meadian_trip_duration -- Median trip duration
FROM
	trip_data_clean
GROUP BY 
	member_casual,
	dow

---> Looking at the TYPE OF BIKES that were USED the most among members and casuals. 
CREATE VIEW rideable_type AS
SELECT
	rideable_type,
	member_casual,
	COUNT(ride_id) AS count_ride
FROM
	trip_data_clean
GROUP BY 
	rideable_type, member_casual

---> Looking at the highest START STATION used by MEMBERS.
CREATE VIEW start_station_most_members AS
SELECT 
	start_station_name,
	COUNT(start_station_name) AS total_count
FROM 
	trip_data_clean
WHERE 
	member_casual = 'member'
GROUP BY
	start_station_name

---> Looking at the highest END STATION used by MEMBERS.
CREATE VIEW end_station_more_members AS
SELECT 
	end_station_name,
	COUNT(end_station_name) AS total_count
FROM 
	trip_data_clean
WHERE 
	member_casual = 'member'
GROUP BY
	end_station_name

---> Looking at the highest START STATION used by CASUALS.
CREATE VIEW start_station_most_casuals AS
SELECT 
	start_station_name,
	COUNT(start_station_name) AS total_count
FROM 
	trip_data_clean
WHERE 
	member_casual = 'casual'
GROUP BY
	start_station_name

---> Looking at the highest END STATION used by CASUALS.
CREATE VIEW end_station_most_casuals AS
SELECT 
	end_station_name,
	COUNT(end_station_name) AS total_count
FROM 
	trip_data_clean
WHERE 
	member_casual = 'casual'
GROUP BY
	end_station_name

---> Looking at MEMBER top 10 trip count: start station, start latitude, start longitude
CREATE VIEW start_station_members AS
SELECT
	start_station_name,
	start_lat,
	start_lng,
	COUNT(*)
FROM 
	trip_data_clean
WHERE
	member_casual = 'member'
GROUP BY
	start_station_name,
	start_lat,
	start_lng
HAVING
	COUNT(*) > '10000'
	
---> Looking at MEMBER top 10 trip count: end station, end latitude, end longitude
CREATE VIEW end_station_members AS
SELECT
	end_station_name,
	end_lat,
	end_lng,
	COUNT(*)
FROM 
	trip_data_clean
WHERE
	member_casual = 'member'
GROUP BY
	end_station_name,
	end_lat,
	end_lng
HAVING
	COUNT(*) > '10000'
	
---> Looking at CASUAL top 10 trip count: start station, start latitude, start longitude
CREATE VIEW start_station_casual AS
SELECT
	start_station_name,
	start_lat,
	start_lng,
	COUNT(*)
FROM 
	trip_data_clean
WHERE
	member_casual = 'casual'
GROUP BY
	start_station_name,
	start_lat,
	start_lng
HAVING
	COUNT(*) > '10000'

---> Looking at CASUAL top 10 trip count: end station, end latitude, end longitude
CREATE VIEW end_station_casual AS
SELECT
	end_station_name,
	end_lat,
	end_lng,
	COUNT(*)
FROM 
	trip_data_clean
WHERE
	member_casual = 'casual'
GROUP BY
	end_station_name,
	end_lat,
	end_lng
HAVING
	COUNT(*) > '10000'



