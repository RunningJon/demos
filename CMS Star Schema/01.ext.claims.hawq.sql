CREATE EXTERNAL TABLE ext.claims
(
  car_line_id character varying(20),
  bene_sex_ident_cd int,
  bene_age_cat_cd int,
  car_line_icd9_dgns_cd character varying(10),
  car_line_hcpcs_cd character varying(10),
  car_line_betos_cd character varying(5),
  car_line_srvc_cnt int,
  car_line_prvdr_type_cd int,
  car_line_cms_type_srvc_cd character varying(5),
  car_line_place_of_srvc_cd int,
  car_hcpcs_pmt_amt int
)
LOCATION (:LOCATION) 
FORMAT 'CSV' (QUOTE AS '"');
