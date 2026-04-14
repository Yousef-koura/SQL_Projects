SELECT * FROM movies;
SELECT industry, title FROM movies;
SELECT * FROM movies where industry = "Bollywood";
SELECT COUNT(*)  FROM movies WHERE industry="Hollywood" ;
SELECT DISTINCT industry FROM movies;
SELECT * FROM movies where title LIKE "%THOR%";
SELECT * FROM movies where studio = "";
SELECT * FROM movies WHERE imdb_rating >=9;
SELECT * FROM movies WHERE imdb_rating between 6 AND 8;
SELECT * FROM movies WHERE release_year IN (2021,2022);
SELECT * FROM movies WHERE imdb_rating IS NULL;
SELECT * FROM movies ORDER BY imdb_rating DESC;
SELECT * FROM movies ORDER BY imdb_rating DESC LIMIT 5;
SELECT * FROM movies ORDER BY imdb_rating DESC LIMIT 5 OFFSET 1;
SELECT MAX(imdb_rating) as Max, MIN(imdb_rating) as MIN, ROUND(AVG(imdb_rating),2) as Average FROM movies;
SELECT industry, COUNT(*) AS count, ROUND(AVG(imdb_rating),1) AS average FROM movies GROUP BY industry ORDER BY count DESC;
SELECT studio, COUNT(*) AS count, ROUND(AVG(imdb_rating),1) AS average FROM movies WHERE studio !="" GROUP BY studio ORDER BY average DESC;
SELECT release_year, COUNT(*) as count FROM movies GROUP BY release_year HAVING count>2 ORDER BY count DESC;
SELECT * , YEAR(curdate()) - birth_year as age from actors;
select * from financials;
select *, if(currency = "USD", revenue*77, revenue) as revenue_INR from financials;
select distinct unit from financials;
select *,
	case
		when unit = "thousands" then round(revenue/1000,1)
        when unit = "billions" then round(revenue*1000,1)
		else revenue
    end as revenue_ml
from financials; 

select 
	m.movie_id, title, budget, revenue, currency, unit
from movies m left join financials f on m.movie_id = f.movie_id
union
select 
	f.movie_id, title, budget, revenue, currency, unit
from movies m left join financials f on m.movie_id = f.movie_id