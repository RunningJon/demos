--HAWQ External Table that reads from Hive table stored in ORC format
CREATE EXTERNAL TABLE pxf.hive_orc
(like pxf.wr_sample)
LOCATION (:LOCATION)
FORMAT 'custom' (formatter='pxfwritable_import');

