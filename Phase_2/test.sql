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
    city varchar(250) NOT NULL,
    state varchar(250) NOT NULL,
    population int(255) NOT NULL,
    PRIMARY KEY (city, state)
);

CREATE TABLE Childcare (
    `limit` int NOT NULL,
    PRIMARY KEY (`limit`)
);

CREATE TABLE Store (
    store_no int(255) NOT NULL,
    phone_no varchar(20) NOT NULL,
    address varchar(250) NOT NULL,
    city varchar(250) NOT NULL,
    state varchar(250) NOT NULL,
    restaurant boolean NOT NULL,
    snackbar boolean NOT NULL,
    `limit` int NULL,
    PRIMARY KEY (store_no),
    FOREIGN KEY (city,state) REFERENCES City(city, state) ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (`limit`) REFERENCES Childcare(`limit`) ON DELETE CASCADE ON UPDATE CASCADE
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

INSERT INTO City
VALUES
       ('Los Angeles',	 'California',	3979576),
       ('Chicago',	 'Illinois',	2693976),
       ('Houston',	 'Texas',	2320268);

INSERT INTO Childcare
VALUES
        (30),
        (45);

INSERT INTO Store
VALUES
        (100, '','', 'Los Angeles', 'California', false, false, 30),
        (200, '','', 'Los Angeles', 'California', true, false, 45),
        (300, '','', 'Chicago',	 'Illinois', false, false, NULL),
        (400, '','', 'Houston',	 'Texas', true, true, NULL);

INSERT INTO `Date`
VALUES
        ('2020-06-1'),
        ('2020-06-5'),
        ('2020-06-6'),
        ('2020-06-8'),
        ('2020-06-10'),
        ('2019-06-1'),
        ('2020-02-02'),
        ('2019-02-02')
        ;

INSERT INTO AdCampaign
VALUE ('Special day');

INSERT INTO DateAdCampaign
VALUE ('2020-06-1', 'Special day');

INSERT INTO Product
VALUES
        (1, 'ultimateCouch', 1000),
        (2, 'comfyCouch', 500),
        (3, 'ultimateChair', 600),
        (4, 'comfyChair', 200),
        (5, 'ultimateDesk', 800),
        (6, 'casualDesk', 300),
        (7, 'lawnChair', 100),
        (8, 'couchYellow', 100),
        (9, 'couchBlue', 150),
        (10, 'couchRed', 100)
        ;

INSERT INTO HasDiscount
VALUES
        ('2020-06-1', 1, 800),
        ('2020-06-5', 3, 300);

INSERT INTO Sold
VALUES
       (100,'2020-06-1', 1, 3),
       (100,'2020-06-5', 3, 3),
       (100,'2020-06-6', 5, 1),
       (200,'2020-06-1', 3, 1),
       (200,'2020-06-1', 6, 2),
       (200,'2020-06-8', 4, 3),
       (300,'2020-06-5', 2, 3),
       (100,'2020-06-10', 7, 1),
       (200,'2019-06-1', 7, 1),
       (100,'2020-02-02', 7, 1),
       (400,'2019-02-02', 7, 1),
       (100,'2020-06-1', 8, 3),
       (200,'2019-02-02', 8, 3),
       (400,'2020-06-1', 9, 2),
       (100,'2019-02-02', 9, 4),
       (100,'2019-02-02', 10, 5)
       ;

INSERT INTO Category
VALUES
    ('RedCouch'),
    ('RedChair'),
    ('RedDesk'),
    ('Outdoor Furniture'),
    ('Couches and Sofas')
    ;


INSERT INTO ProductCategory
VALUES
    (1, 'RedCouch'),
    (2, 'RedCouch'),
    (3, 'RedChair'),
    (4, 'RedChair'),
    (5, 'RedDesk'),
    (6, 'RedDesk'),
    (7, 'Outdoor Furniture'),
    (8, 'Couches and Sofas'),
    (9, 'Couches and Sofas'),
    (10, 'Couches and Sofas')
    ;

-- Report 5
WITH TotalNumberSold(category_name, state, total_number_sold)
         AS (SELECT category_name, state, SUM(quantity) AS total_number_sold
             FROM (SELECT name AS category_name, state, quantity
                   FROM ProductCategory
                            JOIN Sold ON ProductCategory.pid = Sold.pid
                            JOIN Store ON Store.store_no = Sold.store_no
                   WHERE MONTH (Sold.`date`) = 06 AND YEAR (Sold.`date`) = 2020) AS lala
             GROUP BY category_name, state
    )
SELECT TotalNumberSold.category_name, TotalNumberSold.state, TotalNumberSold.total_number_sold
FROM (SELECT category_name, MAX(total_number_sold) AS max_total_number_sold
      FROM TotalNumberSold
      GROUP BY category_name) AS TotalNumberSoldPerCategory
         JOIN TotalNumberSold ON TotalNumberSoldPerCategory.category_name = TotalNumberSold.category_name
    AND TotalNumberSoldPerCategory.max_total_number_sold = TotalNumberSold.total_number_sold
ORDER BY category_name ASC;

-- Report 9
WITH ALLResult (pid, name, total_sold_during_campaign, total_sold_outside_campaign, difference) AS (
    SELECT pid,
           name,
           SUM(sold_during_campaign)                              AS total_sold_during_campaign,
           SUM(sold_outside_campaign)                             AS total_sold_outside_campaign,
           SUM(sold_during_campaign) - SUM(sold_outside_campaign) AS difference
    FROM (SELECT Product.pid,
                 Product.name,
                 IF(DateAdCampaign.description IS NOT NULL, Sold.quantity, 0) AS sold_during_campaign,
                 IF(DateAdCampaign.description IS NULL, Sold.quantity, 0)     AS sold_outside_campaign
          FROM Product
                   JOIN HasDiscount ON Product.pid = HasDiscount.pid
                   LEFT JOIN DateAdCampaign ON HasDiscount.`date` = DateAdCampaign.`date`
                   LEFT JOIN Sold ON Product.pid = Sold.pid AND HasDiscount.`date` = Sold.`date`) AS lala
    GROUP BY pid, name
)
    (SELECT *
     FROM ALLResult
     ORDER BY difference DESC
     limit 10)
UNION
(SELECT *
 FROM (SELECT *
       FROM ALLResult
       ORDER BY difference ASC
       limit 10) AS lalala
 ORDER BY difference DESC);















