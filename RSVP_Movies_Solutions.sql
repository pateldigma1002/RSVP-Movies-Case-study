/* Submitted By  Dipak Kumar Pradhan ,  Digmakumari Tarunkumar Patel  &  Rajan Ram */

USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/

-- Segment 1:

-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 
	   table_name
	  ,table_rows
FROM   
	   information_schema.tables
WHERE  table_schema = 'imdb'; 


-- Q2. Which columns in the movie table have null values?
-- Type your code below:
SELECT 
		 SUM(CASE WHEN id IS NULL THEN 1 ELSE 0 END) AS id_null_count 
		,SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) AS title_null_count
		,SUM(CASE WHEN year IS NULL THEN 1 ELSE 0 END) AS year_null_count
		,SUM(CASE WHEN date_published IS NULL THEN 1 ELSE 0 END) AS date_published_null_count
		,SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) AS duration_null_count
		,SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) AS country_null_count
		,SUM(CASE WHEN worlwide_gross_income IS NULL THEN 1 ELSE 0 END) AS worlwide_gross_income_null_count
		,SUM(CASE WHEN languages IS NULL THEN 1 ELSE 0 END) AS languages_null_count
		,SUM(CASE WHEN production_company IS NULL THEN 1 ELSE 0 END) AS production_company_null_count
FROM 	
		movie;
        
-- Columns with null values are : 1. country, 2. worlwide_gross_income, 3. languages, 4. production_company



-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Number of movies released each year.

SELECT 
	year ,
	COUNT(id) AS number_of_movies 
FROM movie 
GROUP BY year;


SELECT 
	MONTH(date_published) AS month_num, 
	COUNT(id)AS number_of_movies 
FROM movie 
GROUP BY MONTH(date_published)
ORDER BY MONTH(date_published);

-- Highest number of movies were released in 2017
-- Highest number of movies are released in the month of March.


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:
SELECT 
	count(id) AS movie_count
FROM 
	movie
WHERE 
	(country LIKE '%India%' OR country LIKE '%USA%') AND year= 2019;

-- 1059 movies were produced in the USA or India in the year 2019



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT genre FROM genre group by genre;


/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT 
 genre
,COUNT(movie_id) AS no_of_movies
FROM genre GROUP BY genre 
LIMIT 1;

-- 4285 Drama genre movies were produced in total and are the highest among all genres. 


/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH genre_count AS
(SELECT movie_id FROM genre GROUP BY movie_id HAVING COUNT(movie_id) = 1)
SELECT 
	  count(*) AS movie_count 
FROM  genre_count ;
-- 3289 movies belong to only one genre




/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)

/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	g.genre ,
	ROUND(AVG(m.duration),2) AS avg_duration
FROM 
	movie m 
INNER JOIN genre g
ON m.id = g.movie_id
GROUP BY g.genre 
ORDER BY ROUND(AVG(m.duration),2) DESC;


/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:


WITH genre_rank AS
(
SELECT genre, COUNT(movie_id) AS movie_count,
RANK() OVER(ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM genre
GROUP BY genre
)
SELECT *
FROM genre_rank
WHERE genre='thriller';

-- Thriller genre has rank  3 with movie count of 1484

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/

-- Segment 2:

-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT 
        Min(avg_rating)    AS MIN_AVG_RATING
       ,Max(avg_rating)    AS MAX_AVG_RATING
       ,Min(total_votes)   AS MIN_TOTAL_VOTES
       ,Max(total_votes)   AS MAX_TOTAL_VOTES
       ,Min(median_rating) AS MIN_MEDIAN_RATING
       ,Max(median_rating) AS MAX_MEDIAN_RATING
FROM   ratings; 


/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH MOVIE_RANK AS
(
SELECT title,avg_rating,
ROW_NUMBER() OVER(ORDER BY avg_rating DESC) AS movie_rank
FROM  ratings   AS r
INNER JOIN movie  AS m
ON m.id = r.movie_id
)
SELECT * FROM MOVIE_RANK
WHERE movie_rank<=10;

-- Top 3 movies have average rating >= 9.8


/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:
+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT 
	 median_rating
	,COUNT(movie_id) AS movie_count
FROM   ratings
GROUP  BY median_rating
ORDER  BY median_rating DESC; 


/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_comp_hit_movie_summary
AS (
	SELECT 
		 production_company
		,Count(movie_id) AS MOVIE_COUNT
		,Rank() OVER( ORDER BY Count(movie_id) DESC ) AS PROD_COMPANY_RANK
	FROM   		ratings AS r
	INNER JOIN 	movie AS m
	ON 	 	m.id = r.movie_id
	WHERE  	avg_rating > 8
	AND 	production_company IS NOT NULL
	GROUP  BY production_company
    )
	SELECT *
	FROM   production_comp_hit_movie_summary
	WHERE  prod_company_rank = 1; 

-- Dream Warrior Pictures and National Theatre Live production houses has produced the most number of hit movies (average rating > 8)
-- They have rank=1 and movie count =3 

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	genre
	,Count(m.id) AS MOVIE_COUNT
FROM   		movie AS m
INNER JOIN 	genre AS g
	ON 		g.movie_id = m.id
INNER JOIN 	ratings AS R
	ON 		r.movie_id = m.id
WHERE  	year = 2017
AND  	Month(date_published) = 3
AND  	country LIKE '%USA%'
AND  	total_votes > 1000
GROUP  BY genre
ORDER  BY Count(m.id) DESC; 

-- 24 Drama movies were released during March 2017 in the USA and had more than 1,000 votes
-- Top 3 genres are drama, comedy and action during March 2017 in the USA and had more than 1,000 votes



-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT 
	 title
	,avg_rating 
	,genre
FROM genre AS g
INNER JOIN ratings AS r
	ON 	g.movie_id = r.movie_id
INNER JOIN movie AS m
	ON m.id = g.movie_id
WHERE title LIKE 'The%' AND avg_rating > 8
ORDER BY avg_rating DESC;


-- There are 8 movies which begin with "The" in their title.
-- The Brighton Miracle has highest average rating of 9.5.

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:
SELECT 
 median_rating 
,Count(*) AS movie_count
FROM   movie AS m
INNER JOIN ratings AS r
	ON r.movie_id = m.id
WHERE  median_rating = 8
	AND date_published BETWEEN '2018-04-01' AND '2019-04-01'
GROUP BY median_rating;

-- 361 movies have released between 1 April 2018 and 1 April 2019 with a median rating of 8


-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT SUM(r.total_votes) as total_votes_german FROM 
movie m INNER JOIN ratings r
ON m.id=r.movie_id
WHERE m.languages LIKE "%German%" ;

-- total_votes_german : 4421525

SELECT SUM(r.total_votes) total_votes_italian FROM 
movie m INNER JOIN ratings r
ON m.id=r.movie_id
WHERE m.languages LIKE "%Italian%" ;

-- total_votes_italian : 2559540

-- Answer is Yes
-- German movies received the highest number of votes while checking for languages column.

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/

-- Segment 3:

-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/

-- Type your code below:
SELECT 
	 SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) AS name_nulls_count
	,SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END) AS height_nulls_count
	,SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END) AS date_of_birth_nulls_count
	,SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END) AS known_for_movies_nulls_count		
FROM names;

-- Height, date_of_birth, known_for_movies columns contain NULLS


/* There are no Null value in the column 'name'.
The director is the most important person in a movie crew. 
Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

WITH top_3_genres AS
(
	SELECT   
		 genre
		,Count(m.id) AS movie_count 
		,Rank() OVER(ORDER BY Count(m.id) DESC) AS genre_rank
	FROM  movie AS m
	INNER JOIN genre AS g
		ON  g.movie_id = m.id
	INNER JOIN ratings AS r
		ON  r.movie_id = m.id
	WHERE  avg_rating > 8
	GROUP BY  genre limit 3 
)
	SELECT  
		n.NAME  AS director_name 
		,Count(d.movie_id) AS movie_count
	FROM  director_mapping  AS d
	INNER JOIN genre G
		using  (movie_id)
	INNER JOIN names AS n
		ON  n.id = d.name_id
	INNER JOIN top_3_genres
		using  (genre)
	INNER JOIN ratings
		using  (movie_id)
	WHERE  avg_rating > 8
	GROUP BY   NAME
	ORDER BY   movie_count DESC limit 3 ;

-- James Mangold , Anthony Russo, Soubin Shahir are top three directors in the top three genres whose movies have an average rating > 8

/* James Mangold can be hired as the director for RSVP's next project. Do you remeber his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:
+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT 
	 n.name  AS actor_name
	,Count(movie_id) AS movie_count
FROM   role_mapping AS rm
INNER JOIN movie AS m
	ON m.id = rm.movie_id
INNER JOIN ratings AS r 
	USING(movie_id)
INNER JOIN names AS n
	ON n.id = rm.name_id
WHERE  r.median_rating >= 8
AND category = 'ACTOR'
GROUP  BY actor_name
ORDER  BY Count(movie_id) DESC
LIMIT  2; 
        
-- Top 2 actors are Mammootty and Mohanlal.

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH ranking AS(
	SELECT 
     production_company
    ,SUM(total_votes) AS vote_count
	,RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
	FROM movie AS m
	INNER JOIN ratings AS r 
		ON r.movie_id=m.id
	GROUP BY production_company
    )
SELECT 
	 production_company
	,vote_count
	,prod_comp_rank
FROM  ranking
WHERE prod_comp_rank<4;

-- Top three production houses based on the number of votes received by their movies are Marvel Studios, Twentieth Century Fox and Warner Bros.


/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


SELECT 
	 name AS actor_name
	,SUM(total_votes) AS total_votes
	,COUNT(m.id) AS movie_count
	,ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actor_avg_rating
	,RANK() OVER(ORDER BY SUM(avg_rating*total_votes)/SUM(total_votes) DESC) AS actor_rank
FROM  movie AS m 
INNER JOIN ratings AS r 
	ON m.id=r.movie_id 
INNER JOIN role_mapping AS rm 
	ON m.id=rm.movie_id 
INNER JOIN names AS n 
	ON rm.name_id=n.id
WHERE category='actor' AND country like '%India%'
GROUP BY name
HAVING COUNT(m.id)>=5;

-- Top actor is Vijay Sethupathi.


-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:


WITH ranking AS(
	SELECT 
         name AS actress_name 
        ,SUM(total_votes) AS total_votes
        ,COUNT(m.id) AS movie_count
		,ROUND(SUM(avg_rating*total_votes)/SUM(total_votes),2) AS actress_avg_rating 
		,RANK() OVER(ORDER BY SUM(avg_rating*total_votes)/SUM(total_votes) DESC) AS actress_rank
	FROM movie AS m 
	INNER JOIN ratings AS r 
        ON m.id=r.movie_id 
	INNER JOIN role_mapping AS rm 
        ON m.id=rm.movie_id 
	INNER JOIN names AS n 
        ON rm.name_id=n.id
	WHERE category='actress' AND country like '%india%' AND languages like '%hindi%'
	GROUP BY name
	HAVING COUNT(m.id)>=3
    )
SELECT *
FROM ranking
WHERE actress_rank<=5;


/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/

/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT m.title,
CASE 
	 WHEN r.avg_rating > 8 THEN 'Superhit movies'
	 WHEN (r.avg_rating >= 7 AND r.avg_rating <8) THEN 'Hit movies'
	 WHEN (r.avg_rating >= 5 AND r.avg_rating <7) THEN 'One-time-watch movies'
	 WHEN  r.avg_rating < 5 THEN 'Flop movies'
END AS movie_catagory
FROM movie m
INNER JOIN ratings r
INNER JOIN genre g
ON m.id = r.movie_id
AND m.id = g.movie_id
WHERE g.genre='thriller';


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/

-- Segment 4:

-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT 
	 genre
	,ROUND(AVG(duration)) AS avg_duration
	,SUM(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration
	,ROUND(AVG(ROUND(AVG(duration),2)) OVER(ORDER BY genre ROWS 10 PRECEDING),2) AS moving_avg_duration
FROM movie AS m 
INNER JOIN genre AS g 
	ON m.id= g.movie_id
GROUP BY genre
ORDER BY genre;



-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Top 3 Genres based on most number of movies
WITH top_grossing AS(
	WITH top_genre AS(
		SELECT 
			genre 
			,COUNT(movie_id),RANK() OVER(ORDER BY COUNT(movie_id) DESC)
		FROM genre 
		GROUP BY genre 
		LIMIT 3
	)
	SELECT
	g.genre
	,m.year
	,m.title
	,CASE WHEN m.worlwide_gross_income LIKE '$%' THEN  CAST(REPLACE(m.worlwide_gross_income,'$ ','') AS UNSIGNED)
		  WHEN m.worlwide_gross_income LIKE 'INR%' THEN  (CAST(REPLACE(m.worlwide_gross_income,'INR ','') AS UNSIGNED)*0.0125) -- Assumtion 1 $ = 80 INR
	END AS worldwide_gross_income
	,ROW_NUMBER() OVER (PARTITION BY g.genre 
	ORDER BY 
	CASE
	WHEN m.worlwide_gross_income LIKE '$%' THEN  CAST(REPLACE(m.worlwide_gross_income,'$ ','') AS UNSIGNED)
		  WHEN m.worlwide_gross_income LIKE 'INR%' THEN  (CAST(REPLACE(m.worlwide_gross_income,'INR ','') AS UNSIGNED)*0.0125)
	END 
	DESC) AS movie_rank
	FROM movie m
	INNER JOIN genre g
	 ON m.id=g.movie_id
	WHERE m.worlwide_gross_income IS NOT NULL
	 AND g.genre IN (SELECT genre FROM top_genre)
)
SELECT * FROM top_grossing WHERE movie_rank<=5;

-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.
-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH top_production AS(
	SELECT 
		m.production_company
		,COUNT(m.id) AS movie_count
		,RANK() OVER (ORDER BY  COUNT(m.id) DESC) AS prod_comp_rank
	FROM movie m
	INNER JOIN ratings r
		ON m.id=r.movie_id
	WHERE   POSITION("," IN m.languages) > 0
		AND r.median_rating >=8
		AND production_company IS NOT NULL
	GROUP BY m.production_company
)
SELECT * FROM top_production WHERE prod_comp_rank<=2;

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language

-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_summary AS
(
SELECT  
	 n.NAME AS actress_name
	,SUM(total_votes) AS total_votes
	,Count(r.movie_id)   AS movie_count
	,Round(Sum(avg_rating*total_votes)/Sum(total_votes),2) AS actress_avg_rating
FROM  movie  AS m
INNER JOIN ratings  AS r
	ON  m.id=r.movie_id
INNER JOIN role_mapping AS rm
	ON  m.id = rm.movie_id
INNER JOIN names AS n
	ON  rm.name_id = n.id
INNER JOIN GENRE AS g
	ON g.movie_id = m.id
WHERE category = 'ACTRESS'
AND  avg_rating>8
AND genre = "Drama"
GROUP BY   NAME
)
	SELECT   *,
	Rank() OVER(ORDER BY movie_count DESC) AS actress_rank
	FROM     actress_summary LIMIT 3;


/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH next_date_published_summary AS
(
	SELECT  
     d.name_id
	,NAME
	,d.movie_id
	,duration
	,r.avg_rating
	,total_votes
	,m.date_published
	,Lead(date_published,1) OVER(partition BY d.name_id ORDER BY date_published,movie_id ) AS next_date_published
	FROM  director_mapping  AS d
	INNER JOIN names  AS n
		ON  n.id = d.name_id
	INNER JOIN movie AS m
		ON   m.id = d.movie_id
	INNER JOIN ratings AS r
		ON    r.movie_id = m.id 
), 
top_director_summary AS
(
	SELECT *,
	Datediff(next_date_published, date_published) AS date_difference
	FROM   next_date_published_summary 
)
	SELECT   
     name_id AS director_id
	,NAME AS director_name
	,Count(movie_id) AS number_of_movies
	,Round(Avg(date_difference),2) AS avg_inter_movie_days
	,Round(Avg(avg_rating),2) AS avg_rating
	,Sum(total_votes) AS total_votes
	,Min(avg_rating) AS min_rating
	,Max(avg_rating) AS max_rating
	,Sum(duration)  AS total_duration
	FROM     top_director_summary
	GROUP BY director_id
	ORDER BY Count(movie_id) DESC limit 9;