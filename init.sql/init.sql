-- Create Auth DB and user
CREATE DATABASE IF NOT EXISTS auth_db;
CREATE USER IF NOT EXISTS 'auth_user'@'%' IDENTIFIED BY 'auth_password';
GRANT ALL PRIVILEGES ON auth_db.* TO 'auth_user'@'%';

-- Create Booking DB and user
CREATE DATABASE IF NOT EXISTS booking_db;
CREATE USER IF NOT EXISTS 'booking_user'@'%' IDENTIFIED BY 'booking_password';
GRANT ALL PRIVILEGES ON booking_db.* TO 'booking_user'@'%';

-- Create Driver DB and user
CREATE DATABASE IF NOT EXISTS driver_db;
CREATE USER IF NOT EXISTS 'driver_user'@'%' IDENTIFIED BY 'driver_password';
GRANT ALL PRIVILEGES ON driver_db.* TO 'driver_user'@'%';

FLUSH PRIVILEGES;