CREATE TABLE tpch.nation
WITH (appendonly=true,orientation=parquet) AS
SELECT n_nationkey, n_name, n_regionkey, n_comment 
FROM ext_tpch.nation
DISTRIBUTED BY (N_NATIONKEY, N_REGIONKEY);
