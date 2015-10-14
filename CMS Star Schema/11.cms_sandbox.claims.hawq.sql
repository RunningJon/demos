CREATE TABLE cms_sandbox.claims
WITH (appendonly=true,orientation=parquet, compresstype=snappy) AS
SELECT c.car_line_id, a.description as age_group, s.description as gender, l.description as cms_type_service, p.description as cms_location, d.description as icd9_description, c.car_line_srvc_cnt, c.car_hcpcs_pmt_amt
FROM cms.claims c
JOIN cms.dim_bene_age_cat a on c.bene_age_cat_cd = a.bene_age_cat_cd
JOIN cms.dim_bene_sex_ident s on c.bene_sex_ident_cd = s.bene_sex_ident_cd
JOIN cms.dim_car_line_cms_type_srvc l on c.car_line_cms_type_srvc_cd = l.car_line_cms_type_srvc_cd 
JOIN cms.dim_car_line_place_of_srvc p on c.car_line_place_of_srvc_cd = p.car_line_place_of_srvc_cd
LEFT OUTER JOIN cms.dim_icd9_cat d on c.car_line_icd9_dgns_cd = d.car_line_icd9_dgns_cd
DISTRIBUTED BY (car_line_id);
