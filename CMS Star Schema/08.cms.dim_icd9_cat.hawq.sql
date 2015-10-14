CREATE TABLE cms.dim_icd9_cat
WITH (appendonly=true,orientation=parquet, compresstype=snappy) AS
SELECT * FROM ext.dim_icd9_cat
DISTRIBUTED BY (car_line_icd9_dgns_cd);
