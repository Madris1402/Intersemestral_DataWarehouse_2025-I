use dwhsales;
show tables;

desc fact_sales;

select * from fact_sales;

select * from dim_geography;
select * from dim_product;
select * from dim_time where time_id = 1527;

select count(*), sum(units_sold), sum(profit) from fact_sales;

select distinct year from dim_time order by 1;

-- drill down
select year, day_name, count(*), sum(units_sold), sum(profit)
from fact_sales f
join dim_time t on f.dim_time_id = t.time_id
group by year, day_name
order by 1, 2;

-- slice
select year, is_weekend, count(*), sum(units_sold), sum(profit)
from fact_sales f
join dim_time t on f.dim_time_id = t.time_id
group by year, is_weekend
order by 1, 2;

-- dice
select year, is_weekend, count(*), sum(units_sold), sum(profit)
from fact_sales f
join dim_time t on f.dim_time_id = t.time_id
where month between 1 and 6
group by year, is_weekend
order by 1, 2;