BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl.cls_streets';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl.cls_streets (
    street_id        NUMBER(10,0) NOT NULL,
    street_code      NVARCHAR2(50) NOT NULL,
    street_name      NVARCHAR2(255) NOT NULL,
    postal_code_id   NUMBER(10,0) NOT NULL,
    city_id          NUMBER(10,0) NOT NULL
);