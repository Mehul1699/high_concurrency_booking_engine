-- Theatre
INSERT INTO
    theatre (theatre_name, location, address)
VALUES
    (
        'PVR Sample Theatre',
        'Connaught Place',
        'New Delhi'
    );

-- Screen
INSERT INTO
    screen (screen_name, theatre_id)
VALUES
    ('IMAX 1', 1),
    ('4DX 1', 1);

-- Seat
INSERT INTO
    seat (screen_id, row_id, seat_number, seat_type)
VALUES
    (1, 'A', 1, 'REGULAR'),
    (1, 'A', 2, 'REGULAR'),
    (1, 'A', 3, 'PREMIUM'),
    (1, 'A', 4, 'PREMIUM'),
    (2, 'A', 1, 'REGULAR'),
    (2, 'A', 2, 'REGULAR'),
    (2, 'A', 3, 'PREMIUM'),
    (2, 'A', 4, 'PREMIUM');

-- Movie
INSERT INTO
    movie (movie_name, duration_min, certification)
VALUES
    ('The Last Journey', 150, 'UA'),
    ('Beyond the Stars', 135, 'U');

-- Shows
INSERT INTO
    shows (movie_id, screen_id, start_time, end_time)
VALUES
    (
        1,
        1,
        '2026-11-28 10:00:00',
        '2026-11-28 12:30:00'
    ),
    (
        2,
        1,
        '2026-11-28 14:00:00',
        '2026-11-28 16:15:00'
    ),
    (
        1,
        2,
        '2026-11-28 11:00:00',
        '2026-11-28 13:30:00'
    ),
    (
        2,
        2,
        '2026-11-28 17:00:00',
        '2026-11-28 19:15:00'
    );

-- show_seats
INSERT INTO
    show_seats (show_id, seat_id, status)
SELECT
    sh.show_id,
    st.seat_id,
    'AVAILABLE'
FROM
    shows sh
    JOIN seat st ON sh.screen_id = st.screen_id;

-- users
INSERT INTO
    users (user_name, email, phone)
VALUES
    ('Aarav', 'aarav@example.com', '9876543210'),
    ('Riya', 'riya@example.com', '9876543211'),
    ('Kabir', 'kabir@example.com', '9876543212');

-- booking
INSERT INTO
    booking (
        user_id,
        show_id,
        total_amount,
        booking_status,
        created_at
    )
VALUES
    (1, 1, 300, 'PENDING_PAYMENT', NOW ());

-- booking_status_history
INSERT INTO
    booking_status_history (
        booking_id,
        previous_status,
        new_status,
        changed_at,
        reason
    )
VALUES
    (
        1,
        NULL,
        'PENDING_PAYMENT',
        NOW (),
        'Booking initiated'
    );

-- Example hold booking on show 1, seat 1
UPDATE show_seats
SET
    status = 'HELD',
    held_by = 1,
    hold_expires_at = NOW () + INTERVAL 120 SECOND
WHERE
    show_id = 1
    AND seat_id = 1
    AND status = 'AVAILABLE';

-- booking_seats
INSERT INTO
    booking_seats (booking_id, seat_id)
VALUES
    (1, 1);

-- Mark the seat as booked and clear its temporary hold.
UPDATE show_seats
SET
    status = 'BOOKED',
    held_by = NULL,
    hold_expires_at = NULL
WHERE
    show_id = 1
    AND seat_id = 1
    AND status = 'HELD'
    AND held_by = 1;

-- Confirm the booking.
UPDATE booking
SET
    booking_status = 'CONFIRMED'
WHERE
    booking_id = 1;

-- Record the status change.
INSERT INTO
    booking_status_history (
        booking_id,
        previous_status,
        new_status,
        changed_at,
        reason
    )
VALUES
    (
        1,
        'PENDING_PAYMENT',
        'CONFIRMED',
        NOW (),
        'Payment successful'
    );

-- payment
INSERT INTO
    payment (
        booking_id,
        amount,
        payment_status,
        payment_method,
        created_at
    )
VALUES
    (1, 300, 'SUCCESS', 'UPI', NOW ());

-- payment_webhook_events
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
        'evt_payment_001',
        1,
        'PAYMENT_SUCCESS',
        NOW (),
        'PROCESSED'
    );