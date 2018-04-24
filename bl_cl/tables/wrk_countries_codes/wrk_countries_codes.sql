BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl.wrk_countries_codes';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl.wrk_countries_codes (
    country_id     NUMBER(10,0),
    country_desc   VARCHAR2(200 CHAR),
    country_code   VARCHAR2(3 BYTE)
);