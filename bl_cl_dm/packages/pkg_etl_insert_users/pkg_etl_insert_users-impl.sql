CREATE OR REPLACE PACKAGE BODY pkg_etl_insert_users AS
  /**===============================================*\
  Name...............:   pkg_etl_insert_users
  Contents...........:   Implementation of ETL process of loading dim_users
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/20/2018
  \*=============================================== */

    PROCEDURE insert_cls_users
        AS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table cls_users';
        INSERT INTO cls_users
            SELECT
                DECODE(dim_users.user_id,NULL,dim_users_seq.NEXTVAL,dim_users.user_id_dm),
                usr.user_id,
                usr.user_code,
                usr.user_first_name,
                usr.user_last_name,
                usr.user_email,
                usr.user_gender,
                usr.user_date_of_birth,
                usr.building_id,
                usr.building_code,
                usr.building_number,
                usr.street_id,
                usr.street_code,
                usr.street_name,
                usr.postal_code_id,
                usr.postal_code,
                usr.city_id,
                usr.city_code,
                usr.city_name,
                usr.country_id,
                usr.country_code,
                usr.country_name
            FROM
                (
                    SELECT
                        cu.user_id,
                        cu.user_code,
                        cu.user_first_name,
                        cu.user_last_name,
                        cu.user_email,
                        cu.user_gender,
                        cu.user_date_of_birth,
                        cu.building_id,
                        cb.building_code,
                        cb.building_number,
                        cs.street_id,
                        cs.street_code,
                        cs.street_name,
                        cpc.postal_code_id,
                        cpc.postal_code,
                        cc.city_id,
                        cc.city_code,
                        cc.city_name,
                        cco.country_id,
                        cco.country_code,
                        cco.country_name
                    FROM
                        ce_users cu,
                        ce_buildings cb,
                        ce_streets cs,
                        ce_postal_codes cpc,
                        ce_cities cc,
                        ce_countries cco
                    WHERE
                        cu.building_id = cb.building_id
                        AND   cb.street_id = cs.street_id
                        AND   cs.postal_code_id = cpc.postal_code_id
                        AND   cs.city_id = cc.city_id
                        AND   cc.country_id = cco.country_id
                ) usr,
                dim_users
            WHERE
                usr.user_id = dim_users.user_id (+);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_cls_users;

    -----------------------------------------------------------------------------------------------

    PROCEDURE insert_dim_users
        IS
    BEGIN
        MERGE INTO dim_users dest USING ( SELECT
            user_id_dm,
            user_id,
            user_code,
            user_first_name,
            user_last_name,
            user_email,
            user_gender,
            user_date_of_birth,
            building_id,
            building_code,
            building_number,
            street_id,
            street_code,
            street_name,
            postal_code_id,
            postal_code,
            city_id,
            city_code,
            city_name,
            country_id,
            country_code,
            country_name
                                          FROM
            cls_users
        MINUS
        SELECT
            user_id_dm,
            user_id,
            user_code,
            user_first_name,
            user_last_name,
            user_email,
            user_gender,
            user_date_of_birth,
            building_id,
            building_code,
            building_number,
            street_id,
            street_code,
            street_name,
            postal_code_id,
            postal_code,
            city_id,
            city_code,
            city_name,
            country_id,
            country_code,
            country_name
        FROM
            dim_users
        )
        src ON ( src.user_id_dm = dest.user_id_dm )
        WHEN MATCHED THEN UPDATE SET dest.user_id = src.user_id,
        dest.user_code = src.user_code,
        dest.user_first_name = src.user_first_name,
        dest.user_last_name = src.user_last_name,
        dest.user_email = src.user_email,
        dest.user_gender = src.user_gender,
        dest.user_date_of_birth = src.user_date_of_birth,
        dest.user_update_dt = SYSDATE,
        dest.building_id = src.building_id,
        dest.building_code = src.building_code,
        dest.building_number = src.building_number,
        dest.street_id = src.street_id,
        dest.street_code = src.street_code,
        dest.street_name = src.street_name,
        dest.postal_code_id = src.postal_code_id,
        dest.postal_code = src.postal_code,
        dest.city_id = src.city_id,
        dest.city_code = src.city_code,
        dest.city_name = src.city_name,
        dest.country_id = src.country_id,
        dest.country_code = src.country_code,
        dest.country_name = src.country_name
        WHEN NOT MATCHED THEN INSERT (
            user_id_dm,
                                                                                                    user_id,
                                                                                                user_code,
                                                                                            user_first_name,
                                                                                        user_last_name,
                                                                                    user_email,
                                                                                user_gender,
                                                                            user_date_of_birth,
                                                                        user_insert_dt,
                                                                    user_update_dt,
                                                                building_id,
                                                            building_code,
                                                        building_number,
                                                    street_id,
                                                street_code,
                                            street_name,
                                        postal_code_id,
                                    postal_code,
                                city_id,
                            city_code,
                        city_name,
                    country_id,
                country_code,
            country_name
        ) VALUES (
            src.user_id_dm,
                                                                                                    src.user_id,
                                                                                                src.user_code,
                                                                                            src.user_first_name,
                                                                                        src.user_last_name,
                                                                                    src.user_email,
                                                                                src.user_gender,
                                                                            src.user_date_of_birth,
                                                                        SYSDATE,
                                                                    SYSDATE,
                                                                src.building_id,
                                                            src.building_code,
                                                        src.building_number,
                                                    src.street_id,
                                                src.street_code,
                                            src.street_name,
                                        src.postal_code_id,
                                    src.postal_code,
                                src.city_id,
                            src.city_code,
                        src.city_name,
                    src.country_id,
                src.country_code,
            src.country_name
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_dim_users;

END;
/