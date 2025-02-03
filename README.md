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

*To answer the question, it is necessary to pull the customer id, customer name, and email data from the customer table as well as the data on the number of movies rented by aggregating the rental id from the rental table. the two tables are joined with the LEFT JOIN function which means the customer table is the reference. The rental id aggregation is grouped into the customer id table to find out the number of movie rentals from a customer id. The order is arranged from the customer who has the most number of rentals.*

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

*To answer the question above, retrieve the country data from the country table and aggregate the rental id from the rental table through other tables with the LEFT JOIN function so that the country table is the reference. After that, I grouped the country column and sorted it based on the aggregation column in descending order.*

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

*To answer the question above, it is necessary to retrieve category name data from the category table, rating from the movie table, and aggregate movie id from the movie table. Join the category and movie tables using LEFT JOIN through the movie_category table. To find out the number per category and rating using grouping to the category and rating columns sorted alphabetically in the category column*

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

*To answer the question above, it is necessary to retrieve movie title data from the movie table, category name from the category table, and aggregate the rental id from the rental table through the inventory table, and movie_category using LEFT JOIN. Then grouping the aggregation into the title and category columns to find out the number of renters of each movie title and sorted from the highest number of renters.*

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

*Untuk menjawab pertanyaan di atas, diperlukan mengambil data judul dari tabel film dan mengaggregasikan data amount dari tabel payment melalui tabel inventory dan rental dengan LEFT JOIN. Kemudian hasil aggregasi digrouping ke kolom judul dan diurutkan berdasarkan revenue dari yang terbesar.*

Jadi, 10 film yang menghasilkan keuntungan tertinggi sebagai berikut:

![image](https://github.com/user-attachments/assets/c0f0befb-57ca-4127-af8e-fa1d4ae47f41)


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

Jadi, 10 film yang menghasilkan keuntungan terendah sebagai berikut:

![image](https://github.com/user-attachments/assets/2ef42bb3-b57e-4dea-b2bb-a81af74e6548)


















