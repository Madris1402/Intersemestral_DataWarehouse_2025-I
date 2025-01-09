-- Funciones de ventana
-- -- 08 - 01 - 2025
use dwhsales;

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