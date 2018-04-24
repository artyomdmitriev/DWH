BEGIN
    EXECUTE IMMEDIATE 'DROP PACKAGE bl_cl.pkg_etl_insert_shipping_couriers';
EXCEPTION
    WHEN OTHERS THEN
        IF
            sqlcode !=-4043
        THEN
            RAISE;
        END IF;
END;
/

CREATE OR REPLACE PACKAGE bl_cl.pkg_etl_insert_shipping_couriers AS
  /**===============================================*\
  Name...............:   pkg_etl_insert_shipping_couriers
  Contents...........:   Definition of ETL process for loading ce_shipping_couriers
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/20/2018
  \*=============================================== */
    PROCEDURE insert_wrk_invoices;

    PROCEDURE insert_cls_shipping_couriers;

    PROCEDURE insert_ce_shipping_couriers;

END;
/