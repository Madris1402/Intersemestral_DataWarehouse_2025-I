-- Elementos del Data Warehouse
-- 06 - 01 - 2025

use dwhsales;
-- -- Por año y pos mes

select dt.year, dt.month, count(*) as num_sales, sum(fs.profit) as total_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
group by dt.year, dt.month
order by dt.year;

-- -- Por año y país
select dt.year, dg.country_name, count(*) as num_sales, sum(fs.profit) as total_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
group by dt.year, dg.country_name
order by dt.year, dg.country_name;

-- -- Por año país y categoría
select dt.year, dg.country_name, dp.category, count(*) as num_sales, sum(fs.profit) as total_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_product dp on(fs.dim_product_id = dp.product_id)
group by dt.year, dg.country_name, dp.category
order by dt.year, dg.country_name;

-- -- Por año país, categoría y género
select dt.year, dg.country_name, dp.category, dc.gender, count(*) as num_sales, sum(fs.profit) as total_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_product dp on(fs.dim_product_id = dp.product_id)
join dim_customer dc on (fs.dim_customer_id = dc.customer_id)
group by dt.year, dg.country_name, dp.category, dc.gender
order by dt.year, dg.country_name;

-- -- Por año
select dt.year, count(*) as num_sales, sum(fs.profit) as total_profit, sum(units_sold) as total_units_sold, max(fs.profit) as max_profit, min(fs.profit) as min_profit,
avg(fs.profit) as promedio_profit
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
group by dt.year
order by dt.year;

-- -- Vista sin agregaciones
select count(*) as num_sales, sum(fs.profit) as total_profit, sum(units_sold) as total_units_sold, max(fs.profit) as max_profit, min(fs.profit) as min_profit,
avg(fs.profit) as promedio_profit
from fact_sales fs;