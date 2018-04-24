/**===============================================*\
Name...............:   dim_users
Contents...........:   Contains users information
Author.............:   Artsemi Dzmitryieu
Date...............:   04/04/2018
\*=============================================== */
BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_dm.dim_users';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_dm.dim_users (
    user_id_dm           NUMBER(10) NOT NULL,
    user_id              NUMBER(10) NOT NULL,
    user_code            NVARCHAR2(50) NOT NULL,
    user_first_name      NVARCHAR2(255) NOT NULL,
    user_last_name       NVARCHAR2(255) NOT NULL,
    user_email           NVARCHAR2(255) NOT NULL,
    user_gender          NVARCHAR2(20) NOT NULL,
    user_date_of_birth   DATE NOT NULL,
    user_insert_dt       DATE NOT NULL,
    user_update_dt       DATE NOT NULL,
    building_id          NUMBER(10) NOT NULL,
    building_code        NVARCHAR2(50) NOT NULL,
    building_number      NVARCHAR2(50) NOT NULL,
    street_id            NUMBER(10) NOT NULL,
    street_code          NVARCHAR2(50) NOT NULL,
    street_name          NVARCHAR2(255) NOT NULL,
    postal_code_id       NUMBER(10) NOT NULL,
    postal_code          NVARCHAR2(50) NOT NULL,
    city_id              NUMBER(10) NOT NULL,
    city_code            NVARCHAR2(50) NOT NULL,
    city_name            NVARCHAR2(255) NOT NULL,
    country_id           NUMBER(10) NOT NULL,
    country_code         NVARCHAR2(50) NOT NULL,
    country_name         NVARCHAR2(255) NOT NULL
);

ALTER TABLE bl_dm.dim_users ADD CONSTRAINT users_pk PRIMARY KEY ( user_id_dm );

COMMENT ON TABLE bl_dm.dim_users
IS
  'Table Content: users
   Refresh Cycle/Window: data is refreshed on the 1st day of the month for the previous month
  ';

COMMENT ON column bl_dm.dim_users.user_id_dm                 IS 'Dimension surrogate key';
COMMENT ON column bl_dm.dim_users.user_id                    IS 'Surrogate key for users';
COMMENT ON column bl_dm.dim_users.user_code                  IS 'Business key for users';
COMMENT ON column bl_dm.dim_users.user_first_name            IS 'First name of user';
COMMENT ON column bl_dm.dim_users.user_last_name             IS 'Last name of user';
COMMENT ON column bl_dm.dim_users.user_email                 IS 'Email of user';
COMMENT ON column bl_dm.dim_users.user_gender                IS 'Gender of user';
COMMENT ON column bl_dm.dim_users.user_date_of_birth         IS 'Date of birth of user';
COMMENT ON column bl_dm.dim_users.user_insert_dt             IS 'Insert date';
COMMENT ON column bl_dm.dim_users.user_update_dt             IS 'Update date';
COMMENT ON column bl_dm.dim_users.building_id                IS 'Surrogate key for buildings';
COMMENT ON column bl_dm.dim_users.building_code              IS 'Business key for buildings';
COMMENT ON column bl_dm.dim_users.street_id                  IS 'Surrogate key for streets';
COMMENT ON column bl_dm.dim_users.street_name                IS 'Name of the street';
COMMENT ON column bl_dm.dim_users.postal_code_id             IS 'Surrogate key for postal codes';
COMMENT ON column bl_dm.dim_users.postal_code                IS 'Business key for postal codes';
COMMENT ON column bl_dm.dim_users.city_id                    IS 'Surrogate key for cities';
COMMENT ON column bl_dm.dim_users.city_name                  IS 'Name of the city';
COMMENT ON column bl_dm.dim_users.country_id                 IS 'Surrogate key for countries';
COMMENT ON column bl_dm.dim_users.country_code               IS 'Business key for countries';
COMMENT ON column bl_dm.dim_users.country_name               IS 'Name of the country';