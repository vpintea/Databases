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
    city varchar(50) NOT NULL,
    state varchar(50) NOT NULL,
    population int(255) NOT NULL,
    PRIMARY KEY (city, state)
);

CREATE TABLE Store (
    store_no integer NOT NULL,
    phone_no varchar(20) NOT NULL,
    address varchar(250) NOT NULL,
    city varchar(250) NOT NULL,
    state varchar(50) NOT NULL,
    restaurant boolean NOT NULL,
    snackbar boolean NOT NULL,
    PRIMARY KEY (store_no),
    FOREIGN KEY (city) REFERENCES City(city) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (state) REFERENCES City(state) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Childcare (
    `limit` time NULL,
    store_no integer NOT NULL,
    FOREIGN KEY (store_no) REFERENCES Store(store_no) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE `Date` (
  `date` date NOT NULL,
  PRIMARY KEY (`date`)
);

CREATE TABLE Holiday (
  holiday_name varchar(250) NOT NULL,
  `date` date NOT NULL,
  PRIMARY KEY (holiday_name),
  FOREIGN KEY (`date`) REFERENCES `Date`(`date`) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE AdCampaign (
  description varchar(250) NOT NULL,
  PRIMARY KEY (description)
);

CREATE TABLE DateAdCampaign ( 
  `date` date NOT NULL,
  description varchar(250) NOT NULL,
  PRIMARY KEY (`date`, description),
  FOREIGN KEY (`date`) REFERENCES `Date` (`date`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (description) REFERENCES AdCampaign (description) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Product (
  pid INTEGER NOT NULL,
  name varchar(250) NOT NULL,
  price DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (pid)
);

CREATE TABLE HasDiscount (
  `date` date, -- ALREADY NOT NULL FROM DATE TABLE
  pid INTEGER, -- ALREADY NOT NULL FROM PRODUCT TABLE
  discount_price DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`date`, pid),
  KEY `date` (`date`), -- don't think this is needed but used for fast indexing
  KEY PID (pid),       -- don't think this is needed but used for fast indexing
  FOREIGN KEY (`date`) REFERENCES `Date`(`date`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (pid) REFERENCES Product(pid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Sold (
  store_no INTEGER NOT NULL,
  `date` Date NOT NULL,
  pid INTEGER NOT NULL,
  quantity INTEGER NOT NULL,
  FOREIGN KEY (store_no) REFERENCES Store(store_no) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`date`) REFERENCES Date(`date`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (pid) REFERENCES Product(pid) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (store_no, `date`, pid)
);

CREATE TABLE Category (
  name varchar(250) NOT NULL,
  PRIMARY KEY (Name)
);

CREATE TABLE ProductCategory (
  pid INTEGER NOT NULL,
  name varchar(250) NOT NULL,
  PRIMARY KEY (pid, name),
  KEY PID (pid),        -- don't think this is needed but used for fast indexing
  KEY Name (name),      -- don't think this is needed but used for fast indexing
  FOREIGN KEY (pid) REFERENCES Product(pid) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (name) REFERENCES Category(name) ON DELETE CASCADE ON UPDATE CASCADE
);
