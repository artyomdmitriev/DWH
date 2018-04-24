CREATE OR REPLACE PACKAGE BODY pkg_etl_insert_packaging_types AS
  /**===============================================*\
  Name...............:   pkg_etl_insert_packaging_types
  Contents...........:   Implementation of ETL process of loading dim_packaging_types
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/20/2018
  \*=============================================== */

    PROCEDURE insert_wrk_packaging_types
        IS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table wrk_packaging_types';
        INSERT INTO wrk_packaging_types
            SELECT
                packaging_type_id,
                packaging_type_name,
                packaging_type_code,
                packaging_type_update_dt,
                packaging_type_insert_dt
            FROM
                ce_packaging_types;

        COMMIT;
        dbms_output.put_line('Loading of invoices in wrk table completed successfully');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Errors loading invoices in wrk table');
            RAISE;
    END insert_wrk_packaging_types;
  
  -----------------------------------------------------------------------------------------------

    PROCEDURE insert_cls_packaging_types
        AS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table cls_packaging_types';
        INSERT INTO cls_packaging_types
            SELECT
                DECODE(dim_packaging_types.packaging_type_id,NULL,dim_packaging_types_seq.NEXTVAL,dim_packaging_types.packaging_type_id_dm),
                pt.packaging_type_id,
                pt.packaging_type_name,
                pt.packaging_type_code,
                pt.packaging_type_update_dt,
                pt.packaging_type_insert_dt
            FROM
                (
                    SELECT
                        packaging_type_id,
                        packaging_type_name,
                        packaging_type_code,
                        packaging_type_update_dt,
                        packaging_type_insert_dt
                    FROM
                        wrk_packaging_types
                ) pt,
                dim_packaging_types
            WHERE
                pt.packaging_type_id = dim_packaging_types.packaging_type_id (+);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_cls_packaging_types;

    -----------------------------------------------------------------------------------------------

    PROCEDURE insert_dim_packaging_types
        IS
    BEGIN
        MERGE INTO dim_packaging_types dest USING ( SELECT
            packaging_type_id_dm,
            packaging_type_id,
            packaging_type_name,
            packaging_type_code,
            packaging_type_update_dt,
            packaging_type_insert_dt
                                                    FROM
            cls_packaging_types
        MINUS
        SELECT
            packaging_type_id_dm,
            packaging_type_id,
            packaging_type_name,
            packaging_type_code,
            packaging_type_update_dt,
            packaging_type_insert_dt
        FROM
            dim_packaging_types
        )
        src ON ( src.packaging_type_id_dm = dest.packaging_type_id_dm )
        WHEN MATCHED THEN UPDATE SET dest.packaging_type_id = src.packaging_type_id,
        dest.packaging_type_name = src.packaging_type_name,
        dest.packaging_type_code = src.packaging_type_code,
        dest.packaging_type_update_dt = src.packaging_type_update_dt
        WHEN NOT MATCHED THEN INSERT (
            packaging_type_id_dm,
                            packaging_type_id,
                        packaging_type_name,
                    packaging_type_code,
                packaging_type_update_dt,
            packaging_type_insert_dt
        ) VALUES (
            src.packaging_type_id_dm,
                            src.packaging_type_id,
                        src.packaging_type_name,
                    src.packaging_type_code,
                src.packaging_type_update_dt,
            src.packaging_type_insert_dt
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_dim_packaging_types;

END;
/