WITH app_store as (SELECT name, rating, (ROUND(rating::numeric*2)/2)*2 +1 AS app_lifespan, price, 
					(CASE WHEN (price::money < 1::money) THEN 10000::money
					 ELSE (price::money * 10000) END) AS purchase_a
				   FROM app_store_apps
				   WHERE rating IS NOT NULL
				   ORDER BY purchase_a DESC),


play_store as (SELECT DISTINCT (name), rating, (ROUND(rating::numeric*2)/2)*2 +1 AS play_lifespan, price, install_count,
					(CASE WHEN (price::money < 1::money) THEN 10000::money
					 ELSE (price::money * 10000) END) AS purchase_p
					FROM play_store_apps
					WHERE rating IS NOT NULL
					ORDER BY purchase_p DESC)

SELECT name, app_store.rating, play_store.rating, app_lifespan, play_lifespan, install_count,
	(play_lifespan + app_lifespan) AS total_lifespan,
	(purchase_p + purchase_a) AS total_purchase,
	(30000::money * (play_lifespan + app_lifespan))-
	 	(purchase_p + purchase_a)-
		(CASE WHEN play_lifespan > app_lifespan THEN 12000::money * play_lifespan
			ELSE 12000::money * app_lifespan END)
		AS profit
FROM app_store
INNER JOIN play_store
USING (name)
ORDER BY profit DESC;
	
