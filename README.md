# Film Rental Analysis: Customer Behavior, Film Performance, and Inventory

This project focuses on Data Retrieval to retrieve information from the Sakila database using **MySQL**. Sakila database is a well-normalized schema that models a DVD rental store, featuring things like movies, actors, movie-actor relationships, and a central inventory table that links movies, stores, and rentals.

In this project, some of the information that will be retrieved from the database for analysis purposes are as follows:
1. Customer Rental Behavior and Film Analysis
   - Knowing the renters and how much they rented.
   - Knowing the total number of rentals per country.
   - Knowing the total number of movies per category and rating.
   - Knowing the most or least rented movies.

2. Movie Popularity and Performance Analysis
   - Identified the movies that generated the highest and lowest revenue.
   - Compared the number of rentals for each movie with the revenue generated.
   - Analyze whether movies with certain ratings or in certain categories are rented more often or not.

3. Return Inventory Management
   - Identified the movies that are most frequently returned late.
   - Compared the number of rentals of each movie with the frequency of lateness.
   - Identify patterns of whether certain movie categories and ratings are more prone to late returns.

---------------------------------------------------------------------------------------------------------------------------------------

## Customer Rental Behaviour and Film Analysis
### Who are the renters and how much they rented?
```SQL
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
```

So, with the syntax above, we can find out the names of renters as follows:

![image](https://github.com/user-attachments/assets/2309cc38-082e-473e-b3bf-9cffbd3256db)
![image](https://github.com/user-attachments/assets/95edfc4c-47f8-4989-844f-7bed062beb2b)


*With the syntax above, we can know the tenant data such as customer id, name, email, residential address, and the number of movies rented by them for business decisions that can be taken by Sakila company to keep its customers subscribed to movies such as providing discounts or other promos.*

### What is the total number of rentals per country?
```SQL
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
```

So, with the syntax above, we can find out the names of the countries and the number of movie rentals as follows:

![image](https://github.com/user-attachments/assets/1acc045d-62aa-494d-b3aa-b67eab31f8c8)
![image](https://github.com/user-attachments/assets/61471ec2-244b-4f2e-a2c9-d36d0e3e1708)

*With the syntax above, the names of the countries with the highest number of movie rentals can be found. It is useful for Sakila company to pay attention to the countries with the highest number of movie rentals in order to provide discounts/promos or provide a large number and variety of movies if the company's orientation is to pursue revenue. However, if the company's orientation is to add customers to new countries or those with a small number of rentals, it is better to provide fewer movies so that the company does not suffer losses and keep an eye on the rental trend per month.*

### What is the total number of movies per category and rating?
```SQL
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
```

So, with the syntax above, the number of movies based on category and rating can be found as follows:

![image](https://github.com/user-attachments/assets/0e6d2f7f-8971-4022-a0fe-2517d49c38f8)
![image](https://github.com/user-attachments/assets/b8c8631b-857a-4392-911c-6adccb48416e)


### What is the most or least rented movies?
```SQL
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
LIMIT 10;
```

So, the 10 movie titles with the most renters are as follows:

![image](https://github.com/user-attachments/assets/f0096859-9c70-4a98-937e-c4b8576bcfd9)

```SQL
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
ORDER BY category;
```

So, we can find out the least number of movies that were not rented at all as follows:

![image](https://github.com/user-attachments/assets/683fd4c9-df70-4ff2-b601-6ed2d5c8adcd)

---------------------------------------------------------------------------------------------------------------------------------------

## Movie Popularity and Performance Analysis
### which movies generate the highest and lowest revenue?
```SQL
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
LIMIT 10;
```

So, the top 10 highest-grossing movies are as follows:

![image](https://github.com/user-attachments/assets/c0f0befb-57ca-4127-af8e-fa1d4ae47f41)

*The movie that made the highest profit was Telegraph Voyage in the PG-rated music category, which earned a profit of 231.73. In addition, there were 9 other movies that earned high profits such as Sci-Fi, Sports, Drama, Comedy, Foreign, and Documentary themed movies.*


```SQL
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
```

So, the 10 movies that made the lowest profits are as follows:

![image](https://github.com/user-attachments/assets/2ef42bb3-b57e-4dea-b2bb-a81af74e6548)

*New category movie titled Oklahoma Jumanji with PG rating got the lowest profit of 5.94 and there are 9 other movies categorized as Horror, Comedy, Documentary, Music, Classics, Sci-Fi, and also Drama.*

### How does the number of rentals of each movie compare to the revenue generated?
```SQL
SELECT 
	fil.title, 
	COUNT(rent.rental_id) AS total_rentals, 
	SUM(pay.amount) AS total_revenue
FROM 
	film fil
LEFT JOIN 
	inventory inven ON fil.film_id = inven.film_id
LEFT JOIN 
	rental rent ON inven.inventory_id = rent.inventory_id
LEFT JOIN 
	payment pay ON rent.rental_id = pay.rental_id
GROUP BY 
	fil.title
ORDER BY
	total_rentals DESC;
```

![image](https://github.com/user-attachments/assets/e9e74bcc-77a5-4953-a208-2911b64a0642)

### Are movies with certain ratings or in certain categories rented more often or not?
```SQL
SELECT 
	fil.rating, 
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
	fil.rating, cate.name
ORDER BY 
	total_rentals DESC;
----------------------------------------------------------------
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
-----------------------------------------------------------------
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
```

So, movies with a certain rating or category are rented as follows:

![image](https://github.com/user-attachments/assets/5fdf2b6b-f073-4224-83f5-bfe6e33b2cad)
![image](https://github.com/user-attachments/assets/0202fa0c-a93a-46cb-bc73-9c68e4911f84)
![image](https://github.com/user-attachments/assets/37d9203e-aff8-48f2-af99-d57a46c90339)

*Based on the category, the most rented movies are movies with the Sport category, which amounted to 1,179 movies. Based on the rating, the most rented movie is a movie with a PG-13 rating of 3,585 movies. Meanwhile, based on both, the most rented movies are movies categorized as Music with NC-17 rating, which is 375 movies.*

---------------------------------------------------------------------------------------------------------------------------------------
## Return Inventory Management

### Which movie is most often returned late?
```SQL
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
 ```
So the most frequently returned movies are:

![image](https://github.com/user-attachments/assets/fe130c30-e680-4655-8fc0-8c72f9580604)

*The most frequently returned movies are **Butterfly Chocolat**, **Grit Clockwork**, and **Rocketeer Mother** with a frequency of 27 delays.*

### How does the rental amount of each movie compare with the frequency of delays?
```SQL
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
```
The comparison between the loan amount and the overdue amount is as follows:

![image](https://github.com/user-attachments/assets/61a76f43-2637-435d-a4d2-e7411efe6968)

*Run Pacific was the movie with the highest ratio of 10 movies rented, all of which were returned late. There needs to be further investigation into the underlying factors for the delay in the return of these movies.*

### Are certain movie categories and ratings more prone to late returns?
```SQL
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
-----------------------------------------------------------------
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
----------------------------------------------------------------
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
```

So the movies with ratings or categories that are often returned late are:

![image](https://github.com/user-attachments/assets/c0126645-85ab-4e42-89d0-6f3db57db08c)
![image](https://github.com/user-attachments/assets/f6411a56-8023-498a-87c1-3210b112a0a2)
![image](https://github.com/user-attachments/assets/0c605af2-d9a3-402f-9a0f-35230d2152f4)

*Based on the category, films that are often returned late are films categorized as Sports, as many as 648 films. Based on the rating, the movies that are often returned late are movies with a PG-13 rating, which is 1,814 movies. And based on both, the movies that are often late are the drama category with a PG-13 rating.*

























