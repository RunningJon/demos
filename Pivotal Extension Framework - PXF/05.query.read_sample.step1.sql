--Query the External Table 
SELECT title, count(*), sum(salary) FROM pxf.read_sample GROUP BY title ORDER BY 2 DESC;
