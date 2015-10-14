CREATE TABLE cms.dim_car_line_place_of_srvc 
WITH (appendonly=true,orientation=parquet, compresstype=snappy) AS
SELECT * FROM ext.car_line_place_of_srvc_cd
DISTRIBUTED BY (car_line_place_of_srvc_cd);
