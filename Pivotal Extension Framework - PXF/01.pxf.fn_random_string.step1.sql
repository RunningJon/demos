--Function is used to generate random data
CREATE OR REPLACE FUNCTION pxf.fn_random_string(p_length int) RETURNS TEXT AS 
$$
SELECT array_to_string(ARRAY(SELECT chr((65 + (random() * 25))::integer) FROM generate_series(1,$1)), '');
$$
LANGUAGE sql;
