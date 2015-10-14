CREATE TABLE cms.dim_bene_sex_ident
(bene_sex_ident_cd int not null,
 description varchar)
DISTRIBUTED BY (bene_sex_ident_cd);

INSERT INTO cms.dim_bene_sex_ident VALUES (1, 'Male');
INSERT INTO cms.dim_bene_sex_ident VALUES (2, 'Female');

ANALYZE cms.dim_bene_sex_ident;

