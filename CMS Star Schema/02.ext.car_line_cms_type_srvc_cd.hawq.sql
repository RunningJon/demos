CREATE EXTERNAL TABLE ext.car_line_cms_type_srvc_cd
(car_line_cms_type_srvc_cd varchar(5),
 description varchar)
LOCATION (:LOCATION) 
FORMAT 'TEXT' (DELIMITER '|' NULL AS 'null' ESCAPE AS E'\\');
