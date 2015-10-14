CREATE TABLE tpch.part
WITH (appendonly=true,orientation=parquet) AS
SELECT p_partkey, p_name, p_mfgr, p_brand, p_type, p_size, p_container, 
       p_retailprice, p_comment
FROM ext_tpch.part
DISTRIBUTED BY (P_PARTKEY);
