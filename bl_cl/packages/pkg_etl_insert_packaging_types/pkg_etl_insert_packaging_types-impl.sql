CREATE OR REPLACE PACKAGE BODY bl_cl.pkg_etl_insert_packaging_types AS
  /**===============================================*\
  Name...............:   pkg_etl_insert_packaging_types
  Contents...........:   Implementation of ETL process of loading ce_packaging_types
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/20/2018
  \*=============================================== */

    PROCEDURE insert_wrk_invoices
        IS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table wrk_invoices';
        INSERT INTO wrk_invoices
            SELECT
                invoice_no,
                shipping_courier_short_name,
                shipping_courier_full_name,
                packaging,
                packaging_code,
                weight
            FROM
                ext_invoices;

        COMMIT;
        dbms_output.put_line('WRK_INVOICES loaded');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Error loading WRK_INVOICES');
            RAISE;
    END insert_wrk_invoices;
  
  -----------------------------------------------------------------------------------------------

    PROCEDURE insert_cls_packaging_types
        AS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table cls_packaging_types';
        INSERT INTO cls_packaging_types
            SELECT
                DECODE(ce_packaging_types.packaging_type_code,NULL,ce_packaging_types_seq.NEXTVAL,ce_packaging_types.packaging_type_id),
                nvl(packaging, 'N/D'),
                packaging_code
            FROM
                (
                    SELECT
                        packaging_code,
                        packaging
                    FROM
                        wrk_invoices
                    GROUP BY
                        packaging_code,
                        packaging
                ) pt,
                ce_packaging_types
            WHERE
                pt.packaging_code = ce_packaging_types.packaging_type_code (+);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_cls_packaging_types;

    -----------------------------------------------------------------------------------------------

    PROCEDURE insert_ce_packaging_types
        IS
    BEGIN
        MERGE INTO ce_packaging_types dest USING ( SELECT
            packaging_type_id,
            packaging_type_name,
            packaging_type_code
                                                   FROM
            cls_packaging_types
        MINUS
        SELECT
            packaging_type_id,
            packaging_type_name,
            packaging_type_code
        FROM
            ce_packaging_types
        )
        src ON ( src.packaging_type_id = dest.packaging_type_id )
        WHEN MATCHED THEN UPDATE SET dest.packaging_type_name = src.packaging_type_name,
        dest.packaging_type_update_dt = SYSDATE
        WHEN NOT MATCHED THEN INSERT (
            packaging_type_id,
                        packaging_type_name,
                    packaging_type_code,
                packaging_type_update_dt,
            packaging_type_insert_dt
        ) VALUES (
            src.packaging_type_id,
                        src.packaging_type_name,
                    src.packaging_type_code,
                SYSDATE,
            SYSDATE
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_ce_packaging_types;

END;
/