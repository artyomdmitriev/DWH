BEGIN
    EXECUTE IMMEDIATE 'DROP PACKAGE bl_cl.pkg_etl_insert_users';
EXCEPTION
    WHEN OTHERS THEN
        IF
            sqlcode !=-4043
        THEN
            RAISE;
        END IF;
END;
/

CREATE OR REPLACE PACKAGE bl_cl.pkg_etl_insert_users AS
  /**===============================================*\
  Name...............:   pkg_etl_insert_users
  Contents...........:   Definition of ETL process of loading data into ce_users
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/20/2018
  \*=============================================== */
    PROCEDURE insert_wrk_users;

    PROCEDURE insert_cls_users;

    PROCEDURE insert_ce_users;

    FUNCTION fix_user_id (
        user_id VARCHAR2
    ) RETURN VARCHAR2;

    FUNCTION fix_country_name (
        country_name VARCHAR2
    ) RETURN VARCHAR2;

    FUNCTION fix_date (
        dt VARCHAR2
    ) RETURN DATE;

END;
/