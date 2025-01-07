-- Madrigal Urencio Ricardo
use dwhsales;

-- Ganancia total por categoria y año
select if(grouping(dp.category), 'All Categories', dp.category) category, if(grouping(dt.year), 'All Years', dt.year) year, count(*) as num_sales, sum(fs.profit) as total_profit
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
join dim_product dp on(fs.dim_product_id = dp.product_id)
group by dp.category, dt.year with rollup;
-- Madrigal Urencio Ricardo
-- 31 rows

-- Número de transacciones en fines de semana
select dt.is_weekend, count(*) as num_sales
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
where dt.is_weekend = 'True'
group by dt.is_weekend;
-- Madrigal Urencio Ricardo
-- 1 row

-- Resumen por genero, mes y continente
select if(grouping(dc.gender), 'All Genders', dc.gender) gender, if(grouping(dt.month), 'All Months', dt.month) month, if(grouping(dg.continent), 'All Continents', dg.continent) continent, count(*) as num_sales, sum(fs.profit) as total_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_customer dc on (fs.dim_customer_id = dc.customer_id)
group by dt.month, dg.continent, dc.gender with rollup;
-- Madrigal Urencio Ricardo
-- 301 rows