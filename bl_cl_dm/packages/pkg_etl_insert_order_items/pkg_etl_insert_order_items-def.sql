BEGIN
    EXECUTE IMMEDIATE 'DROP PACKAGE bl_cl_dm.pkg_etl_insert_order_items';
EXCEPTION
    WHEN OTHERS THEN
        IF
            sqlcode !=-4043
        THEN
            RAISE;
        END IF;
END;
/

CREATE OR REPLACE PACKAGE bl_cl_dm.pkg_etl_insert_order_items AS
  /**===============================================*\
  Name...............:   pkg_etl_insert_order_items
  Contents...........:   Definition of ETL process of loading data into fct_order_items
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/20/2018
  \*=============================================== */
    PROCEDURE insert_cls_order_items;

    PROCEDURE insert_fct_order_items;

END;
/