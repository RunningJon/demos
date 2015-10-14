CREATE TABLE tpch.lineitem 
WITH (appendonly=true,orientation=parquet,compresstype=snappy) AS
SELECT l_orderkey, l_partkey, l_suppkey, l_linenumber, l_quantity, l_extendedprice, 
       l_discount, l_tax, l_returnflag, l_linestatus, l_shipdate, l_commitdate, 
       l_receiptdate, l_shipinstruct, l_shipmode, l_comment
FROM ext_tpch.lineitem
DISTRIBUTED BY (L_ORDERKEY);
