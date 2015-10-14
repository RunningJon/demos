CREATE TABLE tpch.customer 
WITH (appendonly=true,orientation=parquet) AS
SELECT c_custkey, c_name, c_address, c_nationkey, c_phone, c_acctbal, c_mktsegment, c_comment
FROM ext_tpch.customer
DISTRIBUTED BY (C_CUSTKEY);
