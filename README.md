# Uber Fares — Demand \& Fare Analysis

## 

### **1 Business Question**



* **How does ride demand vary by time and day, and is higher demand associated with higher average fares?** 



* This project investigates ride demand patterns across different hours and days of the week and examines 

whether periods of higher demand are associated with higher average fares.

## 

## **2 Dataset**



* \[Uber Fares Dataset (Kaggle)](https://www.kaggle.com/datasets/yasserh/uber-fares-dataset)


The dataset contains approximately 200,000 ride records with information about:



* fare amount;
* pickup datetime;
* pickup and dropoff coordinates;
* passenger count.

## 

### **3 Tools used**



* PostgreSQL + pgAdmin





### **4 Analytical Approach**



The analysis follows a step-by-step investigation.



* ###### **Data Quality**



The dataset contains 200,000 records. I identified 732 suspicious rows, representing approximately 0.37% of the dataset.



These records contained either non-positive fare amounts and invalid passenger counts.



The suspicious records were excluded from the main analysis using validation filters rather than being deleted from the original dataset.



* ###### **Demand by Hour**



I analyzed the number of rides and average fare for each hour of the day.



The highest ride volume occurs during the evening.



The period from 18:00 to 22:00 consistently shows high demand, with 19:00 being the busiest individual hour.

## 

* ###### **Peak vs. Off-Peak**

## 

To investigate this question, I compared rides during the 18:00–22:00 peak period with rides during all other hours.



**Period	        **Rides	        Average Fare**

Peak	             58,693	          $10.91

Off-peak           140,575	          $11.56



The results show that peak-demand rides actually had a lower average fare than off-peak rides in this dataset.



This suggests that ride volume and average fare do not move together in a simple way.



Importantly, this analysis describes an observed relationship in the dataset and does not establish that demand causes fares to increase or decrease.





* ###### **Demand Patterns by Day**



Then i examined whether the relationship between demand and fare was consistent across different days of the week.



Friday had the highest overall ride volume, with 30,775 valid rides.



However, Friday's peak-period average fare was $10.92, compared with $11.67 during off-peak hours.



Sunday showed a different pattern: its peak and off-peak average fares were much closer, at $11.66 and $11.80, respectively.



This shows that the relationship between ride volume and average fare can vary depending on the day.



## 

### **5 Key findings**



###### **1. Data quality**



Only 0.37% of records were classified as suspicious based on the validation rules used in this analysis.



###### **2. Demand is concentrated in the evening**



The 18:00–22:00 period has consistently high ride volume, with 19:00 being the busiest individual hour.



###### **3. Higher demand does not automatically mean higher fares**



Peak-period rides had an average fare of $10.91, compared with $11.56 during off-peak hours.



###### **4. The busiest day is not the highest-fare day**



Friday had the highest ride volume, but its average fares were not the highest.



###### **5. The relationship varies by day**



Most days showed lower average fares during peak hours, while Sunday showed only a small difference between peak and off-peak fares.



### 

### **6 Analytical Conclusion** 



The analysis suggests that ride demand and average fare are not directly aligned in a simple way within this dataset.



The busiest hours and days do not consistently correspond to the highest average fares. This indicates that ride volume alone is not sufficient to explain fare differences.



Further analysis would be required to investigate other factors that may contribute to fare variation.



### **7 SQL Techniques Used**



* COUNT()
* AVG()
* ROUND()
* GROUP BY
* CASE
* FILTER
* EXTRACT()
* Common Table Expressions (CTEs)
* Window functions
* Data quality validation
* Date and time analysis
* Aggregation and segmentation



## 

### **8 How to reproduce**



1 Download the Uber Fares Dataset from Kaggle.

2 Create a PostgreSQL database.

3 Create the uber\_fares table using the SQL script.

4 Import the CSV dataset.

5 Run the queries in queries.sql.

6 Review the resulting tables and findings.

## 

### **9 What I'd explore next**



* Analyze fare patterns by pickup location.
* Investigate weekday vs. weekend differences in more detail.
* Examine the relationship between trip distance and fare.
* Build a Power BI dashboard to visualize demand and fare patterns.

