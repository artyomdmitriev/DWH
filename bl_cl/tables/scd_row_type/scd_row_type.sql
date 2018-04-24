BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl.scd_row_type';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl.scd_row_type (
    scd_row_type_id            NUMBER NOT NULL,
    scd_row_type_description   VARCHAR2(20 CHAR) NOT NULL
);

INSERT INTO bl_cl.scd_row_type (
    scd_row_type_id,
    scd_row_type_description
) VALUES (
    1,
    'For Insert'
);

INSERT INTO bl_cl.scd_row_type (
    scd_row_type_id,
    scd_row_type_description
) VALUES (
    2,
    'For Update'
);

COMMIT;