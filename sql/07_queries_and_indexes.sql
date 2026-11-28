-- ============================================================
-- P1: IMPORTANT QUERIES AND INDEXING
-- ============================================================
--
-- Objective:
-- Demonstrate frequently used queries and indexing strategies
-- for improving database query performance.
--
-- Existing indexes:
-- 1. PRIMARY KEY indexes on entity identifiers.
-- 2. uq_screen_start_time (screen_id, start_time)
-- 3. idx_shows_start_screen (start_time, screen_id)
-- 4. Foreign-key supporting indexes.
--
-- The composite indexes support different access patterns.
-- Their usefulness depends on the query and data distribution.
-- ============================================================
-- 1. FIND ALL SHOWS FOR A PARTICULAR SCREEN ON A DATE
SELECT
    show_id,
    movie_id,
    screen_id,
    start_time,
    end_time
FROM
    shows
WHERE
    screen_id = 1
    AND start_time >= '2026-11-28 00:00:00'
    AND start_time < '2026-11-29 00:00:00'
ORDER BY
    start_time;

-- 2. CHECK SEAT AVAILABILITY FOR A PARTICULAR SHOW
SELECT
    seat_id,
    status
FROM
    show_seats
WHERE
    show_id = 1
    AND status = 'AVAILABLE';

-- 3. FIND ALL BOOKINGS MADE BY A USER
SELECT
    *
FROM
    booking
WHERE
    user_id = 1
ORDER BY
    created_at DESC;

-- 4. FIND ALL BOOKINGS FOR A PARTICULAR SHOW
SELECT
    *
FROM
    booking
WHERE
    show_id = 1;

-- 5. VIEW INDEXES ON IMPORTANT TABLES
SHOW INDEX
FROM
    shows;

SHOW INDEX
FROM
    screen;

SHOW INDEX
FROM
    booking;

SHOW INDEX
FROM
    show_seats;

-- 6. ANALYZE THE SHOW LISTING QUERY
EXPLAIN
SELECT
    t.theatre_name,
    m.movie_name,
    sc.screen_name,
    sh.show_id,
    sh.start_time,
    sh.end_time
FROM
    shows sh
    JOIN screen sc ON sh.screen_id = sc.screen_id
    JOIN theatre t ON sc.theatre_id = t.theatre_id
    JOIN movie m ON sh.movie_id = m.movie_id
WHERE
    t.theatre_id = 1
    AND sh.start_time >= '2026-11-28 00:00:00'
    AND sh.start_time < '2026-11-29 00:00:00'
ORDER BY
    sh.start_time;

-- 7. DISPLAY TABLE STATISTICS
ANALYZE TABLE shows;

ANALYZE TABLE screen;

ANALYZE TABLE booking;

ANALYZE TABLE show_seats;

-- ============================================================
-- END OF INDEXING AND QUERY OPTIMIZATION
-- ============================================================
