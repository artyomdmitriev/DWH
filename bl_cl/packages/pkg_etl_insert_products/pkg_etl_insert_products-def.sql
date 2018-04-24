BEGIN
    EXECUTE IMMEDIATE 'DROP PACKAGE bl_cl.pkg_etl_insert_products';
EXCEPTION
    WHEN OTHERS THEN
        IF
            sqlcode !=-4043
        THEN
            RAISE;
        END IF;
END;
/

CREATE OR REPLACE PACKAGE bl_cl.pkg_etl_insert_products AS
  /**===============================================*\
  Name...............:   pkg_etl_insert_products
  Contents...........:   Definition of ETL process of loading data that is needed for dim_products
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/20/2018
  \*=============================================== */
    PROCEDURE insert_wrk_products;

    PROCEDURE insert_cls_products;

    PROCEDURE insert_ce_products;

    FUNCTION fix_product_code (
        product_code VARCHAR2
    ) RETURN VARCHAR2;

END;
/