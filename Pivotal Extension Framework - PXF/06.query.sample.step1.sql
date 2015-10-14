--Query the HAWQ table
SELECT title, count(*), sum(salary) FROM pxf.sample GROUP BY title ORDER BY 2 DESC;
