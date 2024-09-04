/* -------------------------------------- Question Set 1 - Easy -------------------------------------- */

/* Q1: Who is the senior most employee based on job title? */
SELECT
	CONCAT(first_name, ' ', last_name) AS full_name,
	title,
	levels
FROM
	public.employee
ORDER BY
	levels DESC;
	
/* Q2: Which countries have the most Invoices? */
SELECT 
	COUNT(*) MOST_BILLING,
	billing_country C
FROM 
	public.invoice
GROUP BY 
	billing_country
ORDER BY 
	MOST_BILLING DESC;

/* Q3: What are the top 3 values of total invoice? */
SELECT total 
FROM invoice
ORDER BY total DESC 
LIMIT 3

/* Q4: Which city has the best customers? 
We would like to throw a promotional Music Festival in the city where we made the most money.
Write a query that returns one city with the highest sum of invoice totals. 
Return both the city name and the sum of all invoice totals. */
SELECT 
	ROUND(SUM(total)::NUMERIC, 2) TOTAL,
	billing_city C
FROM 
	public.invoice JOIN public.customer 
	ON public.customer.customer_id = public.invoice.customer_id
GROUP BY 
	billing_city
ORDER BY 
	TOTAL DESC;
	
/* Q5: Who is the best customer? 
The customer who has spent the most money will be declared the best customer.
Write a query that returns the person who has spent the most money. */
SELECT 
	CONCAT(first_name,' ',last_name) AS FULL_NAME,
	ROUND(SUM(total)::NUMERIC, 2) TOTAL
FROM 
	public.invoice JOIN public.customer 
	ON public.customer.customer_id = public.invoice.customer_id
GROUP BY 
	FULL_NAME
ORDER BY 
	TOTAL DESC

/* -------------------------------------- Question Set 2 - Moderate -------------------------------------- */

/* Q1: Write a query to return the email, first name, last name, and Genre of all Rock Music listeners.
Return your list ordered alphabetically by email starting with A. */

-- METHOD 1
SELECT DISTINCT
    c.first_name,
    c.last_name,
    c.email
FROM 
    customer c
JOIN 
    invoice i ON i.customer_id = c.customer_id
JOIN 
    invoice_line il ON il.invoice_id = i.invoice_id
JOIN 
    track t ON t.track_id = il.track_id
JOIN 
    genre g ON g.genre_id = t.genre_id
WHERE 
    g.name = 'Rock'
ORDER BY 
	email

-- METHOD 2
SELECT DISTINCT 
	c.email,
	c.first_name, 
	c.last_name
FROM 
	customer c
JOIN invoice i ON c.customer_id = i.customer_id
JOIN invoice_line il ON i.invoice_id = il.invoice_id
WHERE track_id IN(
	SELECT track_id FROM track t
	JOIN genre g ON t.genre_id = g.genre_id
	WHERE g.name LIKE 'Rock'
)
ORDER BY email;
/* Q2: Let's invite the artists who have written the most rock music in our dataset.
Write a query that returns the Artist name and total track count of the top 10 rock bands. */
SELECT 
	A.name,
	COUNT(track_id) COUNTS
FROM 
	public.artist A 
	JOIN public.album AL ON A. artist_id = AL.artist_id
	JOIN public.track T ON T.album_id = AL.album_id
	JOIN public.genre G ON G.genre_id = T.genre_id
	
WHERE
	G.name = 'Rock'
GROUP BY 
	A.name
ORDER BY 
	2 DESC
LIMIT
	10;
	
/* Q3: Return all the track names that have a song length longer than the average song length.
Return the Name and Milliseconds for each track. Order by the song length with the longest songs listed first. */
SELECT 
	name,
	milliseconds
FROM public.track
WHERE  milliseconds > (
		SELECT AVG(milliseconds) 
		FROM public.track 
		AS AVG_SONG_LENGTH
		)
ORDER BY 2 DESC;


/* --------------------------------- Question Set 3 - Advanced --------------------------------------*/

/* Q1: Find the amount spent by each customer on artists. 
Write a query to return the customer name, artist name, and total spent. */
WITH BEST_SELLING_ARTIST AS (
  SELECT 
    A.artist_id,
    A.name,
    SUM(IL.unit_price * IL.quantity) AS TOTAL_SALE
  FROM 
    public.invoice_line IL 
    JOIN public.track T ON T.track_id = IL.track_id
    JOIN public.album AL ON AL.album_id = T.album_id
    JOIN public.artist A ON A.artist_id = AL.artist_id
  GROUP BY 1, 2
  ORDER BY 3 DESC
  LIMIT 1
)

SELECT 
  CONCAT(C.first_name, ' ', C.last_name) AS FULL_NAME,
  BSA.name AS ARTIST_NAME,
  SUM(IL.unit_price * IL.quantity) AS TOTAL_SALE
FROM 
  public.customer C
  JOIN public.invoice I ON C.customer_id = I.customer_id
  JOIN public.invoice_line IL ON I.invoice_id = IL.invoice_id
  JOIN public.track T ON T.track_id = IL.track_id
  JOIN public.album AL ON AL.album_id = T.album_id
  JOIN public.artist A ON A.artist_id = AL.artist_id
  JOIN BEST_SELLING_ARTIST BSA ON A.artist_id = BSA.artist_id
GROUP BY 1, 2
ORDER BY 3 DESC;

/* Q2: We want to find out the most popular music Genre for each country. 
We determine the most popular genre as the genre with the highest number of purchases. 
Write a query that returns each country along with the top Genre. 
For countries where the maximum number of purchases is shared, return all Genres. */

-- METHOD 1
WITH TOP_GENRE_BY_COUNTRY AS (
  SELECT
    COUNT(IL.quantity) AS purchases,
    C.country,
    G.name,
    G.genre_id,
    DENSE_RANK() OVER(PARTITION BY C.country ORDER BY COUNT(IL.quantity) DESC) AS row_num
  FROM
    public.customer C
    JOIN public.invoice I ON C.customer_id = I.customer_id
    JOIN public.invoice_line IL ON I.invoice_id = IL.invoice_id
    JOIN public.track T ON T.track_id = IL.track_id
    JOIN public.genre G ON G.genre_id = T.genre_id
  GROUP BY
    C.country, G.name, G.genre_id
)
SELECT
  *
FROM
  TOP_GENRE_BY_COUNTRY
WHERE
  row_num = 1
ORDER BY
  country ASC;

-- METHOD 2
WITH 
    SALE_PER_COUNTRY AS (
        SELECT 
            COUNT(*) AS PURCHASEES_PER_GENRE,
            C.country,
            G.name AS genre_name
        FROM 
            public.customer C
            JOIN public.invoice I ON C.customer_id = I.customer_id
            JOIN public.invoice_line IL ON I.invoice_id = IL.invoice_id
            JOIN public.track T ON T.track_id = IL.track_id
            JOIN public.genre G ON G.genre_id = T.genre_id
        GROUP BY 
            C.country, G.name
    ),

    TOP_GENRE_PER_COUNTRY AS (
        SELECT 
            country,
            MAX(PURCHASEES_PER_GENRE) AS MAX_NO_OF_SALE_PER_GENRE
        FROM 
            SALE_PER_COUNTRY
        GROUP BY
            country
    )

SELECT 
    S.country,
    S.genre_name,
    S.PURCHASEES_PER_GENRE
FROM 
    SALE_PER_COUNTRY S
    JOIN TOP_GENRE_PER_COUNTRY T 
	    ON S.country = T.country 
	    AND S.PURCHASEES_PER_GENRE = T.MAX_NO_OF_SALE_PER_GENRE
ORDER BY 
    S.country;

/* Q3: Write a query that determines the customer who has spent the most on music for each country.
Write a query that returns the country along with the top customer and how much they spent.
For countries where the top amount spent is shared, provide all customers who spent this amount. */

-- METHOD 1
WITH 
	CUSTOMERS_PER_COUNTRY AS (
		SELECT  
			C.first_name,
			C.last_name,
			I.billing_country,
			SUM(I.total) AS TOTAL_SALE,

		ROW_NUMBER() OVER(PARTITION BY I.billing_country ORDER BY SUM(I.total) DESC ) AS ROWNUM

		FROM 
			public.customer C
			JOIN public.invoice I ON I.customer_id = C.customer_id
		GROUP BY 
			C.first_name,
			C.last_name,
			I.billing_country 
			
	)

SELECT 
	CC.* 
FROM 
	CUSTOMERS_PER_COUNTRY CC 
WHERE 
	CC.ROWNUM <= 3
ORDER BY 
    CC.billing_country, 
	CC.ROWNUM;		

-- METHOD 2
WITH RECURSIVE
	CUSTOMERS_PER_COUNTRY AS (
		SELECT  
			C.first_name,
			C.last_name,
			I.billing_country,
			SUM(I.total) AS TOTAL_SALE
		FROM 
			public.customer C
			JOIN public.invoice I ON I.customer_id = C.customer_id
		GROUP BY 
			C.first_name,
			C.last_name,
			I.billing_country 
			
	),

	COUNTRY_MAX_SPENDING AS (
		SELECT 
			billing_country,
			MAX(TOTAL_SALE) AS MAX_SALE
		FROM 
			CUSTOMERS_PER_COUNTRY CC
		GROUP BY 
			CC.billing_country
		
	)
	
SELECT 
	CC.* 
FROM 
	CUSTOMERS_PER_COUNTRY CC 
	JOIN COUNTRY_MAX_SPENDING CM
	ON CM.billing_country = CC.billing_country
WHERE 
	CC.TOTAL_SALE = CM.MAX_SALE
ORDER BY 
    CC.billing_country
			