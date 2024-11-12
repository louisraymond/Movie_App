# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...



Security Consideration:

SQL Injection Prevention: Using parameterized queries (?) ensures that user input doesn't lead to SQL injection vulnerabilities.


- Most of my time was spent on the test suite


Optimized Query Chain: By chaining ActiveRecord scopes, we build a single, optimized SQL query that fetches only the necessary data in the desired order.
Reduced Ruby-Level Processing: All heavy lifting is delegated to the database, ensuring that Rails handles minimal processing, leading to faster response times.



A. Database-Level Aggregation
Performing calculations like averages directly in the database offers significant efficiency advantages:

Optimized Computation:

Databases like PostgreSQL and MySQL are optimized for aggregate functions (AVG, SUM, etc.), ensuring rapid computations even on large datasets.
Reduced Data Transfer:

Only the necessary data (e.g., sorted movies with their average ratings) is fetched from the database, minimizing the amount of data transferred to the application layer.
Leveraging Indexes:

Proper indexing (e.g., on reviews.movie_id) can further accelerate join and aggregation operations.
B. ActiveRecord Scopes and Query Chaining
Single SQL Query:

By chaining scopes and using ActiveRecord's query interface, we construct a single, efficient SQL query that handles searching and sorting in one go.
Avoiding N+1 Queries:

Using includes ensures that associated records are loaded efficiently, preventing the infamous N+1 query problem where multiple queries are made for associated data.
Lazy Loading:

ActiveRecord only executes the query when the data is actually needed (e.g., when iterating over @movies), ensuring optimal performance.
C. Minimal Ruby-Level Processing
Delegating to the Database:

By offloading heavy computations to the database, the Rails application remains lightweight, handling only the rendering and minimal logic.
Efficient Memory Usage:

Since the database handles sorting and aggregation, the Rails application doesn't need to load all records into memory to process them, which is crucial for scalability.


I'm going to make models for Actor, Director and possibly Filming location. Why?
 - Later on I need to provide a search functionality for Actors
 - It's conceivable that the same thing could be desired for Directors an Filming Locations
 - Making a separate model might help down the line with making sure data is consistent, down the line. (protection against the same person being referenced, but not being a match within the system (imagine: "The Rock" and "Dwayne Johnson". They should be in the same movies.)). Protection against typos etc.
 - I'm not going to do this for location if I run out of time

A change I made is allowing many actors to belong to a movie. Although the data provided only seems to contain the leading actor, it's possible that we actually want more than this.


# What this App Can Do

	•	Browse Movies: View a comprehensive list of movies with details including title, year, director, actors, filming locations, average rating, and number of reviews.
	•	Search by Actor: Easily search for movies featuring a specific actor.
	•	Sort by Average Rating: Sort movies in ascending or descending order based on their average star ratings.
