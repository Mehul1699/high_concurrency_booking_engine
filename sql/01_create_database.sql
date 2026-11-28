
-- =========================================================
-- File: 01_create_database.sql
-- Project: BookMyShow Database Design
-- Description:
-- This script creates the MySQL database used for the
-- BookMyShow-inspired ticket booking system.
--
-- The database will store information about theatres,
-- screens, seats, movies, shows, users, bookings, and
-- payments.
--
-- It will also support database-level concurrency control,
-- seat availability tracking, and reliable payment processing.
--
-- Execute this script before running the table creation
-- and sample data insertion scripts.
-- =========================================================

CREATE DATABASE bookmyshow_db;

USE bookmyshow_db;