
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

CREATE TABLE Sold ( -- CARLOS
  Store_no INTEGER NOT NULL,
  `date` Date NOT NULL,
  PID INTEGER NOT NULL,
  Quantity INTEGER NOT NULL
  FOREIGN KEY (Store_no) REFERENCES Store(StoreNo) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`date`) REFERENCES Date(`date`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (PID) REFERENCES Product(PID) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (Store_no, `date`, PID)
)

CREATE TABLE `Date` ( -- CARLOS
  `date` date NOT NULL,
  PRIMARY KEY (`date`)
);

CREATE TABLE DateHolidayName (
  --MARIA
  `date` date NOT NULL,
  holiday_name varchar(250) NOT NULL,
  PRIMARY KEY (`date`, holiday_name)
);

CREATE TABLE AdCampaign (
  --MARIA
  description varchar(250) NOT NULL,
  PRIMARY KEY (description)
);

CREATE TABLE DateAdCampaign (
  --MARIA
  `date` date NOT NULL,
  description varchar(250) NOT NULL,
  PRIMARY KEY (`date`, description)
);

CREATE TABLE HasDiscount (--VAL
  `date` date, --ALREADY NOT NULL FROM DATE TABLE
  PID INTEGER, --ALREADY NOT NULL FROM PRODUCT TABLE
  DiscountPrice DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`date`, PID),
  KEY `date` (`date`), --don't think this is needed but used for fast indexing
  KEY PID (PID),       --don't think this is needed but used for fast indexing
  FOREIGN KEY (`date`) REFERENCES `Date`(`date`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (PID) REFERENCES Product(PID) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Product (
  --VAL
  PID INTEGER NOT NULL,
  Name varchar(250) NOT NULL,
  Price DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (PID)
);

CREATE TABLE ProductCategory (--VAL
  PID INTEGER NOT NULL,
  Name varchar(250) NOT NULL,
  PRIMARY KEY (PID, Name),
  KEY PID (PID),        --don't think this is needed but used for fast indexing
  KEY Name (Name)       --don't think this is needed but used for fast indexing
  FOREIGN KEY (PID) REFERENCES Product(PID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (Name) REFERENCES Category(Name) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Category (
  --VAL
  Name varchar(250) NOT NULL,
  PRIMARY KEY (Name)
);

-- Constraints   Foreign Keys: FK_ChildTable_childColumn_ParentTable_parentColumn
ALTER TABLE DateHolidayName --MARIA
  ADD CONSTRAINT fk_DateHolidayName_date_Date_date FOREIGN KEY (`date`) REFERENCES `Date` (`date`) ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE DateAdCampaign --MARIA
  ADD CONSTRAINT fk_DateAdCampaign_date_Date_date FOREIGN KEY (`date`) REFERENCES `Date` (`date`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT fk_DateAdCampaign_description_AdCampaign_description FOREIGN KEY (description) REFERENCES AdCampaign (description) ON DELETE CASCADE ON UPDATE CASCADE;

--ALTER TABLE Has_Discount --VAL
-- ADD CONSTRAINT fk_Has_Discount_date_Date_date FOREIGN KEY (`date`) REFERENCES `Date` (`date`) ON DELETE CASCADE ON UPDATE CASCADE,
-- ADD CONSTRAINT fk_Has_Discount_PID_Product_PID FOREIGN KEY (PID) REFERENCES Product(PID) ON DELETE CASCADE ON UPDATE CASCADE

--ALTER Product-Category --VAL
--  ADD CONSTRAINT fk_Product-Category_PID_Product_PID FOREIGN KEY (PID) REFERENCES Product(PID) ON DELETE CASCADE ON UPDATE CASCADE
--  ADD CONSTRAINT fk_Product-Category_Name_Category_Name FOREIGN KEY (Name) REFERENCES Category(Name) ON DELETE CASCADE ON UPDATE CASCADE
