-- Elementos del Data Warehouse
-- 07 - 01 - 2025

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

-- -- Usando Rollups
select dt.year, count(*) as num_sales, sum(fs.profit) as total_profit, max(fs.profit) as max_profit, min(fs.profit) as min_profit,
avg(fs.profit) as promedio_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
group by dt.year with rollup;

-- -- Por año y mes
select dt.year, dt.month, count(*) as num_sales, sum(fs.profit) as total_profit, max(fs.profit) as max_profit, min(fs.profit) as min_profit,
avg(fs.profit) as promedio_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
group by dt.year, dt.month with rollup;

-- -- Para el año 2021
select dt.year, dt.month, count(*) as num_sales, sum(fs.profit) as total_profit, max(fs.profit) as max_profit, min(fs.profit) as min_profit,
avg(fs.profit) as promedio_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
where dt.year = 2021
group by dt.year, dt.month with rollup;

-- -- Por año, mes y pais
select dt.year, dt.month, dg.country_name, count(*) as num_sales, sum(fs.profit) as total_profit, max(fs.profit) as max_profit, min(fs.profit) as min_profit,
avg(fs.profit) as promedio_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
group by dt.year, dt.month, dg.country_name with rollup;

-- -- Por año país, categoría y género
select dt.year, dg.country_name, dp.category, dc.gender, count(*) as num_sales, sum(fs.profit) as total_profit, max(fs.profit) as max_profit, min(fs.profit) as min_profit,
avg(fs.profit) as promedio_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_product dp on(fs.dim_product_id = dp.product_id)
join dim_customer dc on (fs.dim_customer_id = dc.customer_id)
group by dt.year, dg.country_name, dp.category, dc.gender with rollup;

-- -- Por año y país (usando grouping)
select dt.year, dg.country_name, count(*) as num_sales, sum(fs.profit) as total_profit, max(fs.profit) as max_profit, min(fs.profit) as min_profit,
avg(fs.profit) as promedio_profit, sum(units_sold) as total_units_sold,
grouping(dt.year), grouping(dt.year, dg.country_name)
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
group by dt.year, dg.country_name with rollup;

-- -- Por año y país (usando having y grouping)
select dt.year, dg.country_name, count(*) as num_sales, sum(fs.profit) as total_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
group by dt.year, dg.country_name with rollup
having grouping(dt.year, dg.country_name) = 1;

-- -- Por año país, categoría y género (usando having y grouping)
select dt.year, dg.country_name, dp.category, dc.gender, count(*) as num_sales, sum(fs.profit) as total_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_product dp on(fs.dim_product_id = dp.product_id)
join dim_customer dc on (fs.dim_customer_id = dc.customer_id)
group by dt.year, dg.country_name, dp.category, dc.gender with rollup
having grouping(dt.year, dg.country_name) <> 1;

-- -- Por año país y categoría (Añadierndo mensajes para las jerarquías usando if grouping)
select if(grouping(dt.year), 'All Years', dt.year) year, if(grouping(dg.country_name), 'All Countries', dg.country_name) country, 
if(grouping(dp.category), 'All Categories', dp.category) category, count(*) as num_sales, sum(fs.profit) as total_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_product dp on(fs.dim_product_id = dp.product_id)
group by dt.year, dg.country_name, dp.category with rollup;

-- Actividad 01
-- -- Ganancia total por categoria y año
select if(grouping(dp.category), 'All Categories', dp.category) category, if(grouping(dt.year), 'All Years', dt.year) year, count(*) as num_sales, sum(fs.profit) as total_profit
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
join dim_product dp on(fs.dim_product_id = dp.product_id)
group by dp.category, dt.year with rollup;

-- -- Número de transacciones en fines de semana
select dt.is_weekend, count(*) as num_sales
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
where dt.is_weekend = 'True'
group by dt.is_weekend;

-- -- Resumen por genero, mes y continente
select if(grouping(dc.gender), 'All Genders', dc.gender) gender, if(grouping(dt.month), 'All Months', dt.month) month, if(grouping(dg.continent), 'All Continents', dg.continent) continent, count(*) as num_sales, sum(fs.profit) as total_profit, sum(units_sold) as total_units_sold
from fact_sales fs
join dim_time dt on fs.dim_time_id = dt.time_id
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_customer dc on (fs.dim_customer_id = dc.customer_id)
group by dt.month, dg.continent, dc.gender with rollup;


-- Funciones de ventana
-- -- 08 - 01 - 2025

-- Cliente con la mayor ganancia
-- -- Ver total de movimientos por cliente
select dim_customer_id, count(*) from fact_sales
group by dim_customer_id
order by 2 desc;

-- -- Ver total de movimientos por país
select country_name, count(*) from fact_sales fs
join dim_geography dg on(fs.dim_geo_id = dg.geo_id)
group by country_name
order by 2 desc;

-- -- Rank
select dc.customer_id, dc.first_name, dc.last_name, dg.country_name, fs.profit,
rank() over(partition by dg.country_name order by fs.profit desc) rank_profit
from fact_sales fs
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_customer dc on(fs.dim_customer_id = dc.customer_id);

-- -- -- Seleccionar Clientes con el Ranking #1 de cada País
select * from(select dc.customer_id, dc.first_name, dc.last_name, dg.country_name, fs.profit,
rank() over(partition by dg.country_name order by fs.profit desc) rank_profit
from fact_sales fs
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_customer dc on(fs.dim_customer_id = dc.customer_id)) x
where rank_profit = 1;

-- -- -- Seleccionar Clientes con las Mayores Pérdidas
select dc.customer_id, dc.first_name, dc.last_name, dg.country_name, fs.profit,
rank() over(partition by dg.country_name order by fs.profit asc) rank_profit
from (select * from fact_sales where profit < 0) fs
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_customer dc on(fs.dim_customer_id = dc.customer_id);

-- -- -- 10 Paises con Más Ganancias
select dg.country_name, sum(fs.profit) total_profit,
rank() over(order by sum(fs.profit) desc) rank_profit
from fact_sales fs
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
group by dg.country_name
order by rank_profit
limit 10;

-- -- -- -- 10 Paises con Más Ganancias solamente de Hombres
select dg.country_name, dc.gender, sum(fs.profit) total_profit,
rank() over(order by sum(fs.profit) desc) rank_profit
from fact_sales fs
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_customer dc on(fs.dim_customer_id = dc.customer_id)
where dc.gender = 'Male'
group by dg.country_name
order by rank_profit
limit 10;

-- -- -- -- -- Consulta Optimizada para ahorrar memoria
select dg.country_name, dc.gender, sum(fs.profit) total_profit,
rank() over(order by sum(fs.profit) desc) rank_profit
from fact_sales fs
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join (select * from dim_customer where gender = 'Male') dc on(fs.dim_customer_id = dc.customer_id)
group by dg.country_name
order by rank_profit
limit 10;

-- -- Dense Rank
select dt.month, sum(fs.profit) total_profit,
dense_rank() over(order by sum(fs.profit) desc) rank_profit
from fact_sales fs
join dim_time dt on (fs.dim_time_id = dt.time_id)
group by dt.month
order by rank_profit;

-- -- Suma acumulada
select dc.customer_id, dc.first_name, dc.last_name, dg.country_name, fs.profit,
sum(fs.profit) over(partition by dg.country_name order by fs.profit desc) cumulative_profit
from fact_sales fs
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_customer dc on(fs.dim_customer_id = dc.customer_id);

-- -- Promedio Movil
select dc.customer_id, dc.first_name, dc.last_name, dg.country_name, fs.profit,
avg(fs.profit) over(partition by dg.country_name order by fs.dim_time_id rows between 2 preceding and current row) moving_avg
from fact_sales fs
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_customer dc on(fs.dim_customer_id = dc.customer_id);

-- -- Primer y Último Valor
select dc.customer_id, dc.first_name, dc.last_name, dg.country_name, fs.profit,
first_value(fs.profit) over(partition by dg.country_name order by fs.dim_time_id asc) first_val,
last_value(fs.profit) over(partition by dg.country_name order by fs.dim_time_id asc rows between unbounded preceding and unbounded following) last_val
from fact_sales fs
join dim_geography dg on (fs.dim_geo_id = dg.geo_id)
join dim_customer dc on(fs.dim_customer_id = dc.customer_id);

-- Anidar Funciones de Ventana
-- -- 09 - 01 - 2025

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
