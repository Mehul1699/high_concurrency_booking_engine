-- =========================================================
-- File: 02_create_tables.sql
-- Project: BookMyShow Database Design
--
-- Description:
-- This script creates the relational database tables
-- required for the theatre ticket booking system.
--
-- It defines the entities, their attributes, primary keys,
-- foreign keys, unique constraints, and other integrity
-- constraints required to maintain consistent data.
--
-- The schema is designed with database normalization
-- principles (1NF, 2NF, 3NF, and BCNF) in mind.
--
-- It also considers high-concurrency booking scenarios,
-- including seat availability tracking and prevention
-- of duplicate seat bookings.
--
-- Tables are created in dependency order to ensure
-- foreign key relationships can be established correctly.
--
-- Prerequisite:
-- Execute 01_create_database.sql before running this script.
-- =========================================================
CREATE TABLE theatre (
    theatre_id int not null auto_increment,
    theatre_name varchar(150) not null,
    location varchar(150) not null,
    address varchar(255) not null,
    primary key (theatre_id)
) ENGINE = InnoDB;

CREATE TABLE screen (
    screen_id int not null auto_increment,
    screen_name varchar(150) not null,
    theatre_id int not null,
    primary key (screen_id),
    constraint fk_screen_theatre FOREIGN KEY (theatre_id) REFERENCES theatre (theatre_id),
    constraint uq_theatre_screen UNIQUE (theatre_id, screen_name)
) ENGINE = InnoDB;

CREATE TABLE seat (
    seat_id int not null auto_increment,
    screen_id int not null,
    row_id varchar(5) not null,
    seat_number int not null,
    seat_type varchar(50) not null,
    primary key (seat_id),
    CONSTRAINT fk_seat_screen FOREIGN KEY (screen_id) REFERENCES screen (screen_id),
    CONSTRAINT uq_screen_seat UNIQUE (screen_id, row_id, seat_number)
) ENGINE = InnoDB;

CREATE TABLE movie (
    movie_id int not null auto_increment,
    movie_name varchar(300) not null,
    duration_min int not null,
    certification varchar(10) not null,
    primary key (movie_id)
) ENGINE = InnoDB;

CREATE TABLE shows (
    show_id int not null auto_increment,
    movie_id int not null,
    screen_id int not null,
    start_time datetime not null,
    end_time datetime not null,
    primary key (show_id),
    CONSTRAINT fk_show_movie FOREIGN KEY (movie_id) REFERENCES movie (movie_id),
    CONSTRAINT fk_show_screen FOREIGN KEY (screen_id) REFERENCES screen (screen_id),
    CONSTRAINT chk_show_time CHECK (end_time > start_time),
    CONSTRAINT uq_screen_start_time UNIQUE (screen_id, start_time)
) ENGINE = InnoDB;

CREATE TABLE users (
    user_id int not null auto_increment,
    user_name varchar(250) not null,
    email varchar(200) not null,
    phone varchar(20) not null,
    primary key (user_id),
    CONSTRAINT uq_users_email UNIQUE (email)
) ENGINE = InnoDB;

CREATE TABLE booking (
    booking_id int not null auto_increment,
    user_id int not null,
    show_id int not null,
    total_amount decimal(10, 2) not null,
    booking_status varchar(30) not null,
    created_at datetime not null,
    primary key (booking_id),
    CONSTRAINT fk_booking_user FOREIGN KEY (user_id) REFERENCES users (user_id),
    CONSTRAINT fk_booking_show FOREIGN KEY (show_id) REFERENCES shows (show_id),
    CONSTRAINT chk_booking_status CHECK (
        booking_status IN (
            'PENDING_PAYMENT',
            'CONFIRMED',
            'CANCELLED',
            'EXPIRED'
        )
    )
) ENGINE = InnoDB;

CREATE TABLE booking_seats (
    booking_id int not null,
    seat_id int not null,
    PRIMARY KEY (booking_id, seat_id),
    CONSTRAINT fk_booking_seat_booking FOREIGN KEY (booking_id) REFERENCES booking (booking_id),
    CONSTRAINT fk_booking_seat_seat FOREIGN KEY (seat_id) REFERENCES seat (seat_id)
) ENGINE = InnoDB;

CREATE TABLE show_seats (
    show_id int not null,
    seat_id int not null,
    status varchar(20) not null,
    held_by int,
    hold_expires_at datetime,
    version INT NOT NULL DEFAULT 0,
    primary key (show_id, seat_id),
    CONSTRAINT fk_show_seats_show_id FOREIGN KEY (show_id) REFERENCES shows (show_id),
    CONSTRAINT fk_show_seats_seat_id FOREIGN KEY (seat_id) REFERENCES seat (seat_id),
    CONSTRAINT fk_show_seats_held_by FOREIGN KEY (held_by) REFERENCES users (user_id),
    CONSTRAINT chk_show_seats_status CHECK (status IN ('AVAILABLE', 'HELD', 'BOOKED')),
    CONSTRAINT chk_show_seats_hold_consistency CHECK (
        (
            status = 'HELD'
            AND held_by IS NOT NULL
            AND hold_expires_at IS NOT NULL
        )
        OR (
            status IN ('AVAILABLE', 'BOOKED')
            AND held_by IS NULL
            AND hold_expires_at IS NULL
        )
    )
) ENGINE = InnoDB;

CREATE TABLE payment (
    payment_id int not null auto_increment,
    booking_id int not null,
    amount decimal(10, 2) not null,
    payment_status varchar(20) not null,
    payment_method varchar(50) not null,
    transaction_reference varchar(255),
    created_at datetime not null,
    primary key (payment_id),
    CONSTRAINT fk_payment_booking_id FOREIGN KEY (booking_id) REFERENCES booking (booking_id),
    CONSTRAINT uq_payment_transaction UNIQUE (transaction_reference),
    CONSTRAINT chk_payment_payment_status CHECK (
        payment_status in ('PENDING', 'SUCCESS', 'FAILED')
    )
) ENGINE = InnoDB;

CREATE TABLE payment_webhook_events (
    event_id varchar(255) not null,
    payment_id int not null,
    event_type varchar(20) not null,
    processed_at datetime,
    processing_status varchar(20) not null,
    primary key (event_id),
    CONSTRAINT fk_event_payment_id FOREIGN KEY (payment_id) REFERENCES payment (payment_id),
    CONSTRAINT chk_webhook_processing_status CHECK (
        processing_status in ('PENDING', 'PROCESSED', 'FAILED')
    )
) ENGINE = InnoDB;

CREATE TABLE booking_status_history (
    history_id int not null auto_increment,
    booking_id int not null,
    previous_status varchar(50),
    new_status varchar(50) not null,
    changed_at datetime not null DEFAULT CURRENT_TIMESTAMP,
    reason varchar(255),
    primary key (history_id),
    CONSTRAINT fk_history_booking_id FOREIGN KEY (booking_id) REFERENCES booking (booking_id),
    CONSTRAINT chk_history_new_status CHECK (
        new_status IN (
            'PENDING_PAYMENT',
            'CONFIRMED',
            'CANCELLED',
            'EXPIRED'
        )
    ),
    CONSTRAINT chk_history_previous_status CHECK (
        previous_status IS NULL
        OR previous_status IN (
            'PENDING_PAYMENT',
            'CONFIRMED',
            'CANCELLED',
            'EXPIRED'
        )
    )
) ENGINE = InnoDB;