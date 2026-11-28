# BookMyShow – High-Concurrency Booking Engine

## Overview

This project focuses on designing and implementing a relational database for a theatre ticket-booking platform inspired by BookMyShow.

The primary objective is to explore how a database-backed booking system can maintain data consistency while handling concurrent seat reservations, temporary seat holds, payment processing, and high-volume booking requests.

The project emphasizes database design, SQL implementation, concurrency control, and performance optimization rather than developing a complete frontend or backend application.

## Objectives

- Design a normalized relational database following 1NF, 2NF, 3NF, and BCNF principles.
- Model theatres, screens, seats, movies, shows, users, bookings, and payments.
- Prevent double-booking of seats under concurrent requests.
- Explore pessimistic and optimistic locking strategies.
- Demonstrate temporary seat holds using Redis with time-to-live (TTL).
- Demonstrate idempotent payment webhook handling.
- Optimize frequently executed queries using indexes.
- Analyze query execution plans using `EXPLAIN`.
- Explore queue-based approaches for handling sudden spikes in booking requests.

## Technology Stack

| Technology | Purpose |
|---|---|
| MySQL | Relational database and data management |
| Redis | Temporary seat holds and TTL-based expiration |
| SQL | Schema creation, queries, transactions, and constraints |
| Docker | Running the Redis instance locally |
| Git & GitHub | Version control and project collaboration |

## Database Design

The database consists of 12 core tables:

1. `theatre`
2. `screen`
3. `seat`
4. `movie`
5. `shows`
6. `show_seats`
7. `users`
8. `booking`
9. `booking_seats`
10. `payment`
11. `payment_webhook_events`
12. `booking_status_history`

The schema uses primary keys, foreign keys, unique constraints, check constraints, and triggers to maintain data integrity.

Composite keys are used where appropriate, such as `(show_id, seat_id)` in `show_seats`.

## Key Features and Demonstrations

### 1. Database Normalization

- Designed the relational schema using 1NF, 2NF, 3NF, and BCNF principles.
- Separated independent entities to reduce redundant data.
- Used primary and foreign keys to maintain relationships.
- Applied uniqueness constraints to prevent duplicate records.

### 2. Seat Booking and Concurrency Control

- Used MySQL transactions to maintain consistency during booking operations.
- Demonstrated pessimistic locking using `SELECT ... FOR UPDATE`.
- Demonstrated optimistic locking using a version column and conditional updates.
- Prevented conflicting seat reservations through conditional updates.

### 3. Temporary Seat Holds Using Redis

- Used Redis `SET NX EX` to acquire temporary seat holds.
- Used TTL to automatically expire temporary Redis keys.
- Demonstrated that competing users cannot acquire an existing hold.
- Used token-based Lua scripting to safely release holds.

MySQL remains the source of truth for booking and seat status, while Redis manages temporary holds.

### 4. Payment Processing and Idempotency

- Maintained payment records separately from bookings.
- Created a payment webhook events table.
- Used a unique event ID to prevent duplicate webhook event insertion.
- Demonstrated duplicate event rejection using the primary key constraint.

### 5. Indexing and Query Optimization

- Created indexes to support frequently executed queries.
- Inspected existing indexes using `SHOW INDEX`.
- Used `EXPLAIN` to analyze query execution plans.
- Used `ANALYZE TABLE` to refresh table statistics.

### 6. Theatre Show Listing (P2)

Implemented a query to retrieve all shows for a selected theatre and date.

The query returns:

- Theatre name
- Movie name
- Screen name
- Show ID
- Show start time
- Show end time

Date-range filtering is used to support efficient retrieval of shows.

### 7. Queue-Based Burst Handling

Documented a proposed queue-based architecture to handle sudden spikes in booking requests.

The proposed approach uses a message queue between incoming booking requests and booking workers to control database load.

This is a documented scalability enhancement and is not implemented as a production message-queue system.

## Expected Outcome

A well-structured relational database design demonstrating how a high-concurrency ticket-booking system can maintain data consistency, prevent double-booking, manage temporary seat reservations, and process payment events reliably.

The project also demonstrates practical database optimization techniques and explores architectural approaches for handling high-volume booking traffic.

## Scope and Limitations

This is an educational database engineering project inspired by BookMyShow's ticket-booking workflow.

It focuses on MySQL database design, SQL transactions, Redis demonstrations, and performance concepts. It does not implement a complete production booking application, payment gateway integration, or production message queue.

It is not an official BookMyShow product or implementation.