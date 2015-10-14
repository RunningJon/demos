CREATE EXTERNAL TABLE ext.dim_icd9_cat
(car_line_icd9_dgns_cd varchar,
 description varchar)
LOCATION (:LOCATION)
FORMAT 'TEXT' (DELIMITER '|' NULL AS 'null' ESCAPE AS E'\\');
