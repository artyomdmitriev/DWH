BEGIN
    EXECUTE IMMEDIATE 'DROP PACKAGE bl_cl.pkg_etl_insert_order_items';
EXCEPTION
    WHEN OTHERS THEN
        IF
            sqlcode !=-4043
        THEN
            RAISE;
        END IF;
END;
/

CREATE OR REPLACE PACKAGE bl_cl.pkg_etl_insert_order_items AS
  /**===============================================*\
  Name...............:   pkg_etl_insert_order_items
  Contents...........:   Definition of ETL process of loading data that is needed for fct_order_items
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/20/2018
  \*=============================================== */
    PROCEDURE insert_wrk_invoices;

    PROCEDURE insert_wrk_transactions;

    PROCEDURE insert_cls_invoices;

    PROCEDURE insert_cls_order_items;

    PROCEDURE insert_ce_invoices;

    PROCEDURE insert_ce_order_items;

    FUNCTION fix_code (
        code VARCHAR2
    ) RETURN VARCHAR2;

    FUNCTION fix_shipping_courier_name (
        shipping_courier_name VARCHAR2
    ) RETURN VARCHAR2;

    FUNCTION fix_date (
        date_str VARCHAR2
    ) RETURN DATE;

END;
/