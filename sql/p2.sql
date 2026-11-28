
-- ============================================================
-- P2: Retrieve all movie shows at a given theatre on a given date
-- ============================================================
--
-- Objective:
-- Display all movie shows scheduled at a particular theatre
-- on a specified date, along with their timings.
--
-- Tables used:
-- 1. shows   - Stores show timings, movie IDs and screen IDs.
-- 2. screen  - Identifies the screen where each show takes place.
-- 3. theatre - Identifies the theatre to which each screen belongs.
-- 4. movie   - Stores movie details.
--
-- JOIN operations:
-- The shows table is joined with screen using screen_id.
-- The screen table is joined with theatre using theatre_id.
-- The shows table is joined with movie using movie_id.
-- These joins retrieve the theatre, screen and movie details
-- associated with each show.
--
-- Filtering:
-- theatre_id = 1 selects the required theatre.
-- The start_time range selects shows occurring on the
-- specified date (28 November 2026).
--
-- A date range is used instead of DATE(start_time) so that
-- an index on start_time can be used more effectively.
--
-- Sorting:
-- Results are ordered by start_time in ascending order,
-- displaying the earliest show first.
--
-- Expected output:
-- Theatre name, movie name, screen name, show ID,
-- show start time and show end time.
--
-- ============================================================

SELECT
    t.theatre_name,
    m.movie_name,
    sc.screen_name,
    sh.show_id,
    sh.start_time,
    sh.end_time
FROM shows sh
JOIN screen sc
    ON sh.screen_id = sc.screen_id
JOIN theatre t
    ON sc.theatre_id = t.theatre_id
JOIN movie m
    ON sh.movie_id = m.movie_id
WHERE t.theatre_id = 1
  AND sh.start_time >= '2026-11-28 00:00:00'
  AND sh.start_time < '2026-11-29 00:00:00'
ORDER BY sh.start_time;