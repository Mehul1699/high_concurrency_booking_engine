/*
=========================================================
DATABASE TRIGGERS
=========================================================

Purpose:
These triggers enforce data integrity rules that cannot
be fully handled through primary keys, foreign keys, or
unique constraints.

1. SHOW_SEAT_VALIDATE_INSERT
   - Executes before inserting into show_seats.
   - Checks whether the seat and show belong to the same
     screen.
   - Rejects the insertion if their screen IDs differ.

2. SHOW_SEAT_VALIDATE_UPDATE
   - Executes before updating show_seats.
   - Performs the same validation using the new seat and
     show IDs.
   - Rejects the update if their screen IDs differ.

Reason:
A show must only be associated with seats belonging to
the screen where that show is scheduled.

=========================================================
*/

DELIMITER $$

CREATE TRIGGER SHOW_SEAT_VALIDATE
BEFORE INSERT ON show_seats
FOR EACH ROW
BEGIN
DECLARE seat_screen_id INT;
DECLARE show_screen_id INT;
SELECT screen_id
INTO seat_screen_id
FROM seat
WHERE seat_id = NEW.seat_id;
SELECT screen_id
INTO show_screen_id
FROM shows
WHERE show_id = NEW.show_id;
IF seat_screen_id <> show_screen_id THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Seat does not belong to the show screen';
END IF;

END$$
DELIMITER ;



DELIMITER $$

CREATE TRIGGER SHOW_SEAT_UPDATE_VALIDATE
BEFORE UPDATE ON show_seats
FOR EACH ROW
BEGIN
DECLARE seat_screen_id INT;
DECLARE show_screen_id INT;
SELECT screen_id
INTO seat_screen_id
FROM seat
WHERE seat_id = NEW.seat_id;
SELECT screen_id
INTO show_screen_id
FROM shows
WHERE show_id = NEW.show_id;
IF seat_screen_id <> show_screen_id THEN
    SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Seat does not belong to the show screen';
END IF;

END$$
DELIMITER ;



DELIMITER $$

CREATE TRIGGER SEAT_UPDATE_VALIDATE
BEFORE UPDATE ON seat
FOR EACH ROW
BEGIN
	IF EXISTS (
		SELECT 1
        FROM show_seats ss
        JOIN shows s
        on ss.show_id = s.show_id
        where ss.seat_id = OLD.seat_id
        AND s.screen_id <> NEW.screen_id
	) THEN
		SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT =
            'Cannot change seat screen because it conflicts with an existing show';

    END IF;

END$$

DELIMITER ;