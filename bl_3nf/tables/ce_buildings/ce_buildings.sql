BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_3nf.ce_buildings';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_3nf.ce_buildings (
    building_id       NUMBER(10) NOT NULL,
    building_code     NVARCHAR2(50) NOT NULL,
    building_number   NVARCHAR2(50) NOT NULL,
    street_id         NUMBER(10) NOT NULL
);

ALTER TABLE bl_3nf.ce_buildings ADD CONSTRAINT buildings_pk PRIMARY KEY ( building_id );

ALTER TABLE bl_3nf.ce_buildings
    ADD CONSTRAINT buildings_streets_fk FOREIGN KEY ( street_id )
        REFERENCES bl_3nf.ce_streets ( street_id );

INSERT INTO bl_3nf.ce_buildings (
    building_id,
    building_code,
    building_number,
    street_id
) VALUES (
    -1,
    'N/D',
    'N/D',
    -1
);

COMMIT;