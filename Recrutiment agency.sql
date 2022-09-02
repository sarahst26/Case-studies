-- The file contains all the queries I wrote to answer questions 1a-d
-- A. Company-wide CLTV on CAC = 128.51
select round((select ((select avg(value)
				from deals
				where status = 'won') *
				(select avg(c) from a)) /
				(select(select sum(spend_bing)+sum(spend_facebook)+sum(spend_adwords) from marketing) / 
				(select count(lead_id) from leads))),2);

	-- Baseline metrics
	-- CLTV = avg. value of a won deal * avg. number of deals won (per candidate) = 7690.32
	select round((select avg(value)
					from deals
					where status = 'won') *
				(select avg(c) from a)
			,2) as cltv_on_cac;

		-- avg. value of a won deal = 7528
		select avg(value)
		from deals
		where status = 'won';

		-- avg. number of deals won (per candidate) = 1.02
		create view a as
		select leads.candidate_id, count(case deals.status when 'won' then 1 end) as c
		from leads
		join deals
		on leads.lead_id = deals.lead_id
		group by leads.candidate_id, deals.status
		having count(case deals.status when 'won' then 1 end) > 0
		select avg(c) from a;


	-- CAC: total spent on all marketing channels on no. of leads = 59.84
	select round((select sum(spend_bing)+sum(spend_facebook)+sum(spend_adwords) from marketing) / 
				(select count(lead_id) from leads)
				 ,2) as cac;

----------------------------------------------------------------- 
-- B. Most profitable marketing channel
select 
   leads.channel, 
    -- Calculating the sum of value won depending on which marketing channel was successful for the lead
       case 
          when leads.channel = 'SEM_Bing' then round(sum(deals.value)/sum(marketing.spend_bing),2)
          when leads.channel = 'Facebook' then round(sum(deals.value)/sum(marketing.spend_facebook),2)
          else round(sum(deals.value)/sum(marketing.spend_adwords),2)
       end as profit_ratio
from deals
-- Join deals and leads tables to compare values of won deals against marketing channel
right join leads on deals.lead_id = leads.lead_id 
-- Join marketing table to compare the leads_created dates with marketing_campaign dates
right join marketing on leads.lead_created_at = marketing.date 
where deals.status = 'won' 
group by leads.channel
order by profit_ratio desc;
          
	-- Result: Bing returns the highest ROI
	
-----------------------------------------------------------------
-- C. Most scalable marketing channel

	-- 1. No. of leads
	select channel, count(lead_id) as leads_generated
	from leads
	group by channel
	order by leads_generated desc;
	-- Conversion rate per channel
	select 
		channel, 
		cast(count(leads.lead_id) as numeric) as leads_generated, 
		cast(count(case status when 'won' then 1 end) as numeric) as leads_won,
		cast(count(leads.lead_id) / count(case status when 'won' then 1 end) as numeric) as conversion_rate
	from leads
	join deals
	on leads.lead_id = deals.lead_id
	group by channel
	order by leads_generated desc;
	
	
	-- 2. No. of leads per agent  = 196.2
	create view l as
	select agent_id, count(lead_id) as leads
	from deals
	group by agent_id;
	
	select avg(leads) from l;
	
	-- 3. Avg. days to convert per channel (from 95 wins)
	select 
		leads.channel,
		round(avg(deals.deal_created_at - leads.lead_created_at),0) as avg_days_to_win
	from deals
	join leads
	on leads.lead_id = deals.lead_id
	where deals.status = 'won'
	group by leads.channel
	order by avg_days_to_win;

----------------------------------------------------------------- 
-- D. Problematic recruitment agent(s)
select
    agent_id, 
    count(lead_id) as total_leads, 
    -- to find how many cases were lost per agent
    cast(count(case status when 'lost' then 1 end) as numeric) as no_of_leads_lost,
 	-- calculate % of lost deals over number of leads per agent
   	round(cast(count(case status when 'lost' then 1 end) as numeric) / count(lead_id) * 100,1) as pc_leads_lost,
	-- to find the total amount of value lost
   	sum(case status when 'lost' then value end) as total_value_lost
from deals
group by agent_id
order by total_value_lost desc;

	-- Result: Agent 5 has the highest lost leads rate of 90% but Agents 3 and 2 have the highest loss of potential value each over €200,000.











































