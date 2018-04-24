BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_3nf.ce_packaging_types';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_3nf.ce_packaging_types (
    packaging_type_id          NUMBER(10) NOT NULL,
    packaging_type_name        NVARCHAR2(255) NOT NULL,
    packaging_type_code        NVARCHAR2(50) NOT NULL,
    packaging_type_update_dt   DATE NOT NULL,
    packaging_type_insert_dt   DATE NOT NULL
);

ALTER TABLE bl_3nf.ce_packaging_types ADD CONSTRAINT packaging_types_pk PRIMARY KEY ( packaging_type_id );

INSERT INTO bl_3nf.ce_packaging_types (
    packaging_type_id,
    packaging_type_name,
    packaging_type_code,
    packaging_type_update_dt,
    packaging_type_insert_dt
) VALUES (
    -1,
    'N/D',
    'N/D',
    TO_DATE('01/01/1900','DD/MM/YYYY'),
    TO_DATE('01/01/1900','DD/MM/YYYY')
);

COMMIT;