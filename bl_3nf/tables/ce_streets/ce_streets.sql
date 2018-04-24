BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_3nf.ce_streets';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_3nf.ce_streets (
    street_id        NUMBER(10) NOT NULL,
    street_code      NVARCHAR2(50) NOT NULL,
    street_name      NVARCHAR2(255) NOT NULL,
    postal_code_id   NUMBER(10) NOT NULL,
    city_id          NUMBER(10) NOT NULL
);

ALTER TABLE bl_3nf.ce_streets ADD CONSTRAINT streets_pk PRIMARY KEY ( street_id );

ALTER TABLE bl_3nf.ce_streets
    ADD CONSTRAINT streets_cities_fk FOREIGN KEY ( city_id )
        REFERENCES bl_3nf.ce_cities ( city_id );

ALTER TABLE bl_3nf.ce_streets
    ADD CONSTRAINT streets_postal_code_fk FOREIGN KEY ( postal_code_id )
        REFERENCES bl_3nf.ce_postal_codes ( postal_code_id );

INSERT INTO bl_3nf.ce_streets (
    street_id,
    street_code,
    street_name,
    postal_code_id,
    city_id
) VALUES (
    -1,
    'N/D',
    'N/D',
    -1,
    -1
);

COMMIT;