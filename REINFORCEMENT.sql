--  IMDB DATASET - REINFORCEMENT SQL PROJECT 

use imdb;
show tables;

# 1. Count the total number of records in each table of the database. 

select ' TABLE_NAME', 'COUNT_OF_RECORDS '
union
select ' director_mapping', count(*)
from director_mapping
union
select ' genre', count(*) 
from genre
union
select ' movie', count(*)
from movie
union
select ' names', count(*)
from names
union
select ' ratings', count(*)
from ratings
union
select ' role_mapping', count(*)
from role_mapping
limit 1,8;


# 2. Identify which columns in the movie table contain null values.

select 'COLUMN_NAME', 'NULL_COUNT'
union
select 'id',count(*) as count
from movie
where id is null
union
select 'title', count(*) 
from movie
where title is null
union
select 'year', count(*) 
from movie
where year is null
union
select 'date_published', count(*) 
from movie
where date_published is null
union
select 'duration', count(*) 
from movie
where duration is null
union
select 'country', count(*) 
from movie
where country is null
union
select 'worlwide_gross_income', count(*) 
from movie
where worlwide_gross_income is null
union
select 'languages', count(*) 
from movie
where languages is null
union
select 'production_company', count(*) 
from movie
where production_company is null 
limit 6,12;


# 3. Determine the total number of movies released each year, and analyze how the trend changes month-wise.

select year, count(title) as count_of_movies_year
from movie
group by year
order by year; 
-- as year progress the movie count reduces.

-- month analysis
select year, monthname(date_published) as month_analysis, count(title) as count_of_movies_year
from movie
group by year, month_analysis
order by year,month_analysis;

-- year 2017, september records highest count with 327 movies and july records lowest with 188 movies
-- year 2018, january records highest count with 302 movies and july records lowest with 167 movies
-- year 2019, march records highest count with 241 movies and december records lowest with 16 movies

 
# 4. How many movies were produced in either the USA or India in the year 2019?
 
 select  year, count(title) as count_of_movies
 from movie
 where country in ('USA','India') AND year = 2019;
 
 -- usa, 2019 has 592 movies
 -- India, 2019 with 295 movies
 
  
# 5. List the unique genres in the dataset, and count how many movies belong exclusively to one genre.

select distinct genre from genre;
select genre.genre, count(genre.movie_id) as count_movies
from genre
inner join ( select movie_id
from genre
 group by movie_id
 having count(genre)=1) as exclusive_genre
 on genre.movie_id=exclusive_genre.movie_id
 group by genre.genre
 order by count_movies desc;


# 6. Which genre has the highest total number of movies produced? 

select genre, count(movie_id) as total_no_of_movies
from genre
group by genre
order by total_no_of_movies desc
limit 1;


# 7. Calculate the average movie duration for each genre. 

select genre.genre, avg(movie.duration) as avg_duration
from genre
left join movie
on movie.id=genre.movie_id
group by genre.genre;


# 8. Identify actors or actresses who have appeared in more than three movies with an average rating below 5.

select names.name,role_mapping.category, count(role_mapping.movie_id) as count_of_movies, round(avg(ratings.avg_rating),3) as average_rating
from names
inner join role_mapping
on names.id=role_mapping.name_id
inner join ratings
on ratings.movie_id=role_mapping.movie_id
where ratings.avg_rating <5
group by names.name,role_mapping.category
having count(role_mapping.movie_id)>3
order by average_rating;

 
# 9. Find the minimum and maximum values for each column in the ratings table, excluding the movie_id column. 

select max(avg_rating) as max_avg_rating, max(total_votes) as max_totalvotes, max(median_rating) as max_median_rating, min(avg_rating) as min_avg_rating, min(total_votes) as min_totalvotes, min(median_rating) as min_median_rating
from ratings;


# 10. Which are the top 10 movies based on their average rating? 

select movie.title, ratings.avg_rating
from ratings
inner join movie
on movie.id=ratings.movie_id
order by avg_rating desc
limit 10;


# 11. Summarize the ratings table by grouping movies based on their median ratings. 
select count(movie_id) as grouped_count_movie_id, median_rating
from ratings
group by median_rating
order by grouped_count_movie_id desc;

-- 2257 total-movies have highest median rating of 7.


# 12. How many movies, released in March 2017 in the USA within a specific genre, had more than 1,000 votes?
 select genre.genre, COUNT(movie.id) as count_genre_specific
from movie
inner join genre
on movie.id=genre.movie_id
inner join ratings
on movie.id=ratings.movie_id
where movie.year='2017' AND movie.country LIKE '%USA%' AND monthname(DATE_PUBLISHED) LIKE'%March%' AND ratings.total_votes>1000
group by genre.genre
order by count_genre_specific;

 
 
# 13. Find movies from each genre that begin with the word “The” and have an average rating greater than 8. 

select movie.title, group_concat(genre.genre separator ',') as genre, ratings.avg_rating
from movie
inner join genre
on movie.id=genre.movie_id
inner join ratings
on movie.id=ratings.movie_id
where movie.title like 'The%' AND ratings.avg_rating>8
group by genre.genre,  movie.title, ratings.avg_rating
order by avg_rating asc;


# 14. Of the movies released between April 1, 2018, and April 1, 2019, how many received a median rating of 8? 

select  count(movie.title) as movie_count, ratings.median_rating
from movie
inner join ratings
on movie.id=ratings.movie_id
where date_published between '2018-04-01' AND '2019-04-01' AND ratings.median_rating=8;


# 15. Do German movies receive more votes on average than Italian movies? 

select 'German' as languages, avg(german_votes.total_votes) as average_votes
from( select movie.languages, ratings.total_votes
from movie
 join ratings
on movie.id=ratings.movie_id
where movie.languages like '%German%') as german_votes
union
select 'Italian' as languages, avg(Italian_votes.total_votes) as average_votes
from( select movie.languages, ratings.total_votes
from movie
 join ratings
on movie.id=ratings.movie_id
where movie.languages LIKE '%Italian%') as Italian_votes;


# 16. Identify the columns in the names table that contain null values. 

select 'names_table', count(*) as column_with_null
union
select 'id',count(*) as count
from names
where id is null
union
select 'name',count(*) as count
from names
where name is null
union
select 'date_of_birth',count(*) as count
from names
where date_of_birth is null
union
select 'height',count(*) as count
from names
where height is null
union
select 'known_for_movies',count(*) as count
from names
where known_for_movies is null
limit 3,8;


# 17. Who are the top two actors whose movies have a median rating of 8 or higher? 

select role_mapping.category,names.name, ratings.median_rating
from ratings
inner join role_mapping
on ratings.movie_id=role_mapping.movie_id
inner join names
on role_mapping.name_id=names.id 
where ratings.median_rating>=8
order by ratings.median_rating desc
limit 2 ;


# 18. Which are the top three production companies based on the total number of votes their movies received? 

select movie.production_company,sum(ratings.total_votes) as totalvote
from movie
inner join ratings
on movie.id=ratings.movie_id
group by movie.production_company
order by totalvote desc
limit 3;


# 19. How many directors have worked on more than three movies? 

select count(name) as director_count
from(select names.name, count(director_mapping.name_id) as no_of_movies
from names
inner join director_mapping
on names.id=director_mapping.name_id
group by names.name
having count(director_mapping.name_id) >3
order by count(director_mapping.name_id)) as directors;


# 20. Calculate the average height of actors and actresses separately. 

select role_mapping.category, avg( names.height) as average_height
from role_mapping
inner join names
on names.id=role_mapping.name_id
group by category; 


# 21. List the 10 oldest movies in the dataset along with their title, country, and director. 

select movie.title, names.name as director_name, movie.country
from movie
inner join director_mapping
on movie.id=director_mapping.movie_id
inner join names 
on names.id=director_mapping.name_id
order by date_published
limit 10;


# 22. List the top 5 movies with the highest total votes, along with their genres. 

select movie.title,ratings.total_votes, group_concat(genre.genre separator ',') as genre
from movie
inner join ratings
on movie.id=ratings.movie_id
inner join genre
on movie.id= genre.movie_id
group by movie.title,ratings.total_votes
order by total_votes desc
limit 5;

# 23. Identify the movie with the longest duration, along with its genre and production company.

select movie.title, movie.duration, movie.production_company, group_concat(genre.genre) as genre
from movie
inner join genre
on movie.id=genre.movie_id
group by movie.title, movie.duration, movie.production_company
order by duration desc
limit 1;


# 24. Determine the total number of votes for each movie released in 2018. 

select movie.title, movie.year, sum(ratings.total_votes) as total_votes
from ratings
inner join movie
on movie.id= ratings.movie_id
where movie.year='2018'
group by movie.title
order by total_votes ;


# 25. What is the most common language in which movies were produced?

select distinct languages,count(languages) as count
from movie
group by languages
order by count(languages) desc
limit 1;

