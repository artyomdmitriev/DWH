BEGIN
    EXECUTE IMMEDIATE 'DROP PACKAGE bl_cl_dm.pkg_etl_insert_packaging_types';
EXCEPTION
    WHEN OTHERS THEN
        IF
            sqlcode !=-4043
        THEN
            RAISE;
        END IF;
END;
/

CREATE OR REPLACE PACKAGE bl_cl_dm.pkg_etl_insert_packaging_types AS
  /**===============================================*\
  Name...............:   pkg_etl_insert_packaging_types
  Contents...........:   Definition of ETL process of loading data into dim_packaging_types
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/20/2018
  \*=============================================== */
    PROCEDURE insert_wrk_packaging_types;

    PROCEDURE insert_cls_packaging_types;

    PROCEDURE insert_dim_packaging_types;

END;
/