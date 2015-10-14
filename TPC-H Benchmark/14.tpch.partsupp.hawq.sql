CREATE TABLE tpch.partsupp
WITH (appendonly=true,orientation=parquet) AS 
SELECT ps_partkey, ps_suppkey, ps_availqty, ps_supplycost, ps_comment
FROM ext_tpch.partsupp
DISTRIBUTED BY (PS_PARTKEY, PS_SUPPKEY);
