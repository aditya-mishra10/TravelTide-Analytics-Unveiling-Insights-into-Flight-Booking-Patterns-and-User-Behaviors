/*
Question #1:
return users who have booked and completed at least 10 flights, ordered by user_id.

Expected column names: `user_id`
*/

-- q1 solution:

SELECT 
    s.user_id
FROM 
    sessions AS s
JOIN 
    flights AS f ON s.trip_id = f.trip_id
WHERE 
    s.cancellation = false
GROUP BY 
    s.user_id
HAVING 
    COUNT(f.trip_id) >= 10
ORDER BY 
    s.user_id;




/*

Question #2: 
Write a solution to report the trip_id of sessions where:

1. session resulted in a booked flight
2. booking occurred in May, 2022
3. booking has the maximum flight discount on that respective day.

If in one day there are multiple such transactions, return all of them.

Expected column names: `trip_id`

*/

-- q2 solution:

WITH max_discount_per_day AS (
  SELECT
  	DATE_trunc('day', session_start) AS booking_date,
  	MAX(flight_discount_amount) AS max_discount
  FROM sessions
  	WHERE flight_booked = TRUE
  	AND DATE_TRUNC('month', session_start) = '2022-05-01'::date
  GROUP BY DATE_TRUNC('day', session_start)
)
	SELECT
  	s.trip_id
	FROM sessions AS s
	INNER JOIN max_discount_per_day AS m 
  	ON DATE_trunc('day', s.session_start) = m.booking_date
	WHERE s.flight_booked = TRUE
  AND 
  	s.flight_discount_amount = m.max_discount
ORDER BY
	s.trip_id;




/*
Question #3: 
Write a solution that will, for each user_id of users with greater than 10 flights, 
find out the largest window of days between 
the departure time of a flight and the departure time 
of the next departing flight taken by the user.

Expected column names: `user_id`, `biggest_window`

*/

-- q3 solution:

WITH ranked_flight AS (
  SELECT
  	s.user_id,
  	f.departure_time,
  	LEAD(f.departure_time) OVER(PARTITION BY s.user_id ORDER BY f.departure_time) AS next_departure_time,
  	ROW_NUMBER() OVER(PARTITION BY s.user_id ORDER BY f.departure_time) AS flight_sequence
  FROM sessions AS s
INNER JOIN flights AS f ON s.trip_id = f.trip_id AND s.flight_booked = TRUE
),
max_flight_window AS (
  SELECT
  user_id,
  MAX(next_departure_time - departure_time) AS max_flight_window
FROM ranked_flight
  WHERE next_departure_time IS NOT NULL
  AND user_id IN ( SELECT 
    s.user_id
FROM 
    sessions AS s
INNER JOIN
		flights AS f on s.trip_id = f.trip_id
GROUP BY 
    s.user_id
HAVING 
    COUNT(user_id) > 10
ORDER BY 
    s.user_id)
  GROUP BY user_id
)
SELECT
	user_id,
  ROUND(EXTRACT(DAY FROM max_flight_window) + EXTRACT(HOUR FROM max_flight_window) / 24) AS biggest_window
FROM max_flight_window
 GROUP BY user_id, biggest_window
 ORDER BY user_id;




/*
Question #4: 
Find the user_id’s of people whose origin airport is Boston (BOS) 
and whose first and last flight were to the same destination. 
Only include people who have flown out of Boston at least twice.

Expected column names: user_id
*/

-- q4 solution:

WITH boston_user AS (
  SELECT distinct
  	s.user_id,
  	f.trip_id,
  	f.destination_airport,
  	f.departure_time,
  	DENSE_RANK() OVER(PARTITION BY s.user_id ORDER BY f.departure_time) AS trip_rank
  FROM flights AS f
  	INNER JOIN sessions AS s
  	ON f.trip_id = s.trip_id
  	WHERE f.origin_airport = 'BOS' AND s.cancellation = false
),
  first_destination AS (   --to find the first flight
    SELECT
    	user_id,
    	destination_airport AS first_destination
    FROM boston_user
    WHERE trip_rank = 1
),
    last_rank AS (
      SELECT
      	user_id,
      	MAX(trip_rank) AS last_rank
      FROM boston_user
      GROUP BY user_id
),
    last_destination AS (   --to find the last flight
      SELECT
      	bu.user_id,
      	destination_airport AS last_destination
      FROM boston_user AS bu
      INNER JOIN last_rank AS lr
        ON bu.user_id = lr.user_id
    		AND bu.trip_rank = lr.last_rank
),
    first_last_destination AS (   --to find the first and last flight were to the same destination
      SELECT
      	fd.user_id,
      	first_destination,
      	last_destination
      FROM first_destination AS fd
      INNER JOIN last_destination AS ld
      	ON fd.user_id = ld.user_id
    		AND fd.first_destination = ld.last_destination
),
    more_than_2_flights AS (    --to find people who have flown out of Boston at least twice
      SELECT
      	user_id
      FROM boston_user
      GROUP BY user_id
      HAVING COUNT(trip_id) >= 2
)
      
   		SELECT
      	fld.user_id
      FROM first_last_destination AS fld
      INNER JOIN more_than_2_flights AS mt2f
      	ON fld.user_id = mt2f.user_id
      	ORDER BY fld.user_id;



