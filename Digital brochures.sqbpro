<?xml version="1.0" encoding="UTF-8"?><sqlb_project><db path="/Users/sarahstanley/Downloads/PLtestDB (1).db" readonly="0" foreign_keys="1" case_sensitive_like="0" temp_store="0" wal_autocheckpoint="1000" synchronous="2"/><attached/><window><main_tabs open="structure browser pragmas query" current="3"/></window><tab_structure><column_width id="0" width="300"/><column_width id="1" width="0"/><column_width id="2" width="100"/><column_width id="3" width="1500"/><column_width id="4" width="0"/><expanded_item id="0" parent="1"/><expanded_item id="1" parent="1"/><expanded_item id="2" parent="1"/><expanded_item id="3" parent="1"/></tab_structure><tab_browse><current_table name="4,22:mainagg_clicks_impressions"/><default_encoding codec=""/><browse_table_settings><table schema="main" name="agg_clicks_impressions" show_row_id="0" encoding="" plot_x_axis="" unlock_view_pk="_rowid_"><sort/><column_widths><column index="1" value="75"/><column index="2" value="74"/><column index="3" value="39"/><column index="4" value="32"/><column index="5" value="71"/><column index="6" value="80"/></column_widths><filter_values/><conditional_formats/><row_id_formats/><display_formats/><hidden_columns/><plot_y_axes/><global_filter/></table></browse_table_settings></tab_browse><tab_sql><sql name="SQL 1">-- 1. Create a VIEW
create view v_publisher 
as
select id, cast (sector_id as int) as sector_id, partition_market
from publisher;

select * from v_publisher;

-- Most active sector in December
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
		(pfrom &lt;= '2020-12-01' and puntil &gt;= '2020-12=31') -- or includes Dec 2020
	)
group by sector_name
order by no_titles desc;

</sql><current_tab id="0"/></tab_sql></sqlb_project>
