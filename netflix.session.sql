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


4. Find the top 5 countries with the most content on Netflix
5. Identify the longest movie
6. Find content added in the last 5 years
7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
8. List all TV shows with more than 5 seasons
9. Count the number of content items in each genre
10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!
11. List all movies that are documentaries
12. Find all content without a director
13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
14. Find the top 10 actors who have appeared in the highest number of movies produced in India.
15.
Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category.
