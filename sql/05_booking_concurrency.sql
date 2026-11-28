-- ============================================================
-- P1: BOOKING CONCURRENCY AND SEAT LOCKING
-- ============================================================
--
-- Objective:
-- Demonstrate how MySQL transactions and row-level locking
-- prevent two users from booking the same seat.
--
-- Strategy:
-- Pessimistic locking using SELECT ... FOR UPDATE.
--
-- IMPORTANT:
-- This is a demonstration workflow. Use fresh sample records
-- or reset the test seat before executing it again.
-- ============================================================
-- STEP 1: Start a transaction.
START TRANSACTION;

-- STEP 2: Lock the selected show-seat row.
-- Another transaction attempting to lock this row must wait.
SELECT
    *
FROM
    show_seats
WHERE
    show_id = 1
    AND seat_id = 2 FOR
UPDATE;

-- STEP 3: Reserve the seat only if it is AVAILABLE.
UPDATE show_seats
SET
    status = 'HELD',
    held_by = 1,
    hold_expires_at = NOW () + INTERVAL 120 SECOND
WHERE
    show_id = 1
    AND seat_id = 2
    AND status = 'AVAILABLE';

-- STEP 4: Check whether exactly one row was updated.
SELECT
    ROW_COUNT () AS rows_updated;

-- If rows_updated = 1, continue with the booking.
-- If rows_updated = 0, the seat is unavailable.
-- STEP 5: Commit only after the required booking operations
-- have succeeded. Otherwise, use ROLLBACK.
COMMIT;





-- ============================================================
-- OPTIMISTIC LOCKING DEMONSTRATION
-- ============================================================
--
-- Objective:
-- Prevent stale updates using a version column.
--
-- Each successful update increments the version.
-- An update succeeds only if the version matches the value
-- previously read by the transaction.
--
-- This allows concurrent transactions to work without
-- immediately acquiring an exclusive row lock.
-- ============================================================

START TRANSACTION;

-- STEP 1: Read the current version.
SELECT version
INTO @current_version
FROM show_seats
WHERE show_id = 1
  AND seat_id = 2;

-- STEP 2: Attempt to reserve the seat using that version.
UPDATE show_seats
SET
    status = 'HELD',
    held_by = 1,
    hold_expires_at = NOW() + INTERVAL 120 SECOND,
    version = version + 1
WHERE show_id = 1
  AND seat_id = 2
  AND status = 'AVAILABLE'
  AND version = @current_version;

-- Check immediately: expected 1 if the update succeeded.
SELECT ROW_COUNT() AS first_update_rows;

-- STEP 3: Simulate another transaction attempting an
-- update using the OLD version.
UPDATE show_seats
SET
    status = 'HELD',
    held_by = 2,
    hold_expires_at = NOW() + INTERVAL 120 SECOND,
    version = version + 1
WHERE show_id = 1
  AND seat_id = 2
  AND status = 'AVAILABLE'
  AND version = @current_version;

-- Expected: 0 rows, because the version is now different.
SELECT ROW_COUNT() AS stale_update_rows;

-- Roll back so the demonstration does not reserve the seat.
ROLLBACK;



-- ============================================================
-- OBSERVATION: OPTIMISTIC LOCKING
-- ============================================================
--
-- The first update succeeded because the supplied version
-- matched the current version of the seat.
--
-- After the update, the version number was incremented.
--
-- The second update used the old version number. Therefore,
-- its WHERE condition matched no rows and the update failed.
--
-- This prevents stale transactions from overwriting newer
-- changes.
--
-- Expected results:
-- First update: 1 row affected.
-- Stale update: 0 rows affected.
--
-- Note:
-- This demonstrates version-based conflict detection.
-- A true concurrency test requires two separate sessions.
-- ============================================================
