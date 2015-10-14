SELECT cms_location, count(*), sum(car_line_srvc_cnt), sum(car_hcpcs_pmt_amt)
FROM cms_sandbox.claims
GROUP BY cms_location
ORDER BY 4 DESC; 
