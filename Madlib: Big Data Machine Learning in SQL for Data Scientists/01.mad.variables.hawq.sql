--This table is used to generate random housing data based on upper and lower ranges with some overlap.

CREATE TABLE mad.variables
(tax_lower int,
tax_upper int,
bedroom int,
bath_lower int,
bath_upper int,
price_lower int,
price_upper int,
size_lower int,
size_upper int,
lot_lower int,
lot_upper int)
DISTRIBUTED BY (bedroom);

INSERT INTO mad.variables VALUES
(1000, 2500, 1, 1, 2, 100000, 150000, 1200, 1500, 750, 1000),
(2400, 3300, 2, 2, 3, 145000, 200000, 1500, 1700, 900, 1200),
(3200, 4600, 3, 2, 3, 190000, 250000, 1650, 2000, 1100, 1500),
(3200, 4600, 4, 4, 5, 245000, 300000, 2100, 3000, 1400, 1700);
