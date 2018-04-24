BEGIN
    EXECUTE IMMEDIATE 'DROP PACKAGE bl_cl_dm.pkg_etl_insert_delivery_addresses';
EXCEPTION
    WHEN OTHERS THEN
        IF
            sqlcode !=-4043
        THEN
            RAISE;
        END IF;
END;
/

CREATE OR REPLACE PACKAGE bl_cl_dm.pkg_etl_insert_delivery_addresses AS
  /**===============================================*\
  Name...............:   pkg_etl_insert_delivery_addresses
  Contents...........:   Definition of ETL process of loading data into dim_delivery_addresses
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/20/2018
  \*=============================================== */
    PROCEDURE insert_cls_delivery_addresses;

    PROCEDURE insert_dim_delivery_addresses;

END;
/