CREATE EXTERNAL TABLE ext.car_line_place_of_srvc_cd
(car_line_place_of_srvc_cd int,
 description varchar)
LOCATION (:LOCATION) 
FORMAT 'TEXT' (DELIMITER '|' NULL AS 'null' ESCAPE AS E'\\');
