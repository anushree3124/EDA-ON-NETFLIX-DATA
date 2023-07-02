CREATE DATABASE NETFLIX;

USE NETFLIX;

-- TOTAL NUMBER OF ROWS CONTAINED IN THE BOTH DATASETS:

SELECT COUNT(*) AS TOTAL_ROWS
FROM netflix_originals;

SELECT COUNT(*) AS TOTAL_ROWS
FROM genre_details;

-- CHANGING THE DATE FORMAT (YYYY-MM-DD) WHICH SQL UNDERSTANDS:

ALTER TABLE netflix_originals
ADD COLUMN New_date DATE;

SET SQL_SAFE_UPDATES =0;

UPDATE netflix_originals
SET New_date = str_to_date(Premiere_Date, "%d-%m-%Y");

SELECT Premiere_Date, New_date
FROM netflix_originals;

-- NUMBER OF RECORDS IN EACH GENRE:

SELECT g.Genre, COUNT(*) AS count
FROM netflix_originals n
INNER JOIN genre_details g USING(GenreID)
GROUP BY g.Genre;

-- DIFFERENT LANGUAGES OF MOVIES RELEASED:

SELECT Language, COUNT(Language)
FROM netflix_originals
GROUP BY Language;

-- Average IMDB score for each genre:

SELECT g.Genre, AVG(d.IMDBScore) AS average_score
FROM netflix_originals n
INNER JOIN genre_details g USING(GenreID)
GROUP BY g.Genre;

-- COMPARISON BY MOST POPULAR LANGUAGES:

SELECT Language, COUNT(Language) AS Preferred_Language, ROUND(AVG(Runtime),2) AS Avgtime, ROUND(AVG(IMDBScore),2) AS AvgScore
FROM netflix_originals
GROUP BY Language
HAVING Language >=1
ORDER BY AVG(Runtime) DESC, AVG(IMDBScore) DESC ;

-- IMDB Score RANGE :

SELECT MAX(IMDBScore) AS Maxscore, MIN(IMDBScore) AS Minscore, ROUND(AVG(IMDBScore),2) AS AvgScore
FROM netflix_originals;

-- POPULAR GENRE'S COMPARISON :

SELECT g.Genre, n.IMDBScore
FROM netflix_originals n
INNER JOIN genre_details g USING(GenreID)
WHERE n.IMDBScore = (
    SELECT MAX(IMDBScore)
    FROM netflix_originals
    WHERE GenreID = n.GenreID
)
ORDER BY n.IMDBScore DESC;

-- TOP 10 movies with the highest IMDB scores:

SELECT Title, IMDBScore
FROM netflix_originals
ORDER BY IMDBScore DESC
LIMIT 10;

-- ASSIGNED RANK NETFLIX_ORIGINALS

SELECT title, genreid, IMDBScore, DENSE_RANK() OVER (ORDER BY IMDBScore DESC) AS RNK
FROM netflix_originals;

-- Find the top 5 genres with the most movies:

SELECT g.Genre, COUNT(*) AS movie_count
FROM netflix_originals n
INNER JOIN genre_details g USING(GenreID)
ORDER BY movie_count DESC
LIMIT 5;

-- TOP 1 NETFLIX_ORIGINALS :

SELECT *
FROM  ( SELECT title, genreid, IMDBScore, DENSE_RANK() OVER (ORDER BY IMDBScore DESC) AS RNK
FROM netflix_originals) AS T
WHERE RNK =1;

-- TOTAL NO OF MOVIES BY RELEASE YEAR :

SELECT YEAR(New_date), COUNT(YEAR(New_date)) AS NO_OF_Movies
FROM netflix_originals
GROUP BY YEAR(New_date);

-- Average IMDB score for movies in each genre using a CTE:

WITH genre_avg_scores AS (
    SELECT GenreID, ROUND(AVG(IMDBScore),2) AS average_score
    FROM netflix_originals
    GROUP BY GenreID
)
SELECT g.Genre, ga.average_score
FROM genre_details g
JOIN genre_avg_scores ga USING (GenreID);

