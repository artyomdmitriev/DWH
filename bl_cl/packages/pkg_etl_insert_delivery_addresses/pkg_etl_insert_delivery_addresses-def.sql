BEGIN
    EXECUTE IMMEDIATE 'DROP PACKAGE bl_cl.pkg_etl_insert_delivery_addresses';
EXCEPTION
    WHEN OTHERS THEN
        IF
            sqlcode !=-4043
        THEN
            RAISE;
        END IF;
END;
/

CREATE OR REPLACE PACKAGE bl_cl.pkg_etl_insert_delivery_addresses AS
  /**===============================================*\
  Name...............:   pkg_etl_insert_delivery_addresses
  Contents...........:   Definition of ETL process of loading data into ce_delivery_addresses
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/20/2018
  \*=============================================== */
    PROCEDURE insert_wrk_transactions;

    PROCEDURE insert_wrk_users;

    PROCEDURE insert_wrk_countries_codes;

    PROCEDURE insert_cls_countries;

    PROCEDURE insert_cls_cities;

    PROCEDURE insert_cls_postal_codes;

    PROCEDURE insert_cls_streets;

    PROCEDURE insert_cls_buildings;

    PROCEDURE insert_ce_countries;

    PROCEDURE insert_ce_cities;

    PROCEDURE insert_ce_postal_codes;

    PROCEDURE insert_ce_streets;

    PROCEDURE insert_ce_buildings;

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