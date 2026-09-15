# Uber Fares — SQL Analysis

## 

## Why I built this



I work as a Safety Investigation Specialist at Uber, where I use SQL daily to
investigate operational data and identify patterns. I wanted to apply the same
data-driven, investigative approach to a public dataset to demonstrate my SQL
and analytical skills outside of my day-to-day work.

## 

## Dataset



\[Uber Fares Dataset (Kaggle)](https://www.kaggle.com/datasets/yasserh/uber-fares-dataset)
— \~200,000 ride records with fare amount, pickup datetime, pickup/dropoff
coordinates, and passenger count.

## 

## Tools used



* PostgreSQL + pgAdmin

## 

## Questions I investigated



1. What does the overall fare and ride volume look like, and is the data clean?
2. Does passenger count affect the average fare?
3. What are the peak hours and days for ride volume?
4. Is there a trend in average fare over time?
5. Which hours have the highest ride demand?

## 

## Key findings



\- \*\*Dataset overview:\*\* The dataset contains \*\*200,000 ride records\*\* with an

&#x20; average fare of \*\*$11.36\*\*. Fare amounts range from \*\*-$52.00 to $499.00\*\*,

&#x20; indicating that some records may contain invalid fare values.



\- \*\*Data quality:\*\* Found \*\*732 suspicious rows\*\* with invalid fare amounts or

&#x20; passenger counts. These rows should be investigated before using the data

&#x20; for final analysis.



\- \*\*Peak hours:\*\* Ride demand is highest during the evening, with \*\*19:00\*\*

&#x20; ranking first with \*\*12,605 rides\*\*. The period from \*\*18:00 to 22:00\*\*

&#x20; consistently shows high ride volume, while average fares during these hours

&#x20; remain around \*\*$10.56–$11.31\*\*.



\- \*\*Passenger count vs. fare:\*\* Average fare does not increase consistently

&#x20; with the number of passengers. Rides with 6 passengers had the highest

&#x20; average fare at \*\*$12.16\*\*, while rides with 5 passengers had a lower average

&#x20; fare of \*\*$11.20\*\*. This suggests that passenger count alone does not

&#x20; strongly determine the fare.



\- \*\*Day of week:\*\* Friday had the highest ride volume with \*\*30,880 rides\*\*,

&#x20; while Monday had the lowest with \*\*25,243 rides\*\*. Sunday had the highest

&#x20; average fare at \*\*$11.76\*\*, showing that the busiest day does not necessarily

&#x20; have the highest average fare.



\- \*\*Monthly fare trend:\*\* Average fares show a clear upward trend over the

&#x20; analyzed period. The average fare increased from \*\*$9.58 in January 2009\*\*

&#x20; to \*\*$13.58 in June 2015\*\*, although the trend was not consistent every

&#x20; month. The highest monthly average fare was \*\*$13.60 in May 2015\*\*.



### Conclusion



This analysis demonstrates how SQL can be used to investigate ride-hailing

data, identify data quality issues, analyze demand patterns, and track trends

over time using aggregation, CTEs, and window functions.



The project highlights practical analytical skills that are directly applicable

to operational investigations and business intelligence work.

## 

## How to reproduce



1. Download the dataset from Kaggle (link above).
2. In pgAdmin, create a database (e.g. `uber\\\\\\\_analysis`), open the Query Tool,
and run the `CREATE TABLE` statement from `queries.sql`.
3. Right-click the new `uber\\\\\\\_fares` table → **Import/Export Data...** →
select the CSV file, set format to CSV, header = Yes → Import.
4. Run the queries in `queries.sql` in order — each one is commented to explain
what it's checking and why.

## 

## What I'd explore next



* Fare patterns by pickup location (would require geocoding the lat/long pairs).
* Comparing weekday vs. weekend pricing more rigorously with a statistical test.
* Building a simple Power BI dashboard on top of these queries.

