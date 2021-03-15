
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

CREATE TABLE City (
    city_name varchar(50) NOT NULL,
    state varchar(50) NOT NULL,
    population int(255) NOT NULL,
    PRIMARY KEY (city_name)
);

CREATE TABLE Store (
    store_no int NOT NULL,
    phone_no varchar(20) NOT NULL,
    address varchar(250) NOT NULL,
    city_name varchar(250) NOT NULL,
    PRIMARY KEY (store_no),
    FOREIGN KEY (city_name) REFERENCES City(city_name)
);

CREATE TABLE Childcare (
    `limit` time NULL,
    store_no int NOT NULL,
    FOREIGN KEY (store_no) REFERENCES Store(store_no)
);

CREATE TABLE FoodService (
    store_no int NOT NULL,
    FOREIGN KEY (store_no) REFERENCES Store(store_no)
);

CREATE TABLE Sold (
  StoreNo INTEGER NOT NULL,
  `date` Date NOT NULL,
  PID INTEGER NOT NULL,
  FOREIGN KEY (StoreNo) REFERENCES Store(StoreNo),
  FOREIGN KEY (`date`) REFERENCES Date(`date`),
  FOREIGN KEY (PID) REFERENCES Product(PID),
  Quantity INTEGER NOT NULL
)

CREATE TABLE Restaurant (
  StoreNo INTEGER NOT NULL,
  FOREIGN KEY (StoreNo) REFERENCES Store(StoreNo)
)


CREATE TABLE Snackbar (
  StoreNo INTEGER NOT NULL,
  FOREIGN KEY (StoreNo) REFERENCES Store(StoreNo)
)

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

CREATE TABLE Has_Discount (
  'date' DATE, --ALREADY NOT NULL FROM DATE TABLE
  PID INTEGER, --ALREADY NOT NULL FROM PRODUCT TABLE
  DiscountPrice DECIMAL(10,2) NOT NULL,
  FOREIGN KEY (DATE) REFERENCES Date(date),
  FOREIGN KEY (PID) REFERENCES Date(date)
);

CREATE TABLE Product (
  PID INTEGER NOT NULL,
  Name varchar(250) NOT NULL,
  Price DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (PID)
);

CREATE TABLE Product-Category (
  PID INTEGER NOT NULL,
  Name varchar(250) NOT NULL,
  FOREIGN KEY (PID) REFERENCES Product(PID),
  FOREIGN KEY (Name) REFERENCES Category(Name)
);

CREATE TABLE Category (
  Name varchar(250) NOT NULL
  PRIMARY KEY (Name)
);

-- Constraints   Foreign Keys: FK_ChildTable_childColumn_ParentTable_parentColumn
ALTER TABLE DateHolidayName
  ADD CONSTRAINT fk_DateHolidayName_date_Date_date FOREIGN KEY (`date`) REFERENCES `Date` (`date`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE DateAdCampaign
  ADD CONSTRAINT fk_DateAdCampaign_date_Date_date FOREIGN KEY (`date`) REFERENCES `Date` (`date`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_DateAdCampaign_description_AdCampaign_description FOREIGN KEY (description) REFERENCES AdCampaign (description) ON DELETE CASCADE ON UPDATE CASCADE;
