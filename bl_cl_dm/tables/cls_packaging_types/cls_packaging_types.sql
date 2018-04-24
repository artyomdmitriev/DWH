BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl_dm.cls_packaging_types';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl_dm.cls_packaging_types (
    packaging_type_id_dm         NUMBER(10,0),
    packaging_type_id           NUMBER(10,0),
    packaging_type_name          NVARCHAR2(255),
    packaging_type_code          NVARCHAR2(50),
    packaging_type_update_dt     DATE,
    packaging_type_insert_dt     DATE
);