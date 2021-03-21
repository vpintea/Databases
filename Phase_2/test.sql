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
       ('Houston',	 'Texas',	2320268),
       ('New York', 'New York', 9100000);

INSERT INTO Childcare
VALUES
        (30),
        (45);

INSERT INTO Store
VALUES
        (100, '','', 'Los Angeles', 'California', false, false, 30),
        (200, '','', 'Los Angeles', 'California', true, false, 45),
        (300, '','', 'Chicago',	 'Illinois', false, false, NULL),
        (400, '','', 'Houston',	 'Texas', true, true, NULL),
        (500, '','', 'New York', 'New York', true, true, NULL);

INSERT INTO `Date`
VALUES
        ('2020-06-1'),
        ('2020-06-6'),
        ('2020-02-2'),
        ('2019-06-1'),
        ('2019-06-5'),
        ('2019-02-2'),
	    ('2020-04-12'),
        ('2020-12-25'),
        ('2020-12-31');

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
        (7, 'outdoorChair', 100),
        (8, 'couchYellow', 100),
        (9, 'couchBlue', 150),
        (10, 'couchRed', 100)
        ;

INSERT INTO HasDiscount
VALUES
        ('2020-06-1', 1, 800),
        ('2020-06-5', 3, 300),
        ('2019-02-02', 9, 50)
        ;

INSERT INTO Sold
VALUES
       (100,'2020-06-1', 1, 3),
       (100,'2020-06-6', 5, 1),
       (200,'2020-06-1', 3, 1),
       (200,'2020-06-1', 6, 2),
       (100,'2020-02-2', 7, 1000),
       (100,'2020-06-1', 7, 4000),
       (300,'2019-02-2', 7, 1000),
       (100,'2019-06-1', 7, 1000);

INSERT INTO Category
VALUES
    ('RedCouch'),
    ('RedChair'),
    ('RedDesk'),
    ('Outdoor Furniture'),
    ('Couches and Sofas');

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

INSERT INTO Holiday
VALUES
    ('christmas', '2020-12-25'),
    ('Easter', '2020-04-12'),
    ('New Years Eve', '2020-12-31')
    ;



-- ################################################################################

-- Main Menu
-- Count and display total of STORE instances
SELECT COUNT(*) as TotalStores FROM Store;

-- Count and display total of STORE instances that have FOOD_SERVICE
SELECT COUNT(*) as TotalNumberRestaurants FROM Store
WHERE restaurant = True OR snackbar = True;

-- Count and display total of STORE that Offers Childcare
SELECT COUNT(*) as TotalStoresOfferChildcare FROM Store
WHERE `limit` IS NOT NULL;

-- Count and display all PRODUCT instances
SELECT COUNT(*) as TotalProducts FROM Product;

-- Count and display total of distinct AD_CAMPAIGNs
SELECT COUNT(DISTINCT description) as TotalUniqueCampaigns FROM AdCampaign;

-- ########################################################

-- View/Add Holidays Form

-- View Holidays
SELECT holiday_name, `date` FROM Holiday;

-- Add Holiday
INSERT INTO Holiday VALUES ('Celebrate date','2020-06-01');

-- Update Population
UPDATE City SET population = 5000000 WHERE city = 'Los Angeles';

-- ################################################################################

-- Report 1 ----------

-- number of products per category
SELECT  Category.name as 'Category Name',
count(Product.pid) as 'Total Number of Products',
min(Product.price) as 'Minimum Regular Retail Price',
round(avg(Product.price),2) as 'Average Regular Retail Price',
max(Product.price) as 'Maximum Regular Retail Price'
FROM
Category
LEFT JOIN ProductCategory ON  Category.name = productCategory.name
LEFT JOIN Product
ON Product.pid = productCategory.pid
GROUP BY Category.name
ORDER BY Category.name ASC;

-- ################################################################################

--  Report 2 ----------

-- View Actual vs Predicted Revenue for Couches and Sofas (Report 2)

-- Gets Couches and Sofas
with couchSofasProducts as (SELECT Product.pid, Product.price,  Product.name -- assuming there is only one combination product price
FROM Product
JOIN ProductCategory
ON Product.pid = ProductCategory.pid
WHERE ProductCategory.name = 'Couches and sofas'),

-- Total sum of price of units sold at discount
totalNumberUnitWithDiscount as (SELECT couchSofasProducts.pid, couchSofasProducts.name, SUM(Sold.quantity * HasDiscount.discount_price) as TotalPrice, SUM(Sold.quantity) as totalSoldDiscount
FROM couchSofasProducts
JOIN Sold on  couchSofasProducts.pid = Sold.pid
JOIN HasDiscount on HasDiscount.pid = couchSofasProducts.pid
AND Sold.Date = HasDiscount.date
WHERE HasDiscount.date IS NOT NULL
GROUP BY couchSofasProducts.pid, couchSofasProducts.name),

-- Total sum of price of units sold without discount
totalNumberUnitWithoutDiscount as (
SELECT couchSofasProducts.pid, couchSofasProducts.name, SUM(Sold.quantity * couchSofasProducts.Price) as TotalPrice
FROM couchSofasProducts
JOIN Sold on  couchSofasProducts.pid = Sold.pid
LEFT JOIN HasDiscount on HasDiscount.pid = couchSofasProducts.pid
AND Sold.Date = HasDiscount.date
WHERE HasDiscount.date IS NULL
GROUP BY couchSofasProducts.pid, couchSofasProducts.name),

-- Total predicted
totalPredicted as (SELECT couchSofasProducts.pid, couchSofasProducts.name, SUM(Sold.quantity * couchSofasProducts.Price * 0.75) as TotalPredictedPrice, SUM(Sold.Quantity) as totalSold
FROM couchSofasProducts
JOIN Sold on  couchSofasProducts.pid = Sold.pid
GROUP BY couchSofasProducts.pid, couchSofasProducts.name)

SELECT couchSofasProducts.pid, couchSofasProducts.name, couchSofasProducts.price, totalPredicted.totalSold, totalNumberUnitWithDiscount.totalSoldDiscount,
(COALESCE(totalNumberUnitWithDiscount.TotalPrice,0) + totalNumberUnitWithoutDiscount.TotalPrice) as TotalRevenue,
totalPredicted.TotalPredictedPrice,
(totalNumberUnitWithDiscount.TotalPrice + totalNumberUnitWithoutDiscount.TotalPrice) - totalPredicted.TotalPredictedPrice as 'Difference Actual vs Predicted'
FROM couchSofasProducts
LEFT JOIN totalNumberUnitWithDiscount ON couchSofasProducts.pid = totalNumberUnitWithDiscount.PID
LEFT JOIN totalNumberUnitWithoutDiscount ON couchSofasProducts.pid = totalNumberUnitWithoutDiscount.PID
LEFT JOIN totalPredicted ON couchSofasProducts.pid = totalPredicted.PID
WHERE ABS((totalNumberUnitWithDiscount.TotalPrice + totalNumberUnitWithoutDiscount.TotalPrice) - totalPredicted.TotalPredictedPrice ) > 100
ORDER BY ABS((totalNumberUnitWithDiscount.TotalPrice + totalNumberUnitWithoutDiscount.TotalPrice) - totalPredicted.TotalPredictedPrice ) DESC; -- ## to change to 5000

-- ################################################################################

-- Report 3 -------
-- Gets all the stores in a state

with storesInState as (SELECT City.city, Store.store_no, Store.address, Store.State
FROM City
JOIN Store on (City.city = Store.city and City.state = Store.state)
WHERE
City.State = 'California'
),

-- Gets the revenue at discount and sales at discount per store
revenueDiscount as (
  SELECT storesInState.store_no, SUM(Sold.quantity * HasDiscount.discount_price) as revenue,  YEAR(sold.date) as year_sold
  FROM Sold
  JOIN storesInState ON storesInState.store_no = SOLD.store_no
  JOIN HasDiscount on HasDiscount.pid = SOLD.pid AND Sold.Date = HasDiscount.date
  JOIN Product on Product.pid = Sold.pid
  WHERE HasDiscount.date IS NOT NULL
  GROUP BY YEAR(sold.date), storesInState.store_no
),

-- Gets the revenue at discount and sales at discount per store
revenueRetail as (
  SELECT storesInState.store_no, SUM(Sold.quantity * Product.Price) as revenue,  YEAR(sold.date) as year_sold
  FROM Sold
  JOIN storesInState ON storesInState.store_no = SOLD.store_no
  LEFT JOIN HasDiscount on HasDiscount.pid = SOLD.pid AND Sold.Date = HasDiscount.date
  JOIN Product on Product.pid = Sold.pid
  WHERE HasDiscount.date IS NULL
  GROUP BY YEAR(sold.date), storesInState.store_no)

SELECT storesInState.store_no, storesInState.address, storesInState.city,
YEAR(sold.date) as Sales_Year, -- need to join with sold in case there is year with only discount sales or only regular sales
(COALESCE(revenueDiscount.revenue,0) + COALESCE(revenueRetail.revenue,0)) as total_revenue
FROM storesInState
LEFT JOIN sold ON storesInState.store_no = SOLD.store_no
LEFT JOIN revenueDiscount ON (storesInState.store_no = revenueDiscount.store_no AND YEAR(sold.date) = revenueDiscount.year_sold)
LEFT JOIN revenueRetail ON (storesInState.store_no = revenueRetail.store_no AND YEAR(sold.date) = revenueRetail.year_sold)
GROUP BY storesInState.store_no, storesInState.address, storesInState.city, YEAR(sold.date), total_revenue
ORDER BY YEAR(sold.date) ASC, total_revenue DESC;

-- ################################################################################

-- Report 4 Grounhog Day
SELECT YEAR(x.date) as Year,
	sum(x.quantity) as TotalQuantity,
	sum(x.quantity)/365 as AvgDailyQuantity,
	sum(y.quantity) as GroundHogDay
FROM
(SELECT date, quantity
	FROM Sold JOIN ProductCategory ON Sold.PID = ProductCategory.PID
	WHERE ProductCategory.name = 'Outdoor Furniture') as x
JOIN
(SELECT date, quantity
FROM Sold JOIN ProductCategory ON Sold.PID = ProductCategory.PID
	WHERE ProductCategory.name = 'Outdoor Furniture'
	AND MONTH(Sold.date) = 2
	AND DAY(Sold.date) = 2) as y
ON x.date = y.date
GROUP BY YEAR
ORDER BY YEAR;

-- ################################################################################

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

-- ################################################################################

-- Report 6 revenue by population
SELECT *
FROM
     (SELECT City.population as pop, -- Calculate city population categories
             CASE
                 WHEN (City.population < 3700000) THEN 'small'
                 WHEN (City.population BETWEEN 3700000 AND 6699999) THEN 'medium'
                 WHEN (city.population BETWEEN 6700000 AND 8999999) THEN 'large'
                 WHEN (City.population >= 9000000) THEN 'Xlarge'
                 ELSE null
                 END as CityPopulation
     FROM City) as x;

-- Calculate retail revenue for each city
select city, state, sum(price*quantity)  from sold
JOIN Product P on Sold.pid = P.pid
LEFT JOIN HasDiscount ON P.pid = HasDiscount.pid
JOIN Store on Sold.store_no = Store.store_no
where HasDiscount.date IS null
group by city, state;

-- find discounted revenue by city
select city, state, sum(discount_price*quantity) as discountRev from sold
JOIN Product P on Sold.pid = P.pid
LEFT JOIN HasDiscount ON P.pid = HasDiscount.pid
JOIN Store on Sold.store_no = Store.store_no
group by city, state;

-- TODO calc discount revenue
-- TODO flow total revenue through population category

-- ################################################################################

-- Report 7
SELECT month_of_year, childcare_limit, SUM(total_amount) AS total_sales
FROM (SELECT MONTH(Sold.`date`)                                                  AS month_of_year,
             IFNULL(Store.`limit`, 0)                                            AS childcare_limit,
             Sold.quantity * IFNULL(HasDiscount.discount_price, Product.price)   AS total_amount
      FROM Sold
               LEFT JOIN Product ON Product.pid = Sold.pid
               LEFT JOIN HasDiscount ON HasDiscount.pid = Sold.pid AND HasDiscount.`date` = Sold.`date`
               LEFT JOIN Store ON Store.store_no = Sold.store_no
      WHERE Sold.`date` > NOW() - INTERVAL 12 month) AS lala
GROUP BY month_of_year, childcare_limit;
-- ################################################################################

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














