CREATE TABLE tpch.region
WITH (appendonly=true,orientation=parquet) AS
SELECT r_regionkey, r_name, r_comment
FROM ext_tpch.region
DISTRIBUTED BY (R_REGIONKEY);
