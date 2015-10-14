DROP TABLE IF EXISTS ext_sample;
DROP TABLE IF EXISTS hive_orc;
DROP TABLE IF EXISTS hive_parquet;

--External Table uses TEXT file that was created with HAWQ
CREATE EXTERNAL TABLE ext_sample
(i int,
  fname varchar(100),
  title varchar(100),
  salary decimal(10,2)
)
ROW FORMAT
DELIMITED FIELDS TERMINATED BY '|'
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/user/gpadmin/sample/';

--Create a Hive table in ORC format
CREATE TABLE hive_orc STORED AS ORC AS
SELECT * FROM ext_sample;

--Create a Hive table in Parquet format
CREATE TABLE hive_parquet STORED AS PARQUET AS
SELECT * FROM ext_sample;
