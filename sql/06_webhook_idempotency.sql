-- ============================================================
-- P1: PAYMENT WEBHOOK IDEMPOTENCY
-- ============================================================
--
-- Objective:
-- Prevent duplicate processing of payment gateway webhooks.
--
-- Approach:
-- Every gateway event has a unique event_id.
-- The event_id is the PRIMARY KEY of the
-- payment_webhook_events table.
--
-- If the gateway sends the same event more than once,
-- the duplicate event_id is rejected by MySQL.
-- ============================================================
-- STEP 1: Insert a new webhook event.
INSERT INTO
    payment_webhook_events (
        event_id,
        payment_id,
        event_type,
        processed_at,
        processing_status
    )
VALUES
    (
        'evt_payment_002',
        1,
        'PAYMENT_SUCCESS',
        NOW (),
        'PROCESSED'
    );

-- STEP 2: Check the recorded event.
SELECT
    *
FROM
    payment_webhook_events
WHERE
    event_id = 'evt_payment_002';

-- STEP 3: Try inserting the same event again.
-- Expected: Duplicate primary-key error.
INSERT INTO
    payment_webhook_events (
        event_id,
        payment_id,
        event_type,
        processed_at,
        processing_status
    )
VALUES
    (
        'evt_payment_002',
        1,
        'PAYMENT_SUCCESS',
        NOW (),
        'PROCESSED'
    );

-- The duplicate insert must not trigger payment processing again.
