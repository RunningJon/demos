CREATE TABLE cms.claims 
WITH (appendonly=true,orientation=parquet, compresstype=snappy) AS
SELECT * FROM ext.claims
DISTRIBUTED BY (car_line_id);
