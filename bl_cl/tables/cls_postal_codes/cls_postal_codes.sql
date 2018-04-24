BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl.cls_postal_codes';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl.cls_postal_codes (
    postal_code_id   NUMBER(10,0) NOT NULL,
    postal_code      NVARCHAR2(50) NOT NULL
);