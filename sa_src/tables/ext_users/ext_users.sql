BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE sa_src.ext_users';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE sa_src.ext_users (
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
)

organization EXTERNAL (TYPE ORACLE_LOADER
    DEFAULT DIRECTORY data_source_dir
ACCESS PARAMETERS ( RECORDS DELIMITED BY 0x '0D0A'
    CHARACTERSET WE8MSWIN1252
    SKIP 1
    BADFILE data_source_dir :'data.bad'
    NODISCARDFILE
    NOLOGFILE
    FIELDS TERMINATED BY '|' MISSING FIELD VALUES ARE NULL (
        user_id CHAR ( 200 ),
        first_name CHAR ( 200 ),
        last_name CHAR ( 200 ),
        gender CHAR ( 200 ),
        email CHAR ( 200 ),
        date_of_birth CHAR ( 200 ),
        country CHAR ( 200 ),
        city_code CHAR ( 200 ),
        city CHAR ( 200 ),
        street_code CHAR ( 200 ),
        street_name CHAR ( 200 ),
        building_code CHAR ( 200 ),
        building_number CHAR ( 200 ),
        apartment CHAR ( 200 ),
        postal_code CHAR ( 200 )
    )
) location('users_spoiled.dsv') ) reject limit unlimited;