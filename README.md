# BookMyShow – Database Design & High-Concurrency Booking System

## Overview

This project focuses on designing and implementing a scalable relational database for a theatre ticket-booking platform inspired by BookMyShow.

The primary objective is to design a normalized database schema and explore strategies for handling concurrent seat bookings, temporary seat holds, payment processing, and high-volume booking requests.

The project focuses on database design, SQL implementation, concurrency management, and performance optimization rather than building a complete frontend or backend application.

## Objectives

- Design a normalized relational database following 1NF, 2NF, 3NF, and BCNF.
- Model theatres, screens, seats, movies, shows, users, bookings, and payments.
- Prevent double booking of seats under concurrent requests.
- Explore pessimistic and optimistic locking strategies.
- Implement temporary seat holds using Redis with time-to-live (TTL).
- Design idempotent payment webhook handling.
- Optimize queries using appropriate indexing.
- Perform load and concurrency testing.
- Explore queue-based approaches for handling sudden spikes in booking requests.

## Technology Stack

| Technology   | Purpose                                                 |
| ------------ | ------------------------------------------------------- |
| MySQL        | Relational database and data management                 |
| Redis        | Temporary seat holds and TTL-based expiration           |
| SQL          | Schema creation, queries, transactions, and constraints |
| Git & GitHub | Version control and project collaboration               |

## Core Functional Requirements

### 1. Theatre and Show Management

- Maintain theatre, screen, and seat information.
- Maintain movie details and scheduled shows.
- Retrieve all shows for a given theatre and date, along with their timings.

### 2. Seat Booking

- Track seat availability for individual shows.
- Support multiple-seat bookings.
- Prevent multiple users from booking the same seat.
- Implement temporary seat holds with automatic expiry.

### 3. Payment Processing

- Maintain payment attempts and their statuses.
- Support payment retries.
- Prevent duplicate payment webhook processing through idempotency.

### 4. Concurrency and Performance

- Explore pessimistic and optimistic locking.
- Handle simultaneous booking requests safely.
- Optimize frequently executed queries using indexes.
- Evaluate system behavior under high concurrency and burst traffic.

## Database Design

The initial database design includes the following entities:

1. Theatre
2. Screen
3. Seat
4. Movie
5. Show
6. Show_Seats
7. Users
8. Booking
9. Booking_Seats
10. Payment
11. Payment_Webhook_Events
12. Booking_Status_History

The schema will be refined during implementation to ensure data integrity, normalization, and safe concurrent operations.

## Project Structure

```text
high_concurrency_booking_engine/
│
├── README.md
│
├── sql/
│   ├── 01_create_database.sql
│   ├── 02_create_tables.sql
│   ├── 03_insert_sample_data.sql
│   ├── 04_indexes.sql
│   └── 05_queries.sql
│
├── redis/
│   └── seat_hold_demo.md
│
├── tests/
│   └── concurrency_testing.md
│
└── docs/
    ├── database_schema.md
    ├── normalization.md
    └── locking_strategy.md
```

*The project structure will evolve as implementation progresses.*

## Implementation Plan

- [ ] Design database entities and relationships.
- [ ] Create MySQL database and tables.
- [ ] Insert sample records.
- [ ] Validate normalization (1NF, 2NF, 3NF, BCNF).
- [ ] Implement show listing queries.
- [ ] Implement seat availability and booking logic.
- [ ] Explore pessimistic vs optimistic locking.
- [ ] Demonstrate Redis-based temporary seat holds.
- [ ] Design idempotent payment webhook processing.
- [ ] Add indexes and optimize queries.
- [ ] Perform concurrency and load testing.
- [ ] Document design decisions and results.

## Expected Outcome

A well-structured relational database design that demonstrates how a high-concurrency ticket-booking system can maintain data consistency, prevent double bookings, manage temporary seat reservations, and process payments reliably.

---

**Note:** This is an educational database engineering project inspired by BookMyShow's ticket-booking workflow. It is not an official BookMyShow product or implementation.
