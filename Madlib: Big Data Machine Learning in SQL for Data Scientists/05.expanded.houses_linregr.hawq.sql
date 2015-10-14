--Examine the resulting models

SELECT unnest(ARRAY['intercept','tax','bath','size', 'lot']) as attribute,
       unnest(coef) as coefficient,
       unnest(std_err) as standard_error,
       unnest(t_stats) as t_stat,
       unnest(p_values) as pvalue
FROM mad.houses_linregr;
