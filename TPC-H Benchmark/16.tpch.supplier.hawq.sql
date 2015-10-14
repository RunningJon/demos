CREATE TABLE tpch.supplier
WITH (appendonly=true,orientation=parquet) AS
SELECT s_suppkey, s_name, s_address, s_nationkey, s_phone, s_acctbal, s_comment
FROM ext_tpch.supplier
DISTRIBUTED BY (S_SUPPKEY);
