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

