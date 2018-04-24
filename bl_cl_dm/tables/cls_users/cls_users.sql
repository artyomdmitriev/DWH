BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl_dm.cls_users';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl_dm.cls_users (
    user_id_dm           NUMBER(10,0),
    user_id              NUMBER(10,0),
    user_code            NVARCHAR2(50),
    user_first_name      NVARCHAR2(255),
    user_last_name       NVARCHAR2(255),
    user_email           NVARCHAR2(255),
    user_gender          NVARCHAR2(20),
    user_date_of_birth   DATE,
    building_id          NUMBER(10),
    building_code        NVARCHAR2(50),
    building_number      NVARCHAR2(50),
    street_id            NUMBER(10),
    street_code          NVARCHAR2(50),
    street_name          NVARCHAR2(255),
    postal_code_id       NUMBER(10),
    postal_code          NVARCHAR2(50),
    city_id              NUMBER(10,0),
    city_code            NVARCHAR2(50),
    city_name            NVARCHAR2(255),
    country_id           NUMBER(10,0),
    country_code         NVARCHAR2(50),
    country_name         NVARCHAR2(255)
);