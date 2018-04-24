BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl.cls_countries';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl.cls_countries (
    country_id     NUMBER(10,0) NOT NULL,
    country_code   NVARCHAR2(50) NOT NULL,
    country_name   NVARCHAR2(255) NOT NULL
);