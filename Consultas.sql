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