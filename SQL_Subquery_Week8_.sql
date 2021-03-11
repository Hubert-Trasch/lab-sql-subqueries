-- How many copies of the film Hunchback Impossible exist in the inventory system?


select * from film
where title='Hunchback Impossible';


select count(film_id) from inventory
where film_id in (select film_id from film where title='Hunchback Impossible');

-- List all films whose length is longer than the average of all the films.

select avg(length) from film;


select length,film_id from film
where length>(select avg(length) from film);

-- Use subqueries to display all actors who appear in the film Alone Trip.

select last_name from actor
where actor_id in (select actor_id from film where title='Alone Trip');

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.


select title, film_id from film f
join film_category cat
using(film_id)
where category_id in (select category_id from category where name='Family');

-- Get name and email from customers from Canada using subqueries. Do the same with joins. Note that to create a join, you will have to identify the correct tables with their primary keys and foreign keys, that will help you get the relevant information.


select first_name,last_name,email from customer
where customer_id in (select ID from customer_list where country='Canada');


-- Which are films starred by the most prolific actor? Most prolific actor is defined as the actor that has acted in the most number of films. First you will have to find the most prolific actor and then use that actor_id to find the different films that he/she starred.




WITH CTE as (
SELECT count(film.film_id)
			, actor_id
FROM film_actor
INNER JOIN film on film_actor.film_id = film.film_id
GROUP BY actor_id
ORDER BY count(film_id) DESC
LIMIT 1)
SELECT film_id, actor_id
FROM film_actor
WHERE actor_id IN (SELECT actor_id FROM CTE);


-- Films rented by most profitable customer. You can use the customer table and payment table to find the most profitable customer ie the customer that has made the largest sum of payments

select customer_id,avg(sum(amount) from payment
group by customer_id
order by avg(amount) desc;


-- Customers who spent more than the average payments.

with cte1 as(select customer_id,sum(amount) as sum_amount from payment
group by customer_id)
select customer_id,sum(amount) from payment
where sum(amount)>(select avg(sum_amount) from cte1);


WITH CTE AS(
SELECT distinct customer_id
		, sum(amount) OVER(partition by customer_id) as SumPayment
FROM payment
ORDER BY SumPayment DESC)
SELECT customer_id, SumPayment
FROM CTE
WHERE SumPayment > (SELECT avg(amount)
from payment) 
ORDER BY SumPayment desc;



