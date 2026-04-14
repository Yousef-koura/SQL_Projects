with cte as(
SELECT * FROM bike_share_yr_0
union 
SELECT * FROM bike_share_yr_1)

SELECT 
dteday,
a.yr,
season, 
weekday, 
hr, 
rider_type, 
riders, 
price, 
cogs, 
round(riders*price,2) as revenue,
round(round(riders*price,2) - round(cogs*riders,2)) as profit

FROM cte a
left join cost_table b
on a.yr = b.yr
