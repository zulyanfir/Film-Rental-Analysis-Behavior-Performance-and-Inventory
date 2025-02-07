# (Case 1) Customer Rental Behavior and Film Analysis:

# Knowing the renters and how much they rent.
SELECT 
	cust.customer_id, 
	cust.first_name, 
	cust.last_name, 
	cust.email,
	addr.address,
	addr.district,
	cty.city,
	ctr.country,
	COUNT(rent.rental_id) AS total_rentals
FROM 
	customer cust
LEFT JOIN 
	rental rent ON rent.customer_id = cust.customer_id
LEFT JOIN 
	address addr ON addr.address_id = cust.address_id
LEFT JOIN 
	city cty ON cty.city_id = addr.city_id 
LEFT JOIN 
	country ctr ON ctr.country_id = cty.country_id 
GROUP BY 
	cust.customer_id 
ORDER BY total_rentals DESC;

## Knowing the total number of rentals per country.
SELECT 
	country,
	COUNT(rental_id) AS total_rentals
FROM 
	country ctr
LEFT JOIN 
	city cty ON cty.country_id = ctr.country_id 
LEFT JOIN 
	address addr ON addr.city_id = cty.city_id 
LEFT JOIN 
	customer cust ON cust.address_id = addr.address_id 
LEFT JOIN 
	rental rent ON rent.customer_id = cust.customer_id
GROUP BY 	
	country
ORDER BY total_rentals DESC;

# Know the total number of movies per category and rating.
SELECT 
	cate.name AS category, 
	fil.rating, 
	COUNT(fil.film_id) AS total_films
FROM 
	film fil
LEFT JOIN 
	film_category fil_cate ON fil.film_id = fil_cate.film_id
LEFT JOIN 
	category cate ON fil_cate.category_id = cate.category_id
GROUP BY 
	category, fil.rating
ORDER BY category;

# Knowing the most and least rented movies
SELECT 
	fil.title,
	cate.name AS category,
	COUNT(rent.rental_id) AS total_rentals
FROM 
	film fil
LEFT JOIN 
	inventory inven ON fil.film_id = inven.film_id
LEFT JOIN 
	rental rent ON inven.inventory_id = rent.inventory_id
LEFT JOIN 
	film_category fil_cate ON fil_cate.film_id = fil.film_id 
LEFT JOIN
	category cate ON cate.category_id = fil_cate.category_id
GROUP BY 
	fil.title, category
ORDER BY 
	total_rentals DESC
LIMIT 10;  # Ordered by most rented movies

SELECT 
	fil.title, 
	cate.name as category,
	COUNT(rent.rental_id) AS total_rentals
FROM 
	film fil
LEFT JOIN 
	inventory inven ON fil.film_id = inven.film_id
LEFT JOIN 
	rental rent ON inven.inventory_id = rent.inventory_id
left join 
	film_category fil_cate ON fil_cate.film_id = fil.film_id 
left join
	category cate ON cate.category_id = fil_cate.category_id 
GROUP BY 
	fil.title, cate.name
HAVING total_rentals = 0
ORDER BY category;  # Ordered by least rented movies
	

# (Case 2) Film Popularity and Performance Analysis

# Identifying the movies that generated the highest and lowest revenue.
SELECT 
	fil.title,
	cate.name AS category,
	fil.rating,
	SUM(pay.amount) AS total_revenue
FROM 
	film fil
LEFT JOIN 
	inventory inven ON fil.film_id = inven.film_id
LEFT JOIN 
	rental rent ON inven.inventory_id = rent.inventory_id
LEFT JOIN 
	payment pay ON rent.rental_id = pay.rental_id
LEFT JOIN  
	film_category fil_cate ON fil_cate.film_id = fil.film_id 
LEFT JOIN  
	category cate ON cate.category_id = fil_cate.category_id 
GROUP BY 
	fil.title, category, rating
ORDER BY 
	total_revenue DESC
LIMIT 10; # Ordered by highest revenue

SELECT 
	fil.title,
	cate.name AS category,
	fil.rating,
	SUM(pay.amount) AS total_revenue
FROM 
	film fil
LEFT JOIN 
	inventory inven ON fil.film_id = inven.film_id
LEFT JOIN 
	rental rent ON inven.inventory_id = rent.inventory_id
LEFT JOIN 
	payment pay ON rent.rental_id = pay.rental_id
LEFT JOIN  
	film_category fil_cate ON fil_cate.film_id = fil.film_id 
LEFT JOIN  
	category cate ON cate.category_id = fil_cate.category_id 
WHERE 
	pay.amount IS NOT NULL 
GROUP BY 
	fil.title, category, rating
ORDER BY 
	total_revenue ASC
LIMIT 10;

# Comparing the number of rentals of each movie with the revenue generated. 
SELECT 
	fil.title, 
	COUNT(rent.rental_id) AS total_rentals, 
	SUM(pay.amount) AS total_revenue
FROM 
	film fil
left JOIN 
	inventory inven ON fil.film_id = inven.film_id
left JOIN 
	rental rent ON inven.inventory_id = rent.inventory_id
left JOIN 
	payment pay ON rent.rental_id = pay.rental_id
GROUP BY 
	fil.title
ORDER BY total_rentals DESC;

/*
Analyze whether movies with a certain rating or 
in a certain category are rented more often or not.
 */ 
SELECT 
	cate.name AS category,
	fil.rating, 
	COUNT(rent.rental_id) AS total_rentals
FROM 
	film fil
LEFT JOIN 
	film_category fil_cate ON fil.film_id = fil_cate.film_id
LEFT JOIN 
	category cate ON fil_cate.category_id = cate.category_id
LEFT JOIN 
	inventory inven ON fil.film_id = inven.film_id
LEFT JOIN 	
	rental rent ON inven.inventory_id = rent.inventory_id
GROUP BY 
	cate.name, fil.rating
ORDER BY 
	total_rentals DESC;

SELECT 
	fil.rating, 
	COUNT(rent.rental_id) AS total_rentals
FROM 
	film fil
LEFT JOIN 
	film_category fil_cate ON fil.film_id = fil_cate.film_id
LEFT JOIN 
	inventory inven ON fil.film_id = inven.film_id
LEFT JOIN 	
	rental rent ON inven.inventory_id = rent.inventory_id
GROUP BY 
	fil.rating
ORDER BY 
	total_rentals DESC;

SELECT 
	cate.name AS category,
	COUNT(rent.rental_id) AS total_rentals
FROM 
	film fil
LEFT JOIN 
	film_category fil_cate ON fil.film_id = fil_cate.film_id
LEFT JOIN 
	category cate ON fil_cate.category_id = cate.category_id
LEFT JOIN 
	inventory inven ON fil.film_id = inven.film_id
LEFT JOIN 	
	rental rent ON inven.inventory_id = rent.inventory_id
GROUP BY 
	cate.name
ORDER BY 
	total_rentals DESC;

# (Case 3) Return Inventory Management:
select * from film;
select * from inventory i;
select * from rental r;

# Identify the movies that are most often returned late.
SELECT 
	fil.title, 
	COUNT(rent.rental_id) AS late_returns
FROM 
	film fil
LEFT JOIN 
	inventory inven ON fil.film_id = inven.film_id
LEFT JOIN 
	rental rent ON inven.inventory_id = rent.inventory_id
WHERE 
	rent.return_date > DATE_ADD(rent.rental_date, INTERVAL fil.rental_duration DAY)
GROUP BY 
	fil.title
ORDER BY 
	late_returns DESC;

# Comparing the number of rentals of each movie with the frequency of delays.
SELECT 
	title,
	total_rentals,
	late_returns,
	(late_returns / total_rentals) AS ratio
FROM
	(SELECT 
		fil.title, 
		COUNT(rent.rental_id) AS total_rentals,
	    SUM(
	    	CASE 
		    	WHEN rent.return_date > DATE_ADD(rent.rental_date, INTERVAL fil.rental_duration DAY) THEN 1 
		    	ELSE 0 
		    END) AS late_returns
	FROM 
		film fil
	LEFT JOIN 
		inventory inven ON fil.film_id = inven.film_id
	LEFT JOIN 
		rental rent ON inven.inventory_id = rent.inventory_id
	GROUP BY 
		fil.title) AS subquery
ORDER BY  
	ratio DESC;

/*
 Identify patterns of whether certain movie categories 
 and ratings are more prone to late returns.
 */ 
SELECT 
	cate.name AS category, 
	fil.rating, 
	COUNT(rent.rental_id) AS late_returns
FROM 
	film fil
LEFT JOIN 
	film_category fil_cate ON fil.film_id = fil_cate.film_id
LEFT JOIN 
	category cate ON fil_cate.category_id = cate.category_id
LEFT JOIN 
	inventory inven ON fil.film_id = inven.film_id
LEFT JOIN 
	rental rent ON inven.inventory_id = rent.inventory_id
WHERE 
	rent.return_date > DATE_ADD(rent.rental_date, 
	INTERVAL fil.rental_duration DAY)
GROUP BY 
	cate.name, fil.rating
ORDER BY 
	late_returns DESC;


SELECT 
	cate.name AS category, 
	COUNT(rent.rental_id) AS late_returns
FROM 
	film fil
LEFT JOIN 
	film_category fil_cate ON fil.film_id = fil_cate.film_id
LEFT JOIN 
	category cate ON fil_cate.category_id = cate.category_id
LEFT JOIN 
	inventory inven ON fil.film_id = inven.film_id
LEFT JOIN 
	rental rent ON inven.inventory_id = rent.inventory_id
WHERE 
	rent.return_date > DATE_ADD(rent.rental_date, 
	INTERVAL fil.rental_duration DAY)
GROUP BY 
	cate.name
ORDER BY 
	late_returns DESC;


SELECT 
	fil.rating, 
	COUNT(rent.rental_id) AS late_returns
FROM 
	film fil
LEFT JOIN 
	film_category fil_cate ON fil.film_id = fil_cate.film_id
LEFT JOIN 
	category cate ON fil_cate.category_id = cate.category_id
LEFT JOIN 
	inventory inven ON fil.film_id = inven.film_id
LEFT JOIN 
	rental rent ON inven.inventory_id = rent.inventory_id
WHERE 
	rent.return_date > DATE_ADD(rent.rental_date, 
	INTERVAL fil.rental_duration DAY)
GROUP BY 
	fil.rating
ORDER BY 
	late_returns DESC;








