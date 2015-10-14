SELECT t1.id, t1.table_name, CASE WHEN c.relstorage <> 'x' THEN c.reltuples::int ELSE 0 END AS tuples, t1.duration::interval AS hawq_duration
FROM reports.cms t1
JOIN pg_class c on split_part(t1.table_name, '.', 2) = c.relname
JOIN pg_namespace n on split_part(t1.table_name, '.', 1) = n.nspname and c.relnamespace = n.oid
UNION ALL
SELECT t1.id, t1.table_name, -1, t1.duration::interval
FROM reports.cms t1
WHERE split_part(t1.table_name, '.', 1) = 'query'
UNION ALL
SELECT -1, 'Totals' as table_name, sum(CASE WHEN c.relstorage <> 'x' THEN c.reltuples::int ELSE 0 END) AS tuples, sum(t1.duration)
FROM reports.cms t1
JOIN pg_class c on split_part(t1.table_name, '.', 2) = c.relname
JOIN pg_namespace n on split_part(t1.table_name, '.', 1) = n.nspname and c.relnamespace = n.oid;
