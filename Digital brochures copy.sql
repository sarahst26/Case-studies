-- 1. Create a VIEW -------------------------------------------------------------------------------------------
create view v_publisher 
as
select id, cast (sector_id as int) as sector_id, partition_market
from publisher;

select * from v_publisher;


-- 2. Compute the CTR on sector level --------------------------------------------------------------------------
select
sector.name as sector_name,
round(sum(agg_clicks_impressions.clicks)/sum(agg_clicks_impressions.impr
essions)*100, 2) || "%" as CTR
from agg_clicks_impressions
join v_publisher
on agg_clicks_impressions.publisher_id = v_publisher.id
join sector
on v_publisher.sector_id = sector.sector_id
group by sector.name;


-- 3. Most active sector in December 2021 -----------------------------------------------------------------------
select content.pfrom, content.puntil, sector.name as sector_name,
count(content.title) as no_titles
from content
join v_publisher
on content.publisher_id = v_publisher.id
join sector
on v_publisher.sector_id = sector.sector_id
where 
( 
		(pfrom like '2020-12-%' or puntil like '2020-12-%') -- either started or ended in Dec 2020
	or
		(pfrom <= '2020-12-01' and puntil >= '2020-12=31') -- or includes Dec 2020
	)
group by sector_name
order by no_titles desc;


-- 4. How many brochures started per sector in May 2021 ---------------------------------------------------------
select sector.name, count(distinct content.title)
from content
join v_publisher
on content.publisher_id = v_publisher.id
join sector
on v_publisher.sector_id = sector.sector_id
where content.pfrom between '2021-05-01' and '2021-05-31'
group by sector.name;

