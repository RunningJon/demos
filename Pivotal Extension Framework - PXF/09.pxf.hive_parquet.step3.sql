--HAWQ External Table that reads from Hive table stored in Parquet format
CREATE EXTERNAL TABLE pxf.hive_parquet
(like pxf.wr_sample)
LOCATION (:LOCATION)
FORMAT 'custom' (formatter='pxfwritable_import');
