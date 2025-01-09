-- Anidar Funciones de Ventana
-- -- 09 - 01 - 2025
use dwhsales;

select dg.continent, dg.region, sum(fs.profit) as total_profit,
sum(sum(fs.profit)) over(partition by dg.continent) as cumulative_profit_by_continent
from fact_sales fs
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
group by dg.continent, dg.region
order by dg.continent, dg.region desc;

-- -- Vista
create or replace view cumulative_profit_by_continent as
select dg.continent, dg.region, sum(fs.profit) as total_profit,
sum(sum(fs.profit)) over(partition by dg.continent) as cumulative_profit_by_continent
from fact_sales fs
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
group by dg.continent, dg.region
order by dg.continent, dg.region desc;

show  full tables;

select * from cumulative_profit_by_continent;

-- -- Clausula With

with region_profit as (
select dg.continent, dg.region, sum(fs.profit) as total_profit
from fact_sales fs
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
group by dg.continent, dg.region
)

select continent, region, total_profit,
sum(total_profit) over(partition by continent order by total_profit) as cumulative_profit_by_continent
from region_profit;

-- -- Lead
select fs.sales_id, fs.profit, 
concat(dt.year, '-', lpad(dt.month, 2, '0'), '-', lpad(dt.day, 2, '0')) saletime,
lead(fs.profit, 2) over(order by dt.year, dt.month, dt.day) as next_profit
from fact_sales fs
join dim_time dt on(fs.dim_time_id = dt.time_id)
where dt.year = 2021;

-- -- -- Proyección del Mes siguiente
select 
concat(dt.year, '-', lpad(dt.month, 2, '0')) yearmonth, sum(fs.profit) monthly_profit,
lead(sum(fs.profit), 1) over(order by dt.year, dt.month) as next_month_profit
from fact_sales fs
join dim_time dt on(fs.dim_time_id = dt.time_id)
where dt.year = 2021
group by dt.year, dt.month
order by dt.year, dt.month;

-- -- Lag
select 
concat(dt.year, '-', lpad(dt.month, 2, '0')) yearmonth, sum(fs.profit) monthly_profit,
lag(sum(fs.profit), 1) over(order by dt.year, dt.month) as next_month_profit
from fact_sales fs
join dim_time dt on(fs.dim_time_id = dt.time_id)
where dt.year = 2021
group by dt.year, dt.month
order by dt.year, dt.month;

select dp.category,
group_concat(dp.product order by dp.product asc separator ', ') as product_list
from dim_product dp
group by dp.category;

show variables like '%group%';
set group_concat_max_len = 1025;

-- -- Lista de Clientes por País
select dg.country_name,
group_concat(concat(dc.first_name, ' ', dc.last_name) order by dc.last_name asc separator ', ') customer_list
from fact_sales fs
join dim_customer dc on(fs.dim_customer_id = dc.customer_id)
join dim_geography dg on(fs.dim_geo_id = dg.geo_id)
group by dg.country_name
order by dg.country_name;

-- -- row_number
select fs.sales_id, fs.dim_customer_id, fs.units_sold,
row_number() over(order by fs.units_sold asc) rown
from fact_sales fs
order by rown, fs.sales_id;

-- -- -- limitar resulados con row_number
with u_sold as (
select fs.sales_id, fs.dim_customer_id, fs.units_sold,
row_number() over(order by fs.units_sold asc) rown
from fact_sales fs
order by rown, fs.sales_id
)

select * from u_sold where rown <=10;

-- -- -- Detectar Clientes con productos repetidos
with ranked_sales as (
select fs.dim_customer_id, fs.dim_product_id,
row_number() over(partition by fs.dim_customer_id, fs.dim_product_id order by fs.sales_id asc) rown
from fact_sales fs
)

select distinct dc.customer_id, concat(dc.first_name, ' ', dc.last_name) customer,
dp. product_id, dp.product
from ranked_sales rs
join dim_customer dc on(rs.dim_customer_id = dc.customer_id)
join dim_product dp on(rs.dim_product_id = dp.product_id)
where rown > 1;

-- -- Calcular el % de unidades vendidas por país
with total_units as(
	select sum(fs.units_sold) as global_units_sold
    from fact_sales fs
)

select dg.country_name, sum(fs.units_sold) as country_units_sold,
round(sum(fs.units_sold) / (select global_units_sold from total_units) * 100, 2) as percentage_units_sold
from fact_sales fs
join dim_geography dg on(fs.dim_geo_id = dg.geo_id)
group by country_name
order by percentage_units_sold desc;

-- -- -- Con Porcentaje total
with total_units as(
	select sum(fs.units_sold) as global_units_sold
    from fact_sales fs
)

select dg.country_name, sum(fs.units_sold) as country_units_sold,
round(sum(fs.units_sold) / (select global_units_sold from total_units) * 100, 2) as percentage_units_sold
from fact_sales fs
join dim_geography dg on(fs.dim_geo_id = dg.geo_id)
group by country_name with rollup
order by percentage_units_sold desc;

-- -- -- -- Por País y Año
with total_units as(
	select sum(fs.units_sold) as global_units_sold
    from fact_sales fs
)

select dg.country_name, dt.year, sum(fs.units_sold) as country_units_sold,
round(sum(fs.units_sold) / (select global_units_sold from total_units) * 100, 2) as percentage_units_sold
from fact_sales fs
join dim_geography dg on(fs.dim_geo_id = dg.geo_id)
join dim_time dt on(fs.dim_time_id = dt.time_id)
group by dg.country_name, dt.year with rollup
order by dg.country_name, percentage_units_sold desc;

-- -- field
select dt.day_name, dp.category, count(*) as nreg, sum(fs.profit) as total_profit
from fact_sales fs
join dim_time dt on(fs.dim_time_id = dt.time_id)
join dim_product dp on(fs.dim_product_id = dp.product_id)
group by dt.day_name, dp.category
order by field(dt.day_name, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'), dp.category;