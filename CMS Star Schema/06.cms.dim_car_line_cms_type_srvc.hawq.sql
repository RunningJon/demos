CREATE TABLE cms.dim_car_line_cms_type_srvc
WITH (appendonly=true,orientation=parquet, compresstype=snappy) AS
SELECT * FROM ext.car_line_cms_type_srvc_cd
DISTRIBUTED BY (car_line_cms_type_srvc_cd);
