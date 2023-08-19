-- Check the number of unique apps in both tables
SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore;

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM appleStore_description;

SELECT id, COUNT(*)
FROM AppleStore
GROUP BY id
HAVING COUNT(*) > 1
 
SELECT id, COUNT(*)
FROM appleStore_description
GROUP BY id
HAVING COUNT(*) >1

-- Check any missing values in key fields
SELECT COUNT(*) AS MissingValues
FROM AppleStore
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL

SELECT COUNT(*) AS MissingValues
FROM appleStore_description
WHERE app_desc IS NULL 

-- Find out the number of apps per genre
SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore
GROUP BY prime_genre
ORDER  BY NumApps DESC

-- Get an overview of apps ratings
SELECT MIN(user_rating) AS MinRating,
        MAX(user_rating) AS MaxRating,
        AVG(user_rating) AS AvgRating
FROM AppleStore

-- Determine whether paid apps have higher ratings then free apps
SELECT CASE 
    WHEN price > 0 THEN 'Paid'
    ELSE 'Free'
    END AS App_Type,
    AVG(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY 
CASE 
    WHEN price > 0 THEN 'Paid'
    ELSE 'Free'
    END

-- check if apps have more support languages have higher ratings
SELECT CASE 
        WHEN lang_num < 10 THEN '< 10 languagues'
        WHEN lang_num BETWEEN 10 AND 30 THEN  '10-30 languages'
        ELSE '> 30 languages'
        END AS language_bucket,
        AVG(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY 
CASE 
    WHEN lang_num < 10 THEN '< 10 languagues'
    WHEN lang_num BETWEEN 10 AND 30 THEN  '10-30 languages'
    ELSE '> 30 languages'
    END 
ORDER BY 2 DESC

-- check genres with low ratings
SELECT TOP (10)prime_genre,
        AVG(user_rating) AS Avg_Rating
FROM AppleStore
GROUP BY prime_genre
ORDER BY 2 ASC

-- Check if there is correlation between the length of the app description and user rating
SELECT CASE 
        WHEN LEN(b.app_desc) < 500 THEN 'Short'
        WHEN LEN(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
        ELSE 'Long'
        END AS description_length_bucket,
        AVG(user_rating) AS Avg_Rating
FROM AppleStore AS a
JOIN appleStore_description AS b
ON a.id = b.id
GROUP BY 
CASE 
    WHEN LEN(b.app_desc) < 500 THEN 'Short'
    WHEN LEN(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
    ELSE 'Long'
    END
ORDER BY 2 DESC

-- Check top rated apps for each genre
SELECT prime_genre, 
        track_name, 
        user_rating
FROM (
    SELECT prime_genre,
            track_name,
            user_rating,
            RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS rank
    FROM AppleStore
) AS a 
WHERE a.rank = 1

-- Paid apps have better ratings
-- Apps supportting between 10 to 30 languages have better ratings, it is not about quantity of languages. It is about to choose the right languages for the app
-- Finance and book apps have low ratings. It presents the user needs not fully met.
-- These sectors would be the market opportunity because it developers can create better quality apps in those categories than current apps.
-- Correlation between description length and ratings. Customers are appriciated the description for apps , so they can undestand of app features and capbilities, increase the satisfication of users.
-- New app should aim for an average rating above 3.5
-- Games and Entertainment have high competition, howerver these sectors have a high user demand.
