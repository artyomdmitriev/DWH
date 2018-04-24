BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl.cls_buildings';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl.cls_buildings (
    building_id       NUMBER(10,0) NOT NULL,
    building_code     NVARCHAR2(50) NOT NULL,
    building_number   NVARCHAR2(50) NOT NULL,
    street_id         NUMBER(10,0) NOT NULL
);