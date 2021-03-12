
-- CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';
CREATE USER IF NOT EXISTS gatechUser@localhost IDENTIFIED BY 'gatech123';

DROP DATABASE IF EXISTS `cs6400_fa17_team029`;
SET default_storage_engine=InnoDB;
SET NAMES utf8mb4 COLLATE utf8mb4_unicode_ci;

CREATE DATABASE IF NOT EXISTS cs6400_fa17_team029
    DEFAULT CHARACTER SET utf8mb4
    DEFAULT COLLATE utf8mb4_unicode_ci;
USE cs6400_fa17_team029;

GRANT SELECT, INSERT, UPDATE, DELETE, FILE ON *.* TO 'gatechUser'@'localhost';
GRANT ALL PRIVILEGES ON `gatechUser@localhost`.* TO 'gatechUser'@'localhost';
GRANT ALL PRIVILEGES ON `cs6400_fa17_team029`.* TO 'gatechUser'@'localhost';
FLUSH PRIVILEGES;

-- Tables

CREATE TABLE `Date` (
  `date` date NOT NULL,
  PRIMARY KEY (`date`)
);

CREATE TABLE DateHolidayName (
  `date` date NOT NULL,
  holiday_name varchar(250) NOT NULL,
  PRIMARY KEY (`date`, holiday_name)
);

CREATE TABLE AdCampaign (
  description varchar(250) NOT NULL,
  PRIMARY KEY (description)
);

CREATE TABLE DateAdCampaign (
  `date` date NOT NULL,
  description varchar(250) NOT NULL,
  PRIMARY KEY (`date`, description)
);

CREATE TABLE Category (
  Name varchar(250) PRIMARY KEY
);

-- Constraints   Foreign Keys: FK_ChildTable_childColumn_ParentTable_parentColumn
ALTER TABLE DateHolidayName
  ADD CONSTRAINT fk_DateHolidayName_date_Date_date FOREIGN KEY (`date`) REFERENCES `Date` (`date`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE DateAdCampaign
  ADD CONSTRAINT fk_DateAdCampaign_date_Date_date FOREIGN KEY (`date`) REFERENCES `Date` (`date`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_DateAdCampaign_description_AdCampaign_description FOREIGN KEY (description) REFERENCES AdCampaign (description) ON DELETE CASCADE ON UPDATE CASCADE;
