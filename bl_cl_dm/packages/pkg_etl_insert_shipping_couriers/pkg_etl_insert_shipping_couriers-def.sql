BEGIN
    EXECUTE IMMEDIATE 'DROP PACKAGE bl_cl_dm.pkg_etl_insert_shipping_couriers';
EXCEPTION
    WHEN OTHERS THEN
        IF
            sqlcode !=-4043
        THEN
            RAISE;
        END IF;
END;
/

CREATE OR REPLACE PACKAGE bl_cl_dm.pkg_etl_insert_shipping_couriers AS
  /**===============================================*\
  Name...............:   pkg_etl_insert_shipping_couriers
  Contents...........:   Definition of ETL process of loading data into dim_shipping_couriers
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/20/2018
  \*=============================================== */
    PROCEDURE insert_wrk_shipping_couriers;

    PROCEDURE insert_cls_shipping_couriers;

    PROCEDURE insert_dim_shipping_couriers;

END;
/