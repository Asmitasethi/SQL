# 1. Write a SQL Query to find the list of female actors. Return actor first name, last name and Role.

use moviedb;

select act_fname,act_lname,role
From actors
Join movie_cast ON actors.act_id = movie_cast.act_id
where act_gender = 'F';


# 2. SQL query to find the director who directed a movie that casted a role for "eyes wide shut'. Return director first_name,last_name and movie_title.

use moviedb;

select dir_fname, dir_lname, mov_title
from director
Natural Join movie_direction
Natural Join movie
Natural Join movie_cast
where role is not  NULL AND mov_title = 'Eyes Wide Shut';



# 3.SQL query to find who directed a movie that casted a role as "seamn Maguire" Return director first name , last nmae and movie tite.

use moviedb;
Select dir_fname ,dir_lname, mov_title
From director
Join movie_direction ON director.dir_id = movie_direction.dir_id
Join movie ON movie_direction.mov_id = movie.mov_id
Join movie_cast ON movie_cast.mov_id = movie.mov_id
Where role = 'Sean Maguire';


# 4.SQL query for who havent directed in any movie between 1990 and 2000. (Begin and end value are  included). Return director first_end value are included).Return director first name, last name and release year

use moviedb;

Select dir_fname,dir_lname,mov_title,mov_year
From director
Join movie_direction ON director.dir_id = movie_direction.dir_id
Join movie ON movie_direction.mov_id = movie.mov_id
Where mov_year NOT BETWEEN 1990 and 2000;
 
 
 
 # 5. SQL query to find the director with number of generes movie.
 
 use moviedb;
 select dir_fname, dir_lname,gen_title,count(gen_title)
 From director
 Natural join movie_direction
 Natural join movie_genres
 Natural join genres
 Group by dir_fname,dir_lname,gen_title
 Order by dir_fname,dir_lname;


# 6. SQL query to find the movie year & genres whose release country is UK.

use moviedb;

Select mov_title,mov_year,gen_title
From movie
Natural join movie_genres
Natural join genres
where mov_rel_country = 'UK';


# 7. Sql query to find the movies with year,genres and name of the director.

use moviedb;
Select mov_title,mov_year,gen_title,dir_fname,dir_lname
From movie
Natural join movie_genres
Natural join genres
Natural join movie_direction
Natural join director
order by mov_dt_rel;

# 8. SQL query to find the movie released after 1st jan 2000.

use moviedb;

Select movie.mov_title,mov_year,mov_dt_rel,mov_time,dir_fname,dir_lname
From movie
Join movie_direction
ON movie.mov_id = movie_direction.mov_id
Join director On movie_direction.dir_id=director.dir_id
where mov_dt_rel >01/01/2000
Order By mov_dt_rel desc;  

# 9. SQL query to compute average time and count of the movie for each genre.

use moviedb;
select gen_title,avg(mov_time),count(gen_title) 
from movie
natural join movie_genres
natural join genres
Group by gen_title;


# 10. SQL query to find movies with highest duration .

use moviedb;
select mov_title,mov_year, dir_fname,dir_lname,act_fname,act_lname,role
from movie
Natural join movie_direction 
Natural join movie_cast
Natural join director
Natural join actor
where mov_time = (select max(mov_time) From movie);
