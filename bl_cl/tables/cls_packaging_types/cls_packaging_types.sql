BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl.cls_packaging_types';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl.cls_packaging_types (
    packaging_type_id     NUMBER(10,0) NOT NULL,
    packaging_type_name   NVARCHAR2(255) NOT NULL,
    packaging_type_code   NVARCHAR2(50) NOT NULL
);