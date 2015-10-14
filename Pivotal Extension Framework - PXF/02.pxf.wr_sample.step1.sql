--Write to HDFS with HAWQ
CREATE WRITABLE EXTERNAL TABLE pxf.wr_sample
(i int, fname text, title varchar(100), salary numeric) 
LOCATION (:LOCATION) FORMAT 'text' (delimiter '|' null 'null');

INSERT INTO pxf.wr_sample
SELECT  i, 
        pxf.fn_random_string(30) AS fname, 
        CASE (random()*(9)+1)::int 
        WHEN 1 THEN 'Director' 
        WHEN 2 THEN 'Manager' 
        WHEN 3 THEN 'Manager' 
        WHEN 4 THEN 'Engineer' 
        WHEN 5 THEN 'Engineer'
        WHEN 6 THEN 'Engineer'
        WHEN 7 THEN 'Sales' 
        WHEN 8 THEN 'Sales'
        WHEN 9 THEN 'Sales'
        WHEN 10 THEN 'Sales' END AS title, 
        round((random()*100000)::numeric, 2) AS salary 
FROM generate_series(1, 1000000) AS i;
