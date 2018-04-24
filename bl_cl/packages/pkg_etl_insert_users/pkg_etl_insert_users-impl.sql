CREATE OR REPLACE PACKAGE BODY bl_cl.pkg_etl_insert_users AS

  /**===============================================*\
  Name...............:   pkg_etl_insert_users
  Contents...........:   Implementation of ETL process for loading ce_users
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/20/2018
  \*=============================================== */

    PROCEDURE insert_wrk_users IS

        TYPE users_array IS
            TABLE OF wrk_users%rowtype INDEX BY PLS_INTEGER;
        users   users_array;
        CURSOR c_ext_users IS SELECT
            user_id,
            first_name,
            last_name,
            gender,
            email,
            date_of_birth,
            country,
            city_code,
            city,
            street_code,
            street_name,
            building_code,
            building_number,
            apartment,
            postal_code
                              FROM
            ext_users;

    BEGIN
        EXECUTE IMMEDIATE 'truncate table wrk_users';
        OPEN c_ext_users;
        LOOP
            FETCH c_ext_users BULK COLLECT INTO users;
            FORALL indx IN 1..users.count
                INSERT INTO wrk_users (
                    user_id,
                    first_name,
                    last_name,
                    gender,
                    email,
                    date_of_birth,
                    country,
                    city_code,
                    city,
                    street_code,
                    street_name,
                    building_code,
                    building_number,
                    apartment,
                    postal_code
                ) VALUES (
                    users(indx).user_id,
                    users(indx).first_name,
                    users(indx).last_name,
                    users(indx).gender,
                    users(indx).email,
                    users(indx).date_of_birth,
                    users(indx).country,
                    users(indx).city_code,
                    users(indx).city,
                    users(indx).street_code,
                    users(indx).street_name,
                    users(indx).building_code,
                    users(indx).building_number,
                    users(indx).apartment,
                    users(indx).postal_code
                );

            EXIT WHEN c_ext_users%notfound;
        END LOOP;

        CLOSE c_ext_users;
        COMMIT;
        dbms_output.put_line('WRK_USERS loaded');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Errors loading WRK_USERS');
            RAISE;
    END insert_wrk_users;
    
    -----------------------------------------------------------------------------------

    PROCEDURE insert_cls_users
        AS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table cls_users';
        INSERT INTO cls_users (
            user_id,
            user_code,
            user_first_name,
            user_last_name,
            user_email,
            user_gender,
            user_date_of_birth,
            building_id
        )
            SELECT
                DECODE(ce_users.user_code,NULL,ce_users_seq.NEXTVAL,ce_users.user_id),
                usr.user_id,
                initcap(usr.first_name),
                initcap(usr.last_name),
                nvl(replace(usr.email,'[at]','@'), 'N/D'),
                nvl(usr.gender, 'N/D'),
                nvl(fix_date(usr.date_of_birth), TO_DATE('01/01/1900','DD/MM/YYYY')),
                nvl(usr.building_id, -1)
            FROM
                (
                    SELECT
                        fix_user_id(wu.user_id) user_id,
                        wu.first_name,
                        wu.last_name,
                        wu.gender,
                        wu.email,
                        wu.date_of_birth,
                        MAX(buil.building_id) building_id
                    FROM
                        wrk_users wu
                        JOIN ce_buildings buil ON wu.building_code = buil.building_code
                    GROUP BY
                        fix_user_id(wu.user_id),
                        wu.first_name,
                        wu.last_name,
                        wu.gender,
                        wu.email,
                        wu.date_of_birth
                ) usr,
                ce_users
            WHERE
                fix_user_id(usr.user_id) = ce_users.user_code (+);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_cls_users;
    
    -----------------------------------------------------------------------------------

    PROCEDURE insert_ce_users
        IS
    BEGIN
        MERGE INTO ce_users dest USING ( SELECT
            user_id,
            user_code,
            user_first_name,
            user_last_name,
            user_email,
            user_gender,
            user_date_of_birth,
            building_id
                                         FROM
            cls_users
        MINUS
        SELECT
            user_id,
            user_code,
            user_first_name,
            user_last_name,
            user_email,
            user_gender,
            user_date_of_birth,
            building_id
        FROM
            ce_users
        )
        src ON ( src.user_id = dest.user_id )
        WHEN MATCHED THEN UPDATE SET dest.user_first_name = src.user_first_name,
        dest.user_last_name = src.user_last_name,
        dest.user_email = src.user_email,
        dest.user_gender = src.user_gender,
        dest.user_date_of_birth = src.user_date_of_birth,
        dest.building_id = src.building_id,
        dest.user_update_dt = SYSDATE
        WHEN NOT MATCHED THEN INSERT (
            user_id,
                                            user_code,
                                        user_first_name,
                                    user_last_name,
                                user_email,
                            user_gender,
                        user_date_of_birth,
                    user_update_dt,
                user_insert_dt,
            building_id
        ) VALUES (
            src.user_id,
                                            src.user_code,
                                        src.user_first_name,
                                    src.user_last_name,
                                src.user_email,
                            src.user_gender,
                        src.user_date_of_birth,
                    SYSDATE,
                SYSDATE,
            src.building_id
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_ce_users;  
    
    -- FUNCTIONS
    
    -- removes all special symbols (.,!) and replaces # with zeros

    FUNCTION fix_user_id (
        user_id VARCHAR2
    ) RETURN VARCHAR2 AS
        fixed_user_id   NVARCHAR2(50);
    BEGIN
        fixed_user_id := regexp_replace(user_id,'[,.!]','');
        fixed_user_id := regexp_replace(fixed_user_id,'#','0');
        RETURN fixed_user_id;
    END fix_user_id;
        
        ----------------------------------------------------------------

    FUNCTION fix_country_name (
        country_name VARCHAR2
    ) RETURN VARCHAR2 AS
        fixed_country_name   VARCHAR2(255);
    BEGIN
        fixed_country_name :=
            CASE lower(country_name)
                WHEN 'united kingdom' THEN 'United Kingdom of Great Britain and Northern Ireland'
                WHEN 'germany' THEN 'Germany'
                WHEN 'france' THEN 'France'
                WHEN 'denmark' THEN 'Denmark'
                WHEN 'sweden' THEN 'Sweden'
                WHEN 'canada' THEN 'Canada'
                WHEN 'usa' THEN 'United States of America'
                ELSE country_name
            END;

        RETURN fixed_country_name;
    END fix_country_name;
        
        -------------------------------------------------------------

    FUNCTION fix_date (
        dt VARCHAR2
    ) RETURN DATE AS
        fixed_date_str   VARCHAR2(50);
        fixed_date       DATE;
    BEGIN
        fixed_date_str := regexp_replace(dt,'[/.]','-');
        fixed_date := TO_DATE(fixed_date_str,'yyyy-mm-dd');
        RETURN fixed_date;
    END fix_date;

END;
/