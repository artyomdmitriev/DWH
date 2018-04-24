BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl.cls_cities';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl.cls_cities (
    city_id      NUMBER(10,0) NOT NULL,
    city_code    NVARCHAR2(50) NOT NULL,
    city_name    NVARCHAR2(255) NOT NULL,
    country_id   NUMBER(10) NOT NULL
);