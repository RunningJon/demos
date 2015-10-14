CREATE TABLE cms.dim_bene_age_cat
(bene_age_cat_cd int not null,
 description varchar)
DISTRIBUTED BY (bene_age_cat_cd);

INSERT INTO cms.dim_bene_age_cat VALUES (1, 'Under 65');
INSERT INTO cms.dim_bene_age_cat VALUES (2, '65-69');
INSERT INTO cms.dim_bene_age_cat VALUES (3, '70-74');
INSERT INTO cms.dim_bene_age_cat VALUES (4, '75-79');
INSERT INTO cms.dim_bene_age_cat VALUES (5, '80-84');
INSERT INTO cms.dim_bene_age_cat VALUES (6, '85 and older');

ANALYZE cms.dim_bene_age_cat;

