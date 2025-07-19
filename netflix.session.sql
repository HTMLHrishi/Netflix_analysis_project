DROP TABLE IF EXISTS NETFLIX


CREATE TABLE NETFLIX
(
    show_id VARCHAR(50) PRIMARY KEY,   
    type VARCHAR(10),	
    title text,	
    director text,	
    casts varchar(1000),	
    country	varchar(300),
    date_added	date,
    release_year  int,	
    rating	varchar(200),
    duration text,
    listed_in	text,
    description text
);



COPY NETFLIX
FROM 'C:\SQL\sql_load\netflix_titles.csv'
WITH (FORMAT CSV,HEADER TRUE, DELIMITER ',',ENCODING 'UTF-8');

SELECT *
FROM netflix

SELECT
    COUNT(*) as total_content
FROM
    netflix



--1. Count the number of Movies vs TV Shows


SELECT
    type,
    COUNT(*) as categorywise_content
FROM
    netflix
GROUP BY 
1



--2. Find the most common rating for movies and TV shows

SELECT
 type,
 rating,
 total
 FROM
(
SELECT
    type,
    rating,
    COUNT(*) as total,
    RANK () OVER (PARTITION BY type ORDER BY COUNT(*) DESC ) as rank
FROM
    NETFLIX 
GROUP BY 
    1,2
ORDER BY 
    1 ,3 DESC
) as t1

WHERE rank = 1;




--3. List all movies released in a specific year (e.g., 2020)

SELECT
    *
FROM
    netflix
WHERE 
    release_year = 2020
    AND
    type = 'Movie';




--4. Find the top 5 countries with the most content on Netflix

SELECT
    UNNEST(STRING_TO_ARRAY(country,',')) as new_country,
    count(*) as count_id
FROM
    netflix
Group by 
    1
ORDER BY 
    2 DESC
LIMIT 5

--5. Identify the longest movie
--SubQuery

SELECT
    *
FROM
    Netflix
Where
    type = 'Movie'
    AND
    duration = (Select Max(duration) from Netflix)    



--6. Find content added in the last 5 years

SELECT 
    *
FROM
    Netflix
Where  date_added >= CURRENT_DATE - INTERVAL '5 Years'
--TO_DATE('Month DD,YYYY') to convert to date if date is September 19,2020



--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT
    *
From
    Netflix
Where
    director LIKE '%Rajiv Chilaka%'



--8. List all TV shows with more than 5 seasons

Select  
    *
FROM
    NETFLIX
Where
    type = 'TV Show'
    AND
    CAST(SPLIT_PART(duration,' ',1)AS INTEGER) > 5

    




--SELECT
--  SPLIT_PART('Apple Banana Cherry',' ',3)



--9. Count the number of content items in each genre

SELECT
    type,
    UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
    COUNT(type)
FROM
    Netflix
GROUP BY 
    1,2
ORDER BY
    1,2


--10.Find each year and the average numbers of content release in India on netflix.
--return top 5 year with highest avg content release!
--349/1046

SELECT
    EXTRACT(Year from date_added),
    COUNT(*) as content_yearly,
    ROUND(COUNT(*)::numeric/(Select COUNT(*) FROM Netflix Where country = 'India') * 100,3) as avg_content

FROM
    NETFLIX
WHERE
    Country LIKE '%India%'
Group by 
1
ORDER BY 
3 DESC
LIMIT 5


--11. List all movies that are documentaries

SELECT
    *
FROM 
    NETFLIX
WHERE 
    type = 'Movie'
    AND
    listed_in ILIKE '%Documentaries%'


--12. Find all content without a director

SELECT
    *
FROM
    NETFLIX
WHERE 
    director IS NULL



--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
SELECT
    *
FROM
    Netflix
WHERE
    casts ILIKE '%Salman Khan%'
    AND
    date_added >= CURRENT_DATE - INTERVAL '10 years'

--OR 

SELECT
    *
FROM
    Netflix
WHERE
    casts ILIKE '%Salman Khan%'
    AND
    release_year >= EXTRACT(year from CURRENT_DATE) - 10




--14. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT
    UNNEST(STRING_TO_ARRAY(casts,',')) as actor,
    COUNT(*) as appearances
    
FROM
    NETFLIX
WHERE
    COUNTRY ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10


--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
--the description field. Label content containing these keywords as 'Bad' and all other 
--content as 'Good'. Count how many items fall into each category.

WITH 
content_categorization
AS
(
    SELECT *,
    CASE
        WHEN description ILIKE '%kill' OR  description ILIKE '%violence%' THEN 'Bad'
        ELSE
            'Good'
        END AS 
            content_type
        FROM
            netflix
) 

SELECT 
    content_type,
    COUNT(*)
FROM
    content_categorization
GROUP BY 1 


