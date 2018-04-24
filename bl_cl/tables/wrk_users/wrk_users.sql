BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl.wrk_users';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl.wrk_users (
    user_id           NVARCHAR2(200),
    first_name        NVARCHAR2(200),
    last_name         NVARCHAR2(200),
    gender            NVARCHAR2(200),
    email             NVARCHAR2(200),
    date_of_birth     NVARCHAR2(200),
    country           NVARCHAR2(200),
    city_code         NVARCHAR2(200),
    city              NVARCHAR2(200),
    street_code       NVARCHAR2(200),
    street_name       NVARCHAR2(200),
    building_code     NVARCHAR2(200),
    building_number   NVARCHAR2(200),
    apartment         NVARCHAR2(200),
    postal_code       NVARCHAR2(200)
);