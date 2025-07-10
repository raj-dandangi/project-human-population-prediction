select * from food_supply_data;
select * from fertility_data;
-------------------------------------------------------
SELECT distinct "Year"
FROM food_supply_data;

SELECT
    "Year",
    COUNT(*) AS record_count,
    SUM("Value") AS total_value,
    AVG("Value") AS average_value,
	count("Area") as total_area
	
FROM
    food_supply_data
GROUP BY
    "Year"
ORDER BY
    "Year";
---------------------------------------------

----------creating a sequence for yesrs ---------------------------------------
update fertility_data
set "year_col" = subquery.repeating_year_value
from(
select
 ctid,
 (row_number() over (order by (select null)) -1) % 74 + 1950 as repeating_year_value
 from
 fertility_data
)as subquery
where fertility_data.ctid = subquery.ctid;
----------------------------------------------------------------------------count of country year wise----------
select  "year_col",
 count(distinct region_subregion_country_or_area) as count_of_region
 from fertility_data group by "year_col" order by "year_col";

select * from data_year_wise

-----------------------------------------------------selecting same data
select country_name from data_year_wise
intersect
select region_subregion_country_or_area from fertility_data

----------------------------------------------- finding sub regions 
SELECT
    fd.region_subregion_country_or_area,
    dyw.country_name 
FROM
    fertility_data AS fd  
LEFT JOIN
    data_year_wise AS dyw 
ON
    fd.region_subregion_country_or_area = dyw.country_name
 where dyw.country_name is NULL
group by dyw.country_name ,  fd.region_subregion_country_or_area 

--- selecting a value from a column
select region_subregion_country_or_area from fertility_data where region_subregion_country_or_area ILIKE '%dem. people''s republic of korea%'
select country_name from data_year_wise where country_name Ilike '%korea%'

--- selecting mutiple values 
SELECT region_subregion_country_or_area
FROM fertility_data
WHERE
    region_subregion_country_or_area ILIKE '%Venezuela%' OR
    region_subregion_country_or_area ILIKE '%Czech Republic%' OR
    region_subregion_country_or_area ILIKE '%Laos%' OR
    region_subregion_country_or_area ILIKE '%Brunei%' OR
    region_subregion_country_or_area ILIKE '%North Korea%' OR
    region_subregion_country_or_area ILIKE '%Syria%' OR
    region_subregion_country_or_area ILIKE '%Turkey%' OR
    region_subregion_country_or_area ILIKE '%Congo (Brazzaville)%' OR
    region_subregion_country_or_area ILIKE '%Congo (Kinshasa)%' OR
    region_subregion_country_or_area ILIKE '%Taiwan%' OR
    region_subregion_country_or_area ILIKE '%Iran%' OR
    region_subregion_country_or_area ILIKE '%Russia%' OR
    region_subregion_country_or_area ILIKE '%Bolivia%' OR
    region_subregion_country_or_area ILIKE '%Vatican City%' OR
    region_subregion_country_or_area ILIKE '%Moldova%' OR
    region_subregion_country_or_area ILIKE '%Tanzania%' OR
    region_subregion_country_or_area ILIKE '%Palestine%' OR
    region_subregion_country_or_area ILIKE '%Myanmar (Burma)%' group by region_subregion_country_or_area ;

--updating and changeing country name 
update fertility_data
set region_subregion_country_or_area =
    case
        when region_subregion_country_or_area = 'united republic of tanzania' then 'tanzania'
        when region_subregion_country_or_area = 'venezuela (bolivarian republic of)' then 'venezuela'
        when region_subregion_country_or_area = 'czechia' then 'czech republic'
        when region_subregion_country_or_area = 'lao people''s democratic republic' then 'laos'
        when region_subregion_country_or_area = 'brunei darussalam' then 'brunei'
        when region_subregion_country_or_area = 'democratic people''s republic of korea' then 'north korea'
        when region_subregion_country_or_area = 'syrian arab republic' then 'syria'
        when region_subregion_country_or_area = 'türkiye' then 'turkey' -- or 'turkiye' if preferred for consistency
        when region_subregion_country_or_area = 'congo' then 'congo (brazzaville)' -- assuming this is the desired disambiguation
        when region_subregion_country_or_area = 'democratic republic of the congo' then 'congo (kinshasa)'
        when region_subregion_country_or_area = 'china, taiwan province of china' then 'taiwan'
        when region_subregion_country_or_area = 'republic of korea' then 'south korea'
        when region_subregion_country_or_area = 'iran (islamic republic of)' then 'iran'
        when region_subregion_country_or_area = 'viet nam' then 'vietnam'
        when region_subregion_country_or_area = 'russian federation' then 'russia'
        when region_subregion_country_or_area = 'bolivia (plurinational state of)' then 'bolivia'
        when region_subregion_country_or_area = 'holy see' then 'vatican city'
        when region_subregion_country_or_area = 'republic of moldova' then 'moldova'
        when region_subregion_country_or_area = 'state of palestine' then 'palestine'
        when region_subregion_country_or_area = 'myanmar' then 'myanmar (burma)'
        else region_subregion_country_or_area
    end
where region_subregion_country_or_area in (
    'united republic of tanzania',
    'venezuela (bolivarian republic of)',
    'czechia',
    'lao people''s democratic republic',
    'brunei darussalam',
    'democratic people''s republic of korea',
    'syrian arab republic',
    'türkiye',
    'congo', -- be careful if there's only one 'congo' and you want to ensure it maps correctly
    'democratic republic of the congo',
    'china, taiwan province of china',
    'republic of korea',
    'iran (islamic republic of)',
    'viet nam',
    'russian federation',
    'bolivia (plurinational state of)',
    'holy see',
    'republic of moldova',
    'state of palestine',
    '%myanmar%'
);
--- selecting data which is not present in fertility_data
SELECT country_name
FROM data_year_wise
EXCEPT
SELECT region_subregion_country_or_area
FROM fertility_data;

SELECT DISTINCT fd.region_subregion_country_or_area
FROM fertility_data AS fd
LEFT JOIN data_year_wise AS dyw
ON fd.region_subregion_country_or_area = dyw.country_name
WHERE dyw.country_name IS NULL;

-- changing country_name to lower
update data_year_wise set country_name = lower(country_name);
update fertility_data set region_subregion_country_or_area = lower(region_subregion_country_or_area);
---changing name north korea to democratic people''s republic of korea
update fertility_data set region_subregion_country_or_area = 'myanmar (burma)' where region_subregion_country_or_area = 'myanmar';

------------------------------------------fixing climate_change
select country_name from climate_change 
except 
select country_name from combained_country_data group by country_name

-------------importing data from fertiliy to data_year_wise where country name matchs 

create table combained_country_data as 
select fd.* 
from 
fertility_data as fd
inner join
data_year_wise as dyw
on
fd.country_name = dyw.country_name

select * from combained_country_data
select year_col , country_name  from combained_country_data group by year_col, country_name order by year_col ASC


select * from climate_change
---- finding unmatched countrys 
select country_name from climate_change group by country_name
except
select country_name from combained_country_data 

--- using ilke 
SELECT
    combained_country_data.country_name -- Replace 'your_table' with the actual table name, e.g., 'climate_change' or 'combined_country_data'
FROM
    combained_country_data -- Replace 'your_table'
WHERE
    country_name ILIKE '%oceania%' OR
    country_name ILIKE '%cook%' OR
    country_name ILIKE '%north atlantic %' OR
    country_name ILIKE '%north america%' OR
    country_name ILIKE '%asia%' OR
    country_name ILIKE '%north pacific %' OR
    country_name ILIKE '%east timor%' OR
    country_name ILIKE '%heard island and mcdonald%' OR
    country_name ILIKE '%europe%' OR
    country_name ILIKE '%south atlantic%' OR
    country_name ILIKE '%saint helena%' OR
    country_name ILIKE '%indian ocean%' OR -- This still has the unmatched parenthesis, matching your input
    country_name ILIKE '%south pacific%' OR
    country_name ILIKE '%africa%' OR
    country_name ILIKE '%czechia%' OR
    country_name ILIKE '%cayman islands%' OR
    country_name ILIKE '%american samoa%' OR
    country_name ILIKE '%south america%' OR
    country_name ILIKE '%australia%' OR
    country_name ILIKE '%china%' OR
    country_name ILIKE '%antarctica%' OR
    country_name ILIKE '%french%' OR
    country_name ILIKE '%isle of man%' OR
    country_name ILIKE '%united states virgin islands%' OR
    country_name ILIKE '%arctic ocean%' OR
    country_name ILIKE '%south georgia and the south sandwich islands%' OR
    country_name ILIKE '%puerto rico%' OR
    country_name ILIKE '%greenland%' OR
    country_name ILIKE '%falkland islands%' OR
    country_name ILIKE '%baltic sea%' OR
    country_name ILIKE '%faroe islands%' OR
    country_name ILIKE '%cape verde%' OR
    country_name ILIKE '%new caledonia%' OR
    country_name ILIKE '%cote d''ivoire%' OR -- Apostrophe escaped for SQL
    country_name ILIKE '%world%' OR
    country_name ILIKE '%mediterranean%' OR
    country_name ILIKE '%anguilla%' OR
    country_name ILIKE '%kosovo%' OR
    country_name ILIKE '%southern ocean%' group by country_name;

select year from climate_change group by year order by year asc

--updateing to the closest relative ---------------------------------------
UPDATE climate_change
SET country_name =
    CASE
        -- Brazil's mappings
        WHEN country_name = 'south america (niaid)' THEN 'Brazil'

        -- Cabo Verde's mapping
        WHEN country_name = 'cape verde' THEN 'Cabo Verde'

        -- China's mappings
        WHEN country_name = 'asia (niaid)' THEN 'China'
        WHEN country_name = 'hong kong' THEN 'China'
        WHEN country_name = 'south china and easter archipelagic seas (niaid)' THEN 'China'

        -- Czech Republic's mapping
        WHEN country_name = 'czechia' THEN 'Czech Republic'

        -- Denmark's mappings
        WHEN country_name = 'faroe islands' THEN 'Denmark'
        WHEN country_name = 'greenland' THEN 'Denmark'

        -- France's mappings
        WHEN country_name = 'french polynesia' THEN 'France'
        WHEN country_name = 'new caledonia' THEN 'France'

        -- Germany's mappings
        WHEN country_name = 'baltic sea (niaid)' THEN 'Germany'
        WHEN country_name = 'europe (niaid)' THEN 'Germany'

        -- Italy's mapping
        WHEN country_name = 'mediterranean region (niaid)' THEN 'Italy'

        -- Nigeria's mapping
        WHEN country_name = 'africa (niaid)' THEN 'Nigeria'

        -- Timor-Leste's mapping
        WHEN country_name = 'east timor' THEN 'Timor-Leste'

        -- United Kingdom's mappings
        WHEN country_name = 'anguilla' THEN 'United Kingdom'
        WHEN country_name = 'cayman islands' THEN 'United Kingdom'
        WHEN country_name = 'falkland islands' THEN 'United Kingdom'
        WHEN country_name = 'isle of man' THEN 'United Kingdom'
        WHEN country_name = 'saint helena' THEN 'United Kingdom'
        WHEN country_name = 'south georgia and the south sandwich islands' THEN 'United Kingdom'

        -- United States of America's mappings
        WHEN country_name = 'american samoa' THEN 'United States of America'
        WHEN country_name = 'north america (niaid)' THEN 'United States of America'
        WHEN country_name = 'puerto rico' THEN 'United States of America'
        WHEN country_name = 'united states virgin islands' THEN 'United States of America'

        ELSE country_name -- Crucial: Keep original value if no match in WHEN clauses
    END
WHERE
    country_name IN (
        'south america (niaid)',
        'cape verde',
        'asia (niaid)',
        'hong kong',
        'south china and easter archipelagic seas (niaid)',
        'czechia',
        'faroe islands',
        'greenland',
        'french polynesia',
        'new caledonia',
        'baltic sea (niaid)',
        'europe (niaid)',
        'mediterranean region (niaid)',
        'africa (niaid)',
        'east timor',
        'anguilla',
        'cayman islands',
        'falkland islands',
        'isle of man',
        'saint helena',
        'south georgia and the south sandwich islands',
        'american samoa',
        'north america (niaid)',
        'puerto rico',
        'united states virgin islands'
    );

-------- 
select * from climate_change
select distinct count(country_name),   country_name from climate_change group by country_name 
select distinct country_name  from climate_change

------------merging data to join on fertilt-data

SELECT country_name, year , total_yearly_temp
FROM climate_change
WHERE country_name in ('Australia')
GROUP BY country_name, year,total_yearly_temp order by year

ALTER TABLE climate_change
DROP COLUMN total_yearly_temp;
ALTER TABLE climate_change
ADD COLUMN total_yearly_temp NUMERIC; 

UPDATE climate_change AS cc
SET total_yearly_temp = yts.yearly_sum
FROM (
    SELECT
        distinct year,
        SUM(temperature_anomaly) AS yearly_sum -- Using temperature_anomaly as per your query
    FROM
        climate_change
    WHERE
        country_name = 'Germany' -- Filter for China in the subquery
    GROUP BY
        year
) AS yts
WHERE
    cc.year = yts.year AND cc.country_name = 'Germany'; -- Filter for China in the main update

---backup table
--create table climate_change_backup as select * from climate_change
select  year ,total_yearly_temp ,country_name from climate_change where country_name = 'China' group by  year ,total_yearly_temp ,country_name 
select distinct year , total_yearly_temp  from climate_change 
 
create table climate_change_ordered as
 select distinct year ,total_yearly_temp , country_name from climate_change group by year,total_yearly_temp , country_name order by year

select * from climate_change_ordered
create table climate_change_0 as
 select distinct year ,temperature_anomaly , country_name from climate_change group by year,temperature_anomaly , country_name order by year

select country_name , temperature_anomaly , distinct year from climate_change_0 group by year , country_name , temperature_anomaly

SELECT DISTINCT
    country_name,
    temperature_anomaly,
    year
FROM
    climate_change_0 order by year


---i want to joint tables in psql i want to import data from climate_change_0 temperature_anomaly to climate_change_order cloumn total_year_temputure where is null using year as the pramery key  
SELECT
    t1.year,
    t1.country_name,
    t1.total_yearly_temp AS current_total_yearly_temp_in_order_table,
    t2.temperature_anomaly AS proposed_temperature_anomaly_from_source
FROM
    climate_change_ordered AS t1
JOIN
    climate_change_0 AS t2 ON t1.year = t2.year AND t1.country_name = t2.country_name
WHERE
    t1.total_yearly_temp IS NULL;

select * from co2_estimates 

select * from cimate_change_with_population

create table co2_and_climate_change_population as 
SELECT
    t1.annual_co2_emissions, -- Added a comma here
    t2.*
FROM
    co2_estimates AS t1
JOIN
    cimate_change_with_population AS t2 -- Corrected table name typo
ON
    t1.entity = t2.country_name  AND t1.year = t2.year_col order by year_col

SELECT column_name
FROM information_schema.columns
WHERE table_schema = 'public' -- Assuming your table is in the 'public' schema
  AND table_name = 'food_supply_data'
ORDER BY ordinal_position;


select distinct "Area" from food_supply_data

select distinct country_name from food_supply_data

UPDATE food_supply_data
SET country_name = LOWER(country_name);

select * from co2_and_climate_change_population

select t1.country_name
from food_supply_data as t1
join 
co2_and_climate_change_population as t2 on t1.country_name = t2.country_name