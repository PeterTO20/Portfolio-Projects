# CYCLISTIC CASE STUDY




### –ask–



### INTRO

You are a junior data analyst working in the marketing analyst team at Cyclistic, a bike-share company in Chicago. The company categorizes its customers as causal (single-ride or day-pass) and annual members. The director of marketing believes the company’s future success depends on maximizing the number of annual memberships. Therefore, your team wants to understand how casual riders and annual members use Cyclistic bikes differently. From these insights, your team will design a new marketing strategy to convert casual riders into annual members. But first, Cyclistic executives must approve your recommendations, so they must be backed up with compelling data insights and professional data visualizations.


### PROBLEM

The problem is to convert casual riders to annual members by finding out how annual members and casual riders use our bikes differently. This insight will assist our stakeholders on a marketing campaign to increase annual members.


TASK

How do annual members and casual riders use Cyclistic bikes differently?





–prepare–



ABOUT THE DATA

The data was taken from the company’s website which is a public database of  historical trip data that is available to use for analysis. The data represents every trip taken from November 1, 2020 to October 31, 2021. The data is organized into 12 monthly CSV files which represent the most recent data available. Each dataset has a consistent header name across 13 columns, which includes a ride_id column that is unique. 

This data helps us answer our question by identifying casual riders and members with the date, time, duration, bike type, and stations used during their bike trip. This should help us identify trends and gain insight on how casual riders and members use our bikes differently. 

Data License Agreement and datasets used can be found here.


DATA LIMITATIONS

Data-privacy issues prohibit us from using riders’ personally identifiable information. This means that we won’t be able to connect pass purchases to credit card numbers to determine if casual riders live in the Cyclistic service area or if they have purchased multiple single passes.





–process–



TOOLS USED

We will be using PostgreSQL to prepare and clean the data due to the large amount of data involved, and we’ll also be using Tableau for the data visualization portion to showcase our results.


PROBLEMS WITH THE DATA

There are duplicates found in the data, especially in the ride_id column, which should be a unique column. 
There are NULLs throughout the station names, station ids, and latitude/longitude columns.
There are some outliers in the station name columns that are not actual stations. 
The data type for columns start_station_id and end_station_id cannot be INT due to the IDs being integer for the year 2020 data and changes to have text in 2021.
Information about the data states that trips that are under 60 seconds and over 24 hours have been removed, however, these are still found within the data:
Trips below 60 seconds are considered potentially false starts or users trying to re-dock a bike to ensure it was secure; Also due to staff doing checks on the bike; More information here.
Trips over 24hours are considered lost or stolen; More information here.
There are trip durations with negative values. This may suggest that the data collected may have been mixed when inputted into  the started_at and ended_at column.


SOLUTIONS TO THE PROBLEM – CLEANING THE DATA

These problems have been filtered out and have been inserted into a new table for accurate and consistent queries. The number of rows went from 5,378,834 to 4,432,917 during this process; about 18% of the data. After filtering out the data we still have enough data to use for a thorough analysis. The data type for the station IDs have been inputted as VARCHAR so the data can be queried. We also used TRIM to remove any blank spaces in our data.

Results include:
ride_id (209 duplicates),
start_station_name (600,479 nulls),
start_station_id (600,586 nulls),
end_station_name (646,470 nulls),
end_station_id (646,547 nulls),
end_lat (4,830 nulls),
end_lng (4,830 nulls),
trip_duration [under 60sec and over 24hrs] (85,757 nulls).


VERIFICATION OF CLEAN DATA 

We ensured the clean data is verified by conducting queries to check that all the problems are removed; Duplicates, NULLs, station name outliers, invalid trip_durations. 





–analize–



Overall Trip Count:

Over the past year, we can see that the total trips made by members and casual riders are almost even between the two types of ridership
Members making ~2.4 million trips (55%)
Casual riders making ~2.0 million trips (45%)

This suggests to us that there is opportunity to convert casual riders into annual members based on the volume of trips.


Month Trip Count:

From a monthly perspective, we identified that trips made by casual riders and members peak in the summer months between June and August:
There are more trips by casual riders than members in July (Casual = 365k, Members = 317k).
There are roughly the same amount of trips between casual riders and members in June and August.
Overall ridership steadily drops in September and then gradually increases in March.
There are significantly less casual riders than members in the fall, winter, and spring months (September to May).

This suggests that the more trips are made during warmer months and the best time to target casual riders is in the months where the ridership is highest, which is in the summer months of June, July, and August.


Day of the Week Trip Count:

From a weekly perspective, we identified:
Casual riders have significantly more trips on the weekend compared to the weekday 
Members have more trips on the weekday compared to the weekend
Casual riders make up the majority of weekend trips
Members make up majority of the weekday trips

This shows us that members are using our bikes consistently during the weekday while a vast majority of casual riders use our bikes on the weekend. This suggests that the best time to target casual riders are on the weekends.


Hour Started Trip Count:

From an hourly perspective, we identified:
Members are far more likely to take trips during morning rush hour (5am - 8am) than casual riders
Casual riders have a gradual increase from 5am until its peak at 5pm
Both members and casual riders have the same peak hour at 5pm; However, members have 35% more trips (68k) than casual riders during this peak hour
Majority of trips made by casual riders (100k+)  are from 11am to 7pm 
Majority of trips made by members (100k+) are from 7am to 7pm

This shows us that members are using our bikes more throughout the day and suggests that the best time to target casual riders is from 11am to 7pm, when the majority of casual riders are using our bikes.


Average Trip Duration (Minutes) per Day of the Week:

This perspective shows that everyday of the week, on average, casual riders have longer trip durations than members. Additionally, we want to pinpoint that on weekends casual riders have significantly higher trip duration than compared to weekdays:
Saturday: 15min for members vs. 31min for casuals
Sunday: 15min for members vs. 33min for casuals.

Even though we see members have their highest trip duration on the weekend at 15min, that’s still not as high as the lowest trip duration for casual riders, which is on Thursday at 24min.

This suggests that everyday during the week, on average, casual riders spend more time on our bikes per trip than members. Even though members have more trips by volume, casual riders spend more time on our bikes per trip. This can be because casual riders use our bikes more for recreational purposes and members use it primarily for short-distance commutes.


Rideable Type Trip Count:

This perspective clearly shows that the most common rideable type among both members and casual riders is the classic bike.

This suggests that classic bikes are the best option for both members and casual riders.


Top Stations Used:

Based on the map visualization, we observed that:


Casual riders are more likely to start and end their trip by the coast of Lake Michigan:

By far, the most stations used by casual riders are:
Streeter Dr. & Grand Ave (start trips = 62k, end trips = 65k), and
Millennium Park (start trips = 31k, end trips = 33k) 


Members are more likely to start and end their trip in the inner city: 

The most stations used by members are:
Clark St. & Elm St. (start trips = 23k, end trips = 23k), and 
Wells St. & Concord Ln (start trips  = 22k, end trips  = 22k) 


Conclusion:

How do annual members and casual riders use Cyclistic bikes differently?

Similarities:
There is more rides in the warmer months, noticeably peaking at the summer months
Same peak hour during the day (afternoon rush hour @ 5pm)
Preference on classic bikes

Differences:
Members are much more likely to take trips in the winter months
Members have more trips on weekdays compared to weekends, and vice versa for casual riders
Members have significantly more trips during morning rush hour (5am to 8am)
Casual riders have significantly longer trip durations (Casual = 29min, Members = 14min)
Casual riders are more likely to start and end their trip by the coast of Lake Michigan; 
Members are more likely to start and end their trip in the inner city
Members are shown to have more routine in consistent trips. This is likely commuting to and from work, rather than recreation. Casual trips spike on the weekends suggesting recreational activities.





–share–


On tableau here.





–recommendations–



Top Recommendations:

Promote Lifestyle — There are lots of benefits for using our bikes, which includes health, environmental, financial, and benefits dealing with less traffic. In conjunction with these benefits, we can show riders many ways to use our bikes that aren't only recreational, but also for commuting to and from work, the gym, grocery store, a friend's house, and much more. It’s a lifestyle. We can use all this to our advantage within our campaign and make riders feel good about being members. We should market along the coast of Lake Michigan during the summer months and weekends, targeting when and where most of the casual riders are taking trips.


Free Trails — There are casual riders that might already be riding enough each week to make a membership ideal, so we need to nudge them to become members. We can promote free trial memberships that give casual riders the opportunity to explore the benefits of membership status in hopes for a full conversion. However, we need more personal data like credit card usage information to have a better understanding of how individuals use our bikes to target them better.


Promotions — Have promotions for casual riders during times where casual trips are lowest, for example in the morning hours, during weekdays, and colder months. This can give an incentive to casual riders to use our bikes more frequently and see the benefits of an annual membership. Additionally, we can show the amount of stations that are readily available in the city which means that there’s always a station nearby making it a convenience to use our bikes.


Price Increase — Increasing prices for casual trips (overall or during peak hours). Since we know that nearly half of the overall trips were taken by casual riders in the past year, we can increase prices to casual riders to give them a financial incentive to get an annual membership. This might not  be ideal for some casual riders, but those casual riders who likely have the most to gain from being members are those who ride in the peak hours or rush hour.
