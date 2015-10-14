--HAWQ Query on the Hive Table stored as Parquet
SELECT title, count(*), sum(salary) FROM pxf.hive_parquet GROUP BY title ORDER BY 2 DESC;
