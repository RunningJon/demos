CREATE TABLE tpch.orders
WITH (appendonly=true,orientation=parquet,compresstype=snappy) AS
SELECT o_orderkey, o_custkey, o_orderstatus, o_totalprice, o_orderdate, 
       o_orderpriority, o_clerk, o_shippriority, o_comment
FROM ext_tpch.orders
DISTRIBUTED BY (O_ORDERKEY, O_CUSTKEY);
