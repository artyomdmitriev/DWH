BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_3nf.ce_postal_codes';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_3nf.ce_postal_codes (
    postal_code_id   NUMBER(10) NOT NULL,
    postal_code      NVARCHAR2(50) NOT NULL
);

ALTER TABLE bl_3nf.ce_postal_codes ADD CONSTRAINT postal_code_pk PRIMARY KEY ( postal_code_id );

INSERT INTO bl_3nf.ce_postal_codes (
    postal_code_id,
    postal_code
) VALUES (
    -1,
    'N/D'
);

COMMIT;
