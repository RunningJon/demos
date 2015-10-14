SELECT gender, count(*), sum(car_line_srvc_cnt), sum(car_hcpcs_pmt_amt)
FROM cms_sandbox.claims
GROUP BY gender
ORDER BY 4 DESC;
