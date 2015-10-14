--This table will have the randomly generated data in which we will use for Linear Regression

CREATE TABLE mad.houses
(id int, 
tax int, 
bedroom int, 
bath float, 
price int,
size int, 
lot int)
DISTRIBUTED BY (id);

INSERT INTO mad.houses
SELECT  i, 
        (random()*(tax_upper-tax_lower)+tax_lower)::int AS tax,
        bedroom,
        (random()*(bath_upper-bath_lower)+bath_lower)::int AS bath,
        (random()*(price_upper-price_lower)+price_lower)::int AS price,
        (random()*(size_upper-size_lower)+size_lower)::int AS size, 
        (random()*(lot_upper-lot_lower)+lot_lower)::int AS lot
FROM generate_series(1,250000) AS i, mad.variables;
