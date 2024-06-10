# TravelTide-Analytics-Unveiling-Insights-into-Flight-Booking-Patterns-and-User-Behaviors

**Project Description:**
TravelTide, a prominent online booking platform for travel, specializes in offering discounted airplane tickets and hotel accommodations to its users. To optimize its services and enhance user experience, TravelTide seeks to gain deeper insights into its database through SQL analysis. This project aims to uncover valuable information regarding flight booking patterns and user behaviors using SQL queries.

**Question 1: Identifying Loyal Users**
One of the key metrics for TravelTide is user engagement, particularly the identification of loyal users who have booked and completed at least 10 flights. By ordering these users by their user_id, TravelTide can better understand its most active customer base and tailor its services accordingly.

**Question 2: Maximizing Flight Discounts**
To enhance user satisfaction, TravelTide aims to provide maximum value to its customers by offering the best flight discounts. This question focuses on reporting the trip_id of sessions where bookings resulted in a flight reservation with the maximum discount on a given day in May 2022. This analysis helps TravelTide identify peak discount periods and optimize its promotional strategies.

**Question 3: Analyzing Travel Patterns**
Understanding user travel patterns is crucial for TravelTide to improve its recommendation algorithms and personalize user experiences. This question involves calculating the largest window of days between the departure time of a flight and the departure time of the next departing flight taken by users with more than 10 flights booked. By analyzing these patterns, TravelTide can offer tailored travel suggestions and optimize itinerary planning for its users.

**Question 4: Identifying Repeat Travelers**
Repeat customers are valuable assets for TravelTide, indicating satisfaction with the platform's services. This question focuses on finding user_id's of individuals whose origin airport is Boston (BOS) and whose first and last flights were to the same destination. Only users who have flown out of Boston at least twice are considered. By identifying repeat travelers, TravelTide can implement targeted marketing strategies to enhance customer retention and loyalty.

**Conclusion:**
Through comprehensive SQL analysis, this project aims to provide TravelTide with actionable insights into flight booking patterns and user behaviors. By leveraging the findings from these queries, TravelTide can optimize its services, enhance user satisfaction, and strengthen its position as a leading online travel booking platform.

**Data Dictionary**

**Table 1-- users: user demographic information**

user_id: unique user ID (key, int)

birthdate: user date of birth (date)

gender: user gender (text)

married: user marriage status (bool)

has_children: whether or not the user has children (bool)

home_country: user’s resident country (text)

home_city: user’s resident city (text)

home_airport: user’s preferred hometown airport (text)

home_airport_lat: geographical north-south position of home airport (numeric)

home_airport_lon: geographical east-west position of home airport (numeric)

sign_up_date: date of TravelTide account creation (date)

**Table 2-- sessions: information about individual browsing sessions (note: only sessions with at least 2 clicks are included)**

session_id: unique browsing session ID (key, text)

user_id: the user ID (foreign key, int)

trip_id: ID mapped to flight and hotel bookings (foreign key, text)

session_start: time of browsing session start (timestamp)

session_end: time of browsing session end (timestamp)

flight_discount: whether or not flight discount was offered (bool)

hotel_discount: whether or not hotel discount was offered (bool)

flight_discount_amount: percentage off base fare (numeric)

hotel_discount_amount: percentage off base night rate (numeric)

flight_booked: whether or not flight was booked (bool)

hotel_booked: whether or not hotel was booked (bool)

page_clicks: number of page clicks during browsing session (int)

cancellation: whether or not the purpose of the session was to cancel a trip (bool)

**Table 3-- flights: information about purchased flights**

trip_id: unique trip ID (key, text)

origin_airport: user’s home airport (text)

destination: destination city (text)

destination_airport: airport in destination city (text)

seats: number of seats booked (int)

return_flight_booked: whether or not a return flight was booked (bool)

departure_time: time of departure from origin airport (timestamp)

return_time: time of return to origin airport (timestamp)

checked_bags: number of checked bags (int)

trip_airline: airline taking user from origin to destination (text)

destination_airport_lat: geographical north-south position of destination airport (numeric)

destination_airport_lon: geographical east-west position of destination airport (numeric)

base_fare_usd: pre-discount price of airfare (numeric)

**Table 4-- hotels: information about purchased hotel stays**

trip_id: unique trip ID (key, text)

hotel_name: hotel brand name (text)

rooms: number of rooms booked with hotel (int)

check_in_time: time user hotel stay begins (timestamp)

check_out_time: time user hotel stay ends (timestamp)

hotel_per_room_usd: pre discount price of hotel stay (numeric)
