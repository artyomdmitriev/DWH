BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_3nf.ce_countries';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_3nf.ce_countries (
    country_id     NUMBER(10) NOT NULL,
    country_code   NVARCHAR2(50) NOT NULL,
    country_name   NVARCHAR2(255) NOT NULL
);

ALTER TABLE bl_3nf.ce_countries ADD CONSTRAINT countries_pk PRIMARY KEY ( country_id );

INSERT INTO bl_3nf.ce_countries (
    country_id,
    country_code,
    country_name
) VALUES (
    -1,
    'N/D',
    'N/D'
);

COMMIT;