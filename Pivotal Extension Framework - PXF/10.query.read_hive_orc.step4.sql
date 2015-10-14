--HAWQ Query on the Hive Table stored as ORC
SELECT title, count(*), sum(salary) FROM pxf.hive_orc GROUP BY title ORDER BY 2 DESC;
