CREATE OR REPLACE PACKAGE BODY bl_cl.pkg_etl_insert_delivery_addresses AS

  /**===============================================*\
  Name...............:   pkg_etl_insert_delivery_addresses
  Contents...........:   Implementation of ETL process for loading ce_delivery_addresses
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/20/2018
  \*=============================================== */

    PROCEDURE insert_wrk_transactions
        IS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table wrk_transactions';
        INSERT INTO wrk_transactions
            SELECT DISTINCT
                invoice_no,
                quantity,
                tax_amount,
                total_price,
                transaction_date,
                user_id,
                product_id,
                country,
                city_code,
                city,
                street_code,
                street_name,
                building_code,
                building,
                postal_code
            FROM
                ext_transactions;

        COMMIT;
        dbms_output.put_line('WRK_TRANSACTIONS loaded');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Errors loading WRK_TRANSACTIONS');
            RAISE;
    END insert_wrk_transactions;
    
    -----------------------------------------------------------------------------------

    PROCEDURE insert_wrk_users
        IS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table wrk_users';
        INSERT INTO wrk_users
            SELECT
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

        COMMIT;
        dbms_output.put_line('WRK_USERS loaded');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Errors loading WRK_USERS');
            RAISE;
    END insert_wrk_users;

    -----------------------------------------------------------------------------------

    PROCEDURE insert_wrk_countries_codes
        IS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table wrk_countries_codes';
        INSERT INTO wrk_countries_codes
            SELECT
                country_id,
                country_desc,
                country_code
            FROM
                ext_countries_codes;

        COMMIT;
        dbms_output.put_line('WRK_COUNTRIES_CODES loaded');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Errors loading WRK_COUNTRIES_CODES');
            RAISE;
    END insert_wrk_countries_codes;
    
    -----------------------------------------------------------------------------------    

    PROCEDURE insert_cls_countries
        AS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table cls_countries';
        INSERT INTO cls_countries (
            country_id,
            country_name,
            country_code
        )
            SELECT
                DECODE(ce_countries.country_code,NULL,ce_countries_seq.NEXTVAL,ce_countries.country_id),
                coun.country_name,
                coun.country_code
            FROM
                (
                    SELECT
                        wcc.country_code country_code,
                        fix_country_name(wt.country) country_name
                    FROM
                        wrk_transactions wt,
                        wrk_countries_codes wcc
                    WHERE
                        fix_country_name(wt.country) = wcc.country_desc
                    GROUP BY
                        fix_country_name(wt.country),
                        wcc.country_code
                    UNION
                    SELECT
                        wcc.country_code country_code,
                        fix_country_name(wu.country) country_name
                    FROM
                        wrk_users wu,
                        wrk_countries_codes wcc
                    WHERE
                        fix_country_name(wu.country) = wcc.country_desc
                    GROUP BY
                        fix_country_name(wu.country),
                        wcc.country_code
                ) coun,
                ce_countries
            WHERE
                coun.country_code = ce_countries.country_code (+);

        COMMIT;
        dbms_output.put_line('CLS_COUNTRIES loaded');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Errors loading CLS_COUNTRIES');
            RAISE;
    END insert_cls_countries;

    -----------------------------------------------------------------------------------

    PROCEDURE insert_cls_cities
        AS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table cls_cities';
        INSERT INTO cls_cities (
            city_id,
            city_code,
            city_name,
            country_id
        )
            SELECT
                DECODE(ce_cities.city_code,NULL,ce_cities_seq.NEXTVAL,ce_cities.city_id),
                cit.city_code,
                cit.city,
                nvl(cit.country_id, -1)
            FROM
                (
                    SELECT
                        wt.city,
                        wt.city_code,
                        country_id
                    FROM
                        wrk_transactions wt,
                        ce_countries
                    WHERE
                        fix_country_name(wt.country) = ce_countries.country_name
                    GROUP BY
                        wt.city,
                        wt.city_code,
                        country_id
                    UNION
                    SELECT
                        wu.city,
                        wu.city_code,
                        country_id
                    FROM
                        wrk_users wu,
                        ce_countries
                    WHERE
                        fix_country_name(wu.country) = ce_countries.country_name
                    GROUP BY
                        wu.city,
                        wu.city_code,
                        country_id
                ) cit,
                ce_cities
            WHERE
                cit.city_code = ce_cities.city_code (+);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_cls_cities;
    
    -----------------------------------------------------------------------------------

    PROCEDURE insert_cls_postal_codes
        AS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table cls_postal_codes';
        INSERT INTO cls_postal_codes (
            postal_code_id,
            postal_code
        )
            SELECT
                DECODE(ce_postal_codes.postal_code,NULL,ce_postal_codes_seq.NEXTVAL,ce_postal_codes.postal_code_id),
                pc.postal_code
            FROM
                (
                    SELECT
                        wt.postal_code
                    FROM
                        wrk_users wt
                    GROUP BY
                        wt.postal_code
                    UNION
                    SELECT
                        postal_code
                    FROM
                        wrk_users wu
                    GROUP BY
                        wu.postal_code
                ) pc,
                ce_postal_codes
            WHERE
                pc.postal_code = ce_postal_codes.postal_code (+);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_cls_postal_codes;
    
    -----------------------------------------------------------------------------------

    PROCEDURE insert_cls_streets
        AS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table cls_streets';
        INSERT INTO cls_streets (
            street_id,
            street_code,
            street_name,
            postal_code_id,
            city_id
        )
            SELECT
                DECODE(ce_streets.street_code,NULL,ce_streets_seq.NEXTVAL,ce_streets.street_id),
                st.street_code,
                nvl(st.street_name, 'N/D'),
                nvl(st.postal_code_id, -1),
                nvl(st.city_id, -1)
            FROM
                (
                    SELECT
                        wt.street_code,
                        wt.street_name,
                        pc.postal_code_id,
                        c.city_id
                    FROM
                        wrk_transactions wt
                        INNER JOIN ce_postal_codes pc ON wt.postal_code = pc.postal_code
                        INNER JOIN ce_cities c ON wt.city_code = c.city_code
                    GROUP BY
                        wt.street_code,
                        wt.street_name,
                        pc.postal_code_id,
                        c.city_id
                    UNION
                    SELECT
                        wu.street_code,
                        wu.street_name,
                        pc.postal_code_id,
                        c.city_id
                    FROM
                        wrk_users wu
                        INNER JOIN ce_postal_codes pc ON wu.postal_code = pc.postal_code
                        INNER JOIN ce_cities c ON wu.city_code = c.city_code
                    GROUP BY
                        wu.street_code,
                        wu.street_name,
                        pc.postal_code_id,
                        c.city_id
                ) st,
                ce_streets
            WHERE
                st.street_code = ce_streets.street_code (+);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_cls_streets;

    -----------------------------------------------------------------------------------

    PROCEDURE insert_cls_buildings
        AS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table cls_buildings';
        INSERT INTO cls_buildings (
            building_id,
            building_code,
            building_number,
            street_id
        )
            SELECT
                DECODE(ce_buildings.building_code,NULL,ce_buildings_seq.NEXTVAL,ce_buildings.building_id),
                buil.building_code,
                nvl(buil.building, 'N/D'),
                nvl(buil.street_id, -1)
            FROM
                (
                    SELECT
                        wt.building,
                        wt.building_code,
                        str.street_id
                    FROM
                        wrk_transactions wt
                        INNER JOIN ce_streets str ON wt.street_code = str.street_code
                    GROUP BY
                        wt.building,
                        wt.building_code,
                        str.street_id
                    UNION
                    SELECT
                        wu.building_number,
                        wu.building_code,
                        str.street_id
                    FROM
                        wrk_users wu
                        INNER JOIN ce_streets str ON wu.street_code = str.street_code
                    GROUP BY
                        wu.building_number,
                        wu.building_code,
                        str.street_id
                ) buil,
                ce_buildings
            WHERE
                buil.building_code = ce_buildings.building_code (+);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_cls_buildings;
    
    ---------------------------------------------------------------------------------

    PROCEDURE insert_ce_countries
        IS
    BEGIN
        MERGE INTO ce_countries dest USING ( SELECT
            country_id,
            country_code,
            country_name
                                             FROM
            cls_countries
        MINUS
        SELECT
            country_id,
            country_code,
            country_name
        FROM
            ce_countries
        )
        src ON ( src.country_id = dest.country_id )
        WHEN MATCHED THEN UPDATE SET dest.country_name = src.country_name,
        dest.country_code = src.country_code
        WHEN NOT MATCHED THEN INSERT (
            country_id,
                country_code,
            country_name
        ) VALUES (
            src.country_id,
                src.country_code,
            src.country_name
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_ce_countries;  
    
    -----------------------------------------------------------------------------------

    PROCEDURE insert_ce_cities
        IS
    BEGIN
        MERGE INTO ce_cities dest USING ( SELECT
            city_id,
            city_code,
            city_name,
            country_id
                                          FROM
            cls_cities
        MINUS
        SELECT
            city_id,
            city_code,
            city_name,
            country_id
        FROM
            ce_cities
        )
        src ON ( src.city_id = dest.city_id )
        WHEN MATCHED THEN UPDATE SET dest.city_name = src.city_name,
        dest.city_code = src.city_code,
        dest.country_id = src.country_id
        WHEN NOT MATCHED THEN INSERT (
            city_id,
                    city_code,
                city_name,
            country_id
        ) VALUES (
            src.city_id,
                    src.city_code,
                src.city_name,
            src.country_id
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_ce_cities;  

        -----------------------------------------------------------------------------------

    PROCEDURE insert_ce_postal_codes
        IS
    BEGIN
        MERGE INTO ce_postal_codes dest USING ( SELECT
            postal_code_id,
            postal_code
                                                FROM
            cls_postal_codes
        MINUS
        SELECT
            postal_code_id,
            postal_code
        FROM
            ce_postal_codes
        )
        src ON ( src.postal_code_id = dest.postal_code_id )
        WHEN MATCHED THEN UPDATE SET dest.postal_code = src.postal_code
        WHEN NOT MATCHED THEN INSERT (
            postal_code_id,
            postal_code
        ) VALUES (
            src.postal_code_id,
            src.postal_code
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_ce_postal_codes;  
    
    -----------------------------------------------------------------------------------

    PROCEDURE insert_ce_streets
        IS
    BEGIN
        MERGE INTO ce_streets dest USING ( SELECT
            street_id,
            street_code,
            street_name,
            postal_code_id,
            city_id
                                           FROM
            cls_streets
        MINUS
        SELECT
            street_id,
            street_code,
            street_name,
            postal_code_id,
            city_id
        FROM
            ce_streets
        )
        src ON ( src.street_id = dest.street_id )
        WHEN MATCHED THEN UPDATE SET dest.street_name = src.street_name,
        dest.postal_code_id = src.postal_code_id,
        dest.city_id = src.city_id
        WHEN NOT MATCHED THEN INSERT (
            street_id,
                        street_code,
                    street_name,
                postal_code_id,
            city_id
        ) VALUES (
            src.street_id,
                        src.street_code,
                    src.street_name,
                src.postal_code_id,
            src.city_id
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_ce_streets;  
    
    -----------------------------------------------------------------------------------

    PROCEDURE insert_ce_buildings
        IS
    BEGIN
        MERGE INTO ce_buildings dest USING ( SELECT
            building_id,
            building_code,
            building_number,
            street_id
                                             FROM
            cls_buildings
        MINUS
        SELECT
            building_id,
            building_code,
            building_number,
            street_id
        FROM
            ce_buildings
        )
        src ON ( src.building_id = dest.building_id )
        WHEN MATCHED THEN UPDATE SET dest.building_code = src.building_code,
        dest.building_number = src.building_number,
        dest.street_id = src.street_id
        WHEN NOT MATCHED THEN INSERT (
            building_id,
                    building_code,
                building_number,
            street_id
        ) VALUES (
            src.building_id,
                    src.building_code,
                src.building_number,
            src.street_id
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_ce_buildings;  
    
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