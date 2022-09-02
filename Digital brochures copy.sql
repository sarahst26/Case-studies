-- 1. Create a VIEW -----------------------------------------------------------------------------------------
create view v_publisher 
as
select id, cast (sector_id as int) as sector_id, partition_market
from publisher;

select * from v_publisher;


-- Most active sector in December ----------------------------------------------------------------------------
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


