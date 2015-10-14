SELECT icd9_description, count(*), sum(car_line_srvc_cnt), sum(car_hcpcs_pmt_amt)
FROM cms_sandbox.claims
GROUP BY icd9_description
ORDER BY 4 DESC
LIMIT 20;
