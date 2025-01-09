-- Uso de Rollups
-- -- 07 - 01 - 2025
use dwhsales;

-- -- Vista de ventas por año
select dt.year, count(*) as num_sales, sum(fs.profit) as total_profit, max(fs.profit) as max_profit, min(fs.profit) as min_profit,
avg(fs.profit) as promedio_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
group by dt.year with rollup;

-- -- -- Por año y mes
select dt.year, dt.month, count(*) as num_sales, sum(fs.profit) as total_profit, max(fs.profit) as max_profit, min(fs.profit) as min_profit,
avg(fs.profit) as promedio_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
group by dt.year, dt.month with rollup;

-- -- -- Para el año 2021
select dt.year, dt.month, count(*) as num_sales, sum(fs.profit) as total_profit, max(fs.profit) as max_profit, min(fs.profit) as min_profit,
avg(fs.profit) as promedio_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
where dt.year = 2021
group by dt.year, dt.month with rollup;

-- --  -- Por año, mes y pais
select dt.year, dt.month, dg.country_name, count(*) as num_sales, sum(fs.profit) as total_profit, max(fs.profit) as max_profit, min(fs.profit) as min_profit,
avg(fs.profit) as promedio_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
group by dt.year, dt.month, dg.country_name with rollup;

-- -- -- Por año país, categoría y género
select dt.year, dg.country_name, dp.category, dc.gender, count(*) as num_sales, sum(fs.profit) as total_profit, max(fs.profit) as max_profit, min(fs.profit) as min_profit,
avg(fs.profit) as promedio_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_product dp on(fs.dim_product_id = dp.product_id)
join dim_customer dc on (fs.dim_customer_id = dc.customer_id)
group by dt.year, dg.country_name, dp.category, dc.gender with rollup;

-- -- -- -- Por año y país (usando grouping)
select dt.year, dg.country_name, count(*) as num_sales, sum(fs.profit) as total_profit, max(fs.profit) as max_profit, min(fs.profit) as min_profit,
avg(fs.profit) as promedio_profit, sum(units_sold) as total_units_sold,
grouping(dt.year), grouping(dt.year, dg.country_name)
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
group by dt.year, dg.country_name with rollup;

-- -- -- -- Por año y país (usando having y grouping)
select dt.year, dg.country_name, count(*) as num_sales, sum(fs.profit) as total_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
group by dt.year, dg.country_name with rollup
having grouping(dt.year, dg.country_name) = 1;

-- -- -- -- Por año país, categoría y género (usando having y grouping)
select dt.year, dg.country_name, dp.category, dc.gender, count(*) as num_sales, sum(fs.profit) as total_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_product dp on(fs.dim_product_id = dp.product_id)
join dim_customer dc on (fs.dim_customer_id = dc.customer_id)
group by dt.year, dg.country_name, dp.category, dc.gender with rollup
having grouping(dt.year, dg.country_name) <> 1;

-- -- -- Por año país y categoría (Añadierndo mensajes para las jerarquías usando if grouping)
select if(grouping(dt.year), 'All Years', dt.year) year, if(grouping(dg.country_name), 'All Countries', dg.country_name) country, 
if(grouping(dp.category), 'All Categories', dp.category) category, count(*) as num_sales, sum(fs.profit) as total_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_product dp on(fs.dim_product_id = dp.product_id)
group by dt.year, dg.country_name, dp.category with rollup;