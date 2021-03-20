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
    store_no int(255) NOT NULL,
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
    UNIQUE (store_no),
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
  FOREIGN KEY (`date`) REFERENCES `Date`(`date`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (description) REFERENCES AdCampaign (description) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Product (
  pid int(255) NOT NULL,
  name varchar(250) NOT NULL,
  price dec(10,2) NOT NULL,
  PRIMARY KEY (pid)
);

CREATE TABLE HasDiscount (
  `date` date NOT NULL, 
  pid int(255) NOT NULL, 
  discount_price dec(10,2) NOT NULL,
  PRIMARY KEY (`date`, pid),
  FOREIGN KEY (`date`) REFERENCES `Date`(`date`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (pid) REFERENCES Product(pid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Sold (
  store_no int(255) NOT NULL,
  `date` date NOT NULL,
  pid int(255) NOT NULL,
  quantity int(255) NOT NULL,
  PRIMARY KEY (store_no, `date`, pid),
  FOREIGN KEY (store_no) REFERENCES Store(store_no) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (`date`) REFERENCES `Date`(`date`) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (pid) REFERENCES Product(pid) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Category (
  name varchar(250) NOT NULL,
  PRIMARY KEY (Name)
);

CREATE TABLE ProductCategory (
  pid int(255) NOT NULL,
  name varchar(250) NOT NULL,
  PRIMARY KEY (pid, name),
  FOREIGN KEY (pid) REFERENCES Product(pid) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (name) REFERENCES Category(name) ON DELETE CASCADE ON UPDATE CASCADE
);
