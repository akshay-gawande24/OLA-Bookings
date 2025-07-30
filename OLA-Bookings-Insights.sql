-- Retrieve all successful bookings
select *
from 
   Bookings
where 
   Booking_Status='Success';

-- Retrieve Total Number of Successful Bookings
select 
     count(*) as total_Successful_bookings
from 
     bookings
where
     Booking_Status='Success';

-- Count of Unique Customers
Select 
     count(distinct Customer_ID) AS unique_customers 
FROM 
     bookings;

-- Most Popular Ride Category(Successful Rides)
select 
     Vehicle_Type,
     count(*) as total_Successful_rides
from 
     bookings
where
     Booking_status = "Success"
group by
     Vehicle_Type
order by
     total_Successful_rides desc;

-- Total Revenue
select 
     sum(Booking_Value) AS total_revenue 
from
     bookings;

-- Weekly revenue of Month
SELECT 
    CASE 
        WHEN DAY(Date) BETWEEN 1 AND 7 THEN 'Week 1'
        WHEN DAY(Date) BETWEEN 8 AND 14 THEN 'Week 2'
        WHEN DAY(Date) BETWEEN 15 AND 21 THEN 'Week 3'
        WHEN DAY(Date) BETWEEN 22 AND 31 THEN 'Week 4'
    END AS Week_of_Month,
    SUM(Booking_Value) AS Weekly_Revenue
FROM 
    bookings
WHERE 
    Booking_Status = 'Success'
GROUP BY 
    Week_of_Month
ORDER BY 
    Week_of_Month;

-- Different payment methods used?
Select 
     Distinct Payment_Method 
From
     Bookings;

-- Most Preferred Payment Methods for Successful Bookings
Select 
     Payment_Method, 
     count(*) as Total_usage
from 
     bookings 
where 
     Booking_status  = "Success"
group by 
     Payment_Method
order by 
     Total_usage Desc;

-- Top 5 Pickup Locations
Select
     Pickup_Location,
     count(*) As Pickup_count
from 
     Bookings
group by 
     Pickup_Location
order by 
     pickup_count Desc
Limit 5 ;

-- Distribution of Revenue by Vehicle type
select
     vehicle_Type,
     Sum(Booking_value) as Total_revenue
from
     bookings
group by
     vehicle_type
order by 
     total_revenue DESC; 

-- Average Rating Per Vehicle
SELECT 
     Vehicle_Type,
     ROUND(avg(Driver_Ratings)) as avg_driver_rating,
     ROUND(avg(Customer_Rating)) as avg_Customer_Rating
from 
     Bookings
where 
     Booking_Status = "Success"
group by 
     Vehicle_Type
order by
     avg_driver_rating Desc;
     
-- Construct a query to find the average customer rating and driver rating for each unique pickup location.
select
     Pickup_Location,
     ROUND(avg(customer_rating),2) AS avg_customer_rating,
     ROUND(avg(Driver_Ratings),2) AS avg_driver_ratings
from 
     bookings
group by 
     Pickup_Location;

-- Top pickup points with high cancellation
select
     Pickup_Location,
     count(*) as Pickup_points_with_high_cancellation
from 
    Bookings
where 
    Booking_Status in ("Canceled by Driver","Canceled by Customer")
group by 
    Pickup_Location
order by 
    Pickup_points_with_high_cancellation Desc ;

-- Bookings Per Day
select
     Date, dayname(Date) as dayname,
     count(*) as Total_bookings_per_day
from
     Bookings
group by
     Date
order by
     Total_bookings_per_day Desc;

-- Top 5 most frequent customers (most bookings)
Select
     Customer_ID ,
     Count(*) AS Total_Bookings
from 
     Bookings
group by 
     Customer_ID
order by 
     Total_Bookings Desc
limit 5;

-- Top 10 Most Frequent Pickup-Drop Pairs
Select 
     Pickup_Location, Drop_Location,
     Count(*) as total_rides
from 
     Bookings
Group by 
     Pickup_Location, Drop_Location
Order by 
     total_rides Desc
limit 10;

-- Average Driver Turnaround Time by Vehicle Type
Select
     Vehicle_Type,
     round(avg(TIME_TO_SEC(V_TAT_TIME)) / 60,2) AS  avg_driver_turnaround_time
 FROM 
     Bookings
 Where 
     V_TAT_TIME IS NOT NULL
 group by 
     Vehicle_Type
 order by 
     avg_driver_turnaround_time desc;
 
 -- How many bookings were canceled by Driver, and what were the key reasons behind them?
SELECT 
    Canceled_Rides_by_Driver AS Rides_canceled_by_Driver_Reason,
    COUNT(*) AS Count
FROM 
    bookings
WHERE 
    Canceled_Rides_by_Driver IS NOT NULL
GROUP BY 
    Canceled_Rides_by_Driver
  
UNION ALL
Select 
   'Total' as Reason,
    COUNT(*)
from
    Bookings
WHERE
    Canceled_Rides_by_Driver is NOT NULL; 
     
-- How many bookings were canceled by Customer, and what were the key reasons behind them?
 SELECT 
    Canceled_Rides_by_Customer as Canceled_Rides_by_Customer_Reason,
    COUNT(*) AS counts
FROM
    bookings
WHERE
    Canceled_Rides_by_Customer IS NOT NULL
GROUP BY
    Canceled_Rides_by_Customer
   
UNION ALL
SELECT 
    'Total' AS Reason,
     COUNT(*)
FROM 
    bookings
WHERE 
    Canceled_Rides_by_Customer IS NOT NULL;

 -- Are there specific routes (pickup to drop) that consistently generate higher revenues-sql query
 SELECT
	  Pickup_Location,
    Drop_Location,
	  ROUND(AVG(Ride_Distance), 2) AS avg_ride_distance,
    COUNT(*) AS count_of_ride,
    SUM(Booking_Value) AS total_revenue,
    ROUND(AVG(Booking_Value), 2) AS avg_revenue_per_ride
FROM
    bookings
WHERE
    Booking_Status = 'Success'
GROUP BY 
    Pickup_Location,
    Drop_Location
HAVING 
    total_revenue > 0
ORDER BY 
    total_revenue DESC
LIMIT 10;
