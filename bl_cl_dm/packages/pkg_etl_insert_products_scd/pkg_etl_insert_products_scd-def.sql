BEGIN
    EXECUTE IMMEDIATE 'DROP PACKAGE bl_cl_dm.pkg_etl_insert_products_scd';
EXCEPTION
    WHEN OTHERS THEN
        IF
            sqlcode !=-4043
        THEN
            RAISE;
        END IF;
END;
/

CREATE OR REPLACE PACKAGE bl_cl_dm.pkg_etl_insert_products_scd AS
  /**===============================================*\
  Name...............:   pkg_etl_insert_products_scd
  Contents...........:   Definition of ETL process of loading data into dim_products_scd
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/20/2018
  \*=============================================== */
    PROCEDURE insert_cls_products_scd;

    PROCEDURE insert_dim_products_scd;

END;
/