BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_3nf.ce_cities';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_3nf.ce_cities (
    city_id      NUMBER(10) NOT NULL,
    city_code    NVARCHAR2(50) NOT NULL,
    city_name    NVARCHAR2(255) NOT NULL,
    country_id   NUMBER(10) NOT NULL
);

ALTER TABLE bl_3nf.ce_cities ADD CONSTRAINT cities_pk PRIMARY KEY ( city_id );

ALTER TABLE bl_3nf.ce_cities
    ADD CONSTRAINT cities_countries_fk FOREIGN KEY ( country_id )
        REFERENCES bl_3nf.ce_countries ( country_id );

INSERT INTO bl_3nf.ce_cities (
    city_id,
    city_code,
    city_name,
    country_id
) VALUES (
    -1,
    'N/D',
    'N/D',
    -1
);

COMMIT;