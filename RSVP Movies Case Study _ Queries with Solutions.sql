USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/



-- Segment 1:


-- Q1. Find the total number of rows in each table of the schema?
-- Type your code below:
SELECT 'movie' AS table_name, COUNT(*) AS total_rows FROM movie
UNION
SELECT 'genre', COUNT(*) FROM genre
UNION
SELECT 'director_mapping', COUNT(*) FROM director_mapping
UNION
SELECT 'role_mapping', COUNT(*) FROM role_mapping
UNION
SELECT 'names', COUNT(*) FROM names
UNION
SELECT 'ratings', COUNT(*) FROM ratings;








-- Q2. Which columns in the movie table have null values?
-- Type your code below:
 
    
SELECT column_name
FROM (
    SELECT 'id' AS column_name, COUNT(*) AS null_count FROM movie WHERE id IS NULL
    UNION ALL
		SELECT 'title', COUNT(*) FROM movie WHERE title IS NULL
    UNION ALL
		SELECT 'year', COUNT(*) FROM movie WHERE year IS NULL
    UNION ALL
		SELECT 'date_published', COUNT(*) FROM movie WHERE date_published IS NULL
    UNION ALL
		SELECT 'duration', COUNT(*) FROM movie WHERE duration IS NULL
    UNION ALL
		SELECT 'country', COUNT(*) FROM movie WHERE country IS NULL
    UNION ALL
		SELECT 'worlwide_gross_income', COUNT(*) FROM movie WHERE worlwide_gross_income IS NULL
    UNION ALL
		SELECT 'languages', COUNT(*) FROM movie WHERE languages IS NULL
    UNION ALL
		SELECT 'production_company', COUNT(*) FROM movie WHERE production_company IS NULL
) AS NULL_COLUMNS
WHERE null_count > 0;

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
-- total number of movies released each year
SELECT year, COUNT(*) AS number_of_movies
FROM movie
GROUP BY year
ORDER BY year;

-- total number of movies released month wise
SELECT MONTH(date_published) AS month_num, COUNT(*) AS number_of_movies
FROM movie
GROUP BY month_num
ORDER BY month_num;



/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(*) AS movies_produced
FROM movie
WHERE (country LIKE '%India%' OR country LIKE '%USA%') AND year = 2019;



/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:
-- List of unique genres using DISTINCT keyword
SELECT DISTINCT genre FROM genre;
-- List of unique genres using GROUP BY clause
SELECT genre FROM genre
GROUP BY genre;

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:
SELECT genre
FROM genre
GROUP BY genre
ORDER BY COUNT(*) DESC
LIMIT 1;
-- Drama genre has the highest number of movies produced overall i.e. 4285.

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

SELECT COUNT(*) AS single_genre_movies
FROM (
    SELECT movie_id, COUNT(*) AS genre_count
    FROM genre
    GROUP BY movie_id
    HAVING genre_count = 1
) AS single_genre;
-- The number of movies with only one genre is 3289







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

SELECT g.genre, round(AVG(m.duration),2) AS avg_duration
FROM genre g
JOIN movie m ON g.movie_id = m.id
GROUP BY g.genre
ORDER BY avg_duration DESC;







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

WITH Genre_rank AS (
SELECT genre, COUNT(*) AS movie_count, RANK() OVER (ORDER BY COUNT(*) DESC) AS genre_rank
FROM genre
GROUP BY genre
) SELECT * FROM Genre_rank WHERE genre ="Thriller";
-- The movies produced with genre 'Thriller' have the 3rd rank







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
SELECT MIN(avg_rating) AS min_avg_rating, MAX(avg_rating) AS max_avg_rating,
       MIN(total_votes) AS min_total_votes, MAX(total_votes) AS max_total_votes,
       MIN(median_rating) AS min_median_rating, MAX(median_rating) AS max_median_rating
FROM ratings;





    

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
-- Keep in mind that multiple movies can be at the same rank. You only have to find out the top 10 movies (if there are more than one movies at the 10th place, consider them all.)


WITH MovieRank AS (
    SELECT m.title, r.avg_rating, RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank, DENSE_RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_dense_rank
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
)
SELECT *
FROM MovieRank
WHERE movie_rank <= 10;




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

SELECT median_rating, COUNT(*) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY median_rating;








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

WITH HitMovies AS (
    SELECT m.production_company, COUNT(*) AS movie_count, 
           RANK() OVER (ORDER BY COUNT(*) DESC) AS prod_company_rank
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    WHERE r.avg_rating > 8 AND m.production_company IS NOT NULL
    GROUP BY m.production_company
)
SELECT *
FROM HitMovies
WHERE prod_company_rank = 1;








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
SELECT g.genre, COUNT(*) AS movie_count
FROM movie m
JOIN genre g ON m.id = g.movie_id
JOIN ratings r ON m.id = r.movie_id
WHERE m.country LIKE '%USA%' AND YEAR(m.date_published) = 2017 AND MONTH(m.date_published) = 3 AND r.total_votes > 1000
GROUP BY g.genre
ORDER BY movie_count DESC;
-- The genre 'Drama' has maximum number of movies i.e. 24 which were released in 2017 in USA with more than 1000 votes







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


SELECT m.title, r.avg_rating, g.genre
FROM movie m
JOIN genre g ON m.id = g.movie_id
JOIN ratings r ON m.id = r.movie_id
WHERE m.title LIKE 'The %' AND r.avg_rating > 8;






-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.
-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(*) AS movie_count
FROM movie m
JOIN ratings r ON m.id = r.movie_id
WHERE m.date_published BETWEEN '2018-04-01' AND '2019-04-01' AND r.median_rating = 8;
-- The number of movies released between 1 April 2018 and 1 April 2019 with median rating 8 is 361






-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:
WITH german_movies_vote_count AS (
	SELECT SUM(rat.total_votes) AS total_votes_to_German_movies
	FROM movie AS mov JOIN ratings AS rat ON mov.id = rat.movie_id
    WHERE mov.languages LIKE '%German%'),
    italian_movies_vote_count AS (
	SELECT SUM(rat.total_votes) as total_votes_to_Italian_movies
    FROM movie AS mov JOIN ratings AS rat ON mov.id = rat.movie_id
    WHERE mov.languages LIKE '%Italian%')
SELECT 	total_votes_to_German_movies, total_votes_to_Italian_movies
FROM german_movies_vote_count JOIN italian_movies_vote_count;
-- total_votes_to_German_movies, 	total_votes_to_Italian_movies
-- '4421525', 						'2559540'
-- Clearly, There are 1861985 (4421525 - 2559540) more votes to German movies than Italian movies.


-- Performing the above for all countries
WITH Votes AS (
    SELECT country, SUM(r.total_votes) AS total_votes
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    WHERE m.country IN (SELECT SUBSTRING_INDEX(SUBSTRING_INDEX(country, ',', 1), ',', -1) AS part FROM movie)
    GROUP BY country
    order by total_votes desc
)
SELECT * FROM Votes;






-- Answer is Yes

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
	SUM(CASE WHEN name IS NULL THEN 1 ELSE 0 END) 				AS name_nulls,
    SUM(CASE WHEN height IS NULL THEN 1 ELSE 0 END)				AS height_nulls,
    SUM(CASE WHEN date_of_birth IS NULL THEN 1 ELSE 0 END)		AS date_of_birth_nulls,
    SUM(CASE WHEN known_for_movies IS NULL THEN 1 ELSE 0 END)	AS known_for_movies_nulls
FROM names;
-- name_nulls	height_nulls	date_of_birth_nulls	known_for_movies_nulls
-- 0			17335			13431				15226



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


WITH TopGenres AS (
    SELECT genre, COUNT(*) AS movie_count
    FROM genre g
    JOIN ratings r ON g.movie_id = r.movie_id
    WHERE r.avg_rating > 8
    GROUP BY genre
    ORDER BY movie_count DESC
    LIMIT 3
),
TopDirectors AS (
    SELECT dm.name_id, COUNT(*) AS movie_count
    FROM director_mapping dm
    JOIN genre g ON dm.movie_id = g.movie_id
    JOIN ratings r ON g.movie_id = r.movie_id
    WHERE r.avg_rating > 8 AND g.genre IN (SELECT genre FROM TopGenres)
    GROUP BY dm.name_id
    ORDER BY movie_count DESC
    LIMIT 3
)
SELECT n.name AS director_name, td.movie_count
FROM TopDirectors td
JOIN names n ON td.name_id = n.id;






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


SELECT nam.name AS actor_name, COUNT(*) AS movie_count
FROM names AS nam
JOIN role_mapping AS rol ON (nam.id = rol.name_id)
JOIN ratings AS rat USING (movie_id)
WHERE rat.median_rating >=8
GROUP BY actor_name
ORDER BY movie_count DESC
LIMIT 2;
-- actor_name	movie_count
-- Mammootty	8
-- Mohanlal		5





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

WITH ProductionVotes AS (
    SELECT m.production_company, SUM(r.total_votes) AS vote_count
    FROM movie m
    JOIN ratings r ON m.id = r.movie_id
    WHERE m.production_company IS NOT NULL
    GROUP BY m.production_company
)
SELECT production_company, vote_count, RANK() OVER (ORDER BY vote_count DESC) AS prod_comp_rank
FROM ProductionVotes
Limit 3;






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

WITH ActorRatings AS (
    SELECT rm.name_id, ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) AS actor_avg_rating, COUNT(*) AS movie_count, SUM(r.total_votes) AS total_votes
    FROM role_mapping rm
    JOIN movie m ON rm.movie_id = m.id
    JOIN ratings r ON m.id = r.movie_id
    WHERE m.country LIKE '%India%' AND rm.category = 'Actor'
    GROUP BY rm.name_id
    HAVING movie_count >= 5
)
SELECT n.name AS actor_name, ar.total_votes, ar.movie_count, ar.actor_avg_rating, RANK() OVER (ORDER BY ar.actor_avg_rating DESC, ar.total_votes DESC) AS actor_rank
FROM ActorRatings ar
JOIN names n ON ar.name_id = n.id
ORDER BY actor_rank;



-- Top actor is Vijay Sethupathi

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

WITH ActressRatings AS (
    SELECT rm.name_id, ROUND(SUM(r.avg_rating*r.total_votes)/SUM(r.total_votes),2) AS actress_avg_rating, COUNT(*) AS movie_count, SUM(r.total_votes) AS total_votes
    FROM role_mapping rm
    JOIN movie m ON rm.movie_id = m.id
    JOIN ratings r ON m.id = r.movie_id
    WHERE m.country LIKE '%India%' AND m.languages LIKE '%Hindi%' AND rm.category='actress'
    GROUP BY rm.name_id
    HAVING movie_count >= 3
)
SELECT n.name AS actress_name, ar.total_votes, ar.movie_count, ar.actress_avg_rating, RANK() OVER (ORDER BY ar.actress_avg_rating DESC, ar.total_votes DESC) AS actress_rank
FROM ActressRatings ar
JOIN names n ON ar.name_id = n.id
ORDER BY actress_rank
LIMIT 5;





/* Taapsee Pannu tops with average rating 7.74. 
Now let us divide all the thriller movies in the following categories and find out their numbers.*/


/* Q24. Consider thriller movies having at least 25,000 votes. Classify them according to their average ratings in
   the following categories:  

			Rating > 8: Superhit
			Rating between 7 and 8: Hit
			Rating between 5 and 7: One-time-watch
			Rating < 5: Flop
	
    Note: Sort the output by average ratings (desc).
--------------------------------------------------------------------------------------------*/
/* Output format:
+---------------+-------------------+
| movie_name	|	movie_category	|
+---------------+-------------------+
|	Get Out		|			Hit		|
|		.		|			.		|
|		.		|			.		|
+---------------+-------------------+*/

-- Type your code below:
SELECT m.title as movie_name,
       CASE
           WHEN r.avg_rating > 8 THEN 'Superhit'
           WHEN r.avg_rating BETWEEN 7 AND 8 THEN 'Hit'
           WHEN r.avg_rating BETWEEN 5 AND 7 THEN 'One-time-watch'
           ELSE 'Flop' -- ELSE case takes care of r.avg_rating < 5
       END AS movie_category
FROM movie m
JOIN ratings r ON m.id = r.movie_id
JOIN genre g ON m.id = g.movie_id
WHERE g.genre = 'thriller' AND r.total_votes >= 25000
ORDER BY r.avg_rating DESC;









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


WITH GenreDuration AS (
    SELECT g.genre, round(AVG(m.duration),2) AS avg_duration
    FROM genre g
    JOIN movie m ON g.movie_id = m.id
    GROUP BY g.genre
)
SELECT 	genre, avg_duration, 
		ROUND(SUM(avg_duration) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING),2) AS running_total_duration,
		ROUND(AVG(avg_duration) OVER (ORDER BY genre ROWS UNBOUNDED PRECEDING),2) AS moving_avg_duration
FROM GenreDuration;






-- Round is good to have and not a must have; Same thing applies to sorting


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

WITH TopGenres AS (
    SELECT genre, COUNT(*) AS genre_count
    FROM genre
    GROUP BY genre
    ORDER BY genre_count DESC
    LIMIT 3
),
TopMovies AS (
    SELECT 	g.genre, m.year, m.title AS movie_name, 
			CASE
				-- remove $ and INR symbols and convert all values into dollars considering $1=INR84
                WHEN worlwide_gross_income LIKE '$%' THEN REPLACE(worlwide_gross_income,'$','')
				WHEN worlwide_gross_income LIKE 'INR%'THEN ROUND((REPLACE(worlwide_gross_income,'INR',''))/84)
				ELSE worlwide_gross_income
			END AS worldwide_gross_income,
			RANK() OVER (PARTITION BY m.year, g.genre ORDER BY m.worlwide_gross_income DESC) AS movie_rank
    FROM movie m
    JOIN genre g ON m.id = g.movie_id
    WHERE g.genre IN (SELECT genre FROM TopGenres)
)
SELECT *
FROM TopMovies
WHERE movie_rank <= 5;


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

SELECT	mov.production_company, count(mov.title) AS movie_count,
		ROW_NUMBER() OVER(ORDER BY count(mov.title) DESC) AS prod_comp_rank
FROM movie AS mov
JOIN ratings AS rat ON (rat.movie_id = mov.id)
WHERE mov.production_company IS NOT NULL AND POSITION(',' IN languages)>0 AND rat.median_rating >=8
GROUP BY mov.production_company
LIMIT 2;
# production_company		movie_count		prod_company_rank
# Star Cinema				7				1
# Twentieth Century Fox		4				2






-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on the number of Super Hit movies (Superhit movie: average rating of movie > 8) in 'drama' genre?

-- Note: Consider only superhit movies to calculate the actress average ratings.
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes
-- should act as the tie breaker. If number of votes are same, sort alphabetically by actress name.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	  actress_avg_rating |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.6000		     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/

-- Type your code below:
WITH SuperHitMovies AS (
    SELECT n.name AS actress_name, COUNT(*) AS movie_count, SUM(r.total_votes) AS total_votes, AVG(r.avg_rating) AS actress_avg_rating
    FROM role_mapping rm
    JOIN ratings r ON rm.movie_id = r.movie_id
    JOIN genre g ON rm.movie_id = g.movie_id
    JOIN names n ON rm.name_id = n.id
    WHERE r.avg_rating > 8 AND g.genre = 'drama' and rm.category='actress'
    GROUP BY actress_name
),
RankedActresses AS (
    SELECT actress_name, total_votes, movie_count, actress_avg_rating, RANK() OVER (ORDER BY actress_avg_rating DESC, total_votes DESC, actress_name ASC) AS actress_rank
    FROM SuperHitMovies
)
SELECT ra.actress_name, ra.total_votes, ra.movie_count, ra.actress_avg_rating, ra.actress_rank
FROM RankedActresses ra
WHERE ra.actress_rank <= 3;







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
SELECT
	dir.name_id AS director_id,
    nam.name AS director_name,
    COUNT(dir.movie_id) AS number_of_movies,
    ROUND(DATEDIFF(MAX(mov.date_published), MIN(mov.date_published)) / (COUNT(dir.movie_id) - 1)) AS avg_inter_movie_days,
	ROUND(SUM(rat.avg_rating*rat.total_votes)/SUM(rat.total_votes),2) AS avg_rating,
    SUM(rat.total_votes) AS total_votes,
    MIN(rat.avg_rating) AS min_rating,
    MAX(rat.avg_rating) AS max_rating,
    SUM(mov.duration) AS total_duration
FROM director_mapping AS dir
JOIN names AS nam ON (dir.name_id = nam.id)
JOIN ratings AS rat USING (movie_id)
JOIN movie AS mov ON (mov.id = rat.movie_id)
GROUP BY director_id, director_name
ORDER BY number_of_movies DESC
LIMIT 9;

-- nm1777967	A.L. Vijay			5	177	5.65	1754	3.7		6.9		613
-- nm2096009	Andrew Jones		5	191	3.04	1989	2.7		3.2		432
-- nm0831321	Chris Stokes		4	198	4.32	3664	4.0		4.6		352
-- nm2691863	Justin Price		4	315	4.93	5343	3.0		5.8		346
-- nm0425364	Jesse V. Johnson	4	299	6.10	14778	4.2		6.5		383
-- nm0001752	Steven Soderbergh	4	254	6.77	171684	6.2		7.0		401
-- nm0814469	Sion Sono			4	331	6.31	2972	5.4		6.4		502
-- nm6356309	Özgür Bakar			4	112	3.96	1092	3.1		4.9		374
-- nm0515005	Sam Liu				4	260	6.32	28557	5.8		6.7		312



