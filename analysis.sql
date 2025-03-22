-- DROP TABLE IF EXISTS netflix;
-- Create Table netflix (
-- 	show_id VARCHAR(5),
-- 	type VARCHAR(10),
-- 	title VARCHAR(104),
-- 	director VARCHAR(208),
-- 	casts VARCHAR(771),
-- 	country	VARCHAR(123),
-- 	date_added VARCHAR(100),
-- 	release_year INT,
-- 	rating VARCHAR(100),
-- 	duration VARCHAR(10),
-- 	listed_in VARCHAR(79),
-- 	description VARCHAR(250)
-- );
-- ------------
```
'''Select * From netflix;
Select COUNT(*) total From netflix;'''
```
--------------
```
Select 
	DISTINCT(type)
From netflix;
```
---------------
```
--Count the movies and TV shows
Select
	type,
	Count(type) as total
From netflix
Group By type;
--"Movie"	6131, "TV Show"	2676
```
-----------
```
--find the most common ratings for movies and tv-shows
select 
	type,
	rating
From
(
	Select
		type,
		rating,
		Count(rating),
		Rank() OVER(PARTITION BY type ORDER BY Count(rating) desc) AS ranking
	From netflix
	Group By type, rating
) as t1
where ranking=1 OR ranking=2 OR ranking=3;

--"Movie"	"TV-MA"	2062, "TV Show"	"TV-MA"	1145
```
-----------------
```
--list all movies released in a specific year

Select 
	release_year,
	count(release_year) m_count
From netflix
group by release_year
order by t_count desc;

Select
	title,
	type,
	release_year,
	country
From netflix
Where type='Movie' AND release_year=2020
Limit 5;
```
---------------------------
```
--top 5 countries with the most content on netflix
Select
	TRIM(UNNEST(STRING_TO_ARRAY(country, ','))) as new_country,
	count(show_id) c_count
From netflix
group by 1
order by 2 desc
limit 5;
```
----------------
```
-- find the longest movie

select 
	* 
FROM netflix
WHERE 
	type='Movie' 
	AND 
	duration=(select MAX(duration) FROM netflix);
```
-------------------
```
--find content added in the last five years
Select
	*,
	TO_DATE(date_added, 'Month DD, YYYY')
From netflix
where TO_DATE(date_added, 'Month DD, YYYY')  > CURRENT_DATE - INTERVAL '5 Years'
```
----------------------------
```
--find all the movies by director "Rajiv Chilaka"
SELECT
	*
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%'
```
-------------------
```
-- list all tv-shows with more than 5 seasons

SELECT 
	*
FROM netflix
WHERE type= 'TV Show' AND SPLIT_PART(duration, ' ', 1)::numeric > 5;
```
----------------------
```
--count the number of content in each genre.
Select 
	TRIM(UNNEST(STRING_TO_ARRAY(listed_in, ','))),
	Count(show_id)
From netflix
Group By 1
Order By 2 Desc
```
--------------------
```
--find the average number of content released by india on netflix
Select 
	EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as Year,
	Count(*) as years,
	Round(Count(*)::numeric/(Select count(*) From netflix where country='India')::numeric * 100, 2) as avg_content
from netflix
Where country='India'
Group BY 1
Order By 2 Desc
```
----------------------
```
--find the top 10 actors who have appeared in movies mostly
Select 
	TRIM(UNNEST(STRING_TO_ARRAY(casts, ','))) as actors,
	Count(*)
From netflix
Group By 1
Order By 2 DESC
LIMIT 10;
```
---------------------
```
--Categorize the content based on the keywords 'kill' and 'violence' in the description. 
--Label content containing these keywords as bad and good label for the rest of the content.
With new_table AS (
Select 
	CASE
	WHEN description ILIKE '%kill%' OR description ILIKE '%murder%' OR description ILIKE '%violence%' THEN 'bad'
		ELSE 'good'
	END category,
	description
from netflix
)

Select 
	category,
	Count(*)
From new_table
Group BY 1
```
