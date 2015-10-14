--Read the TEXT data in HAWQ written in previous step
CREATE EXTERNAL TABLE pxf.read_sample
(like pxf.wr_sample)
LOCATION (:LOCATION) FORMAT 'text' (delimiter '|' null 'null');

