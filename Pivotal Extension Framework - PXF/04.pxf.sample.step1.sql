--Create a HAWQ table by reading the TEXT data in HDFS
CREATE TABLE pxf.sample 
WITH (appendonly=true,orientation=parquet, compresstype=snappy) AS
SELECT * FROM pxf.read_sample DISTRIBUTED BY (i);
