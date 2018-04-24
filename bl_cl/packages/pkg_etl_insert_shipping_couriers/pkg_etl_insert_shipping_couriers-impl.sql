CREATE OR REPLACE PACKAGE BODY bl_cl.pkg_etl_insert_shipping_couriers AS

  /**===============================================*\
  Name...............:   pkg_etl_insert_shipping_couriers
  Contents...........:   Implementation of ETL process for loading ce_shipping_couriers
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
            dbms_output.put_line('Errors loading WRK_INVOICES');
            RAISE;
    END insert_wrk_invoices;
    
    -----------------------------------------------------------------------------------

    PROCEDURE insert_cls_shipping_couriers
        AS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table cls_shipping_couriers';
        INSERT INTO cls_shipping_couriers
            SELECT
                DECODE(ce_shipping_couriers.shipping_courier_full_name,NULL,ce_shipping_couriers_seq.NEXTVAL,ce_shipping_couriers.shipping_courier_id
),
                nvl(sc.shipping_courier_short_name, 'N/D'),
                sc.shipping_courier_full_name
            FROM
                (
                    SELECT
                        shipping_courier_short_name,
                        shipping_courier_full_name
                    FROM
                        wrk_invoices
                    WHERE
                        length(shipping_courier_full_name) > 6
                    GROUP BY
                        shipping_courier_short_name,
                        shipping_courier_full_name
                ) sc,
                ce_shipping_couriers
            WHERE
                sc.shipping_courier_full_name = ce_shipping_couriers.shipping_courier_full_name (+);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_cls_shipping_couriers;
    
    -----------------------------------------------------------------------------------

    PROCEDURE insert_ce_shipping_couriers
        IS
    BEGIN
        MERGE INTO ce_shipping_couriers dest USING ( SELECT
            shipping_courier_id,
            shipping_courier_name,
            shipping_courier_full_name
                                                     FROM
            cls_shipping_couriers
        MINUS
        SELECT
            shipping_courier_id,
            shipping_courier_name,
            shipping_courier_full_name
        FROM
            ce_shipping_couriers
        )
        src ON ( src.shipping_courier_id = dest.shipping_courier_id )
        WHEN MATCHED THEN UPDATE SET dest.shipping_courier_name = src.shipping_courier_name,
        dest.shipping_courier_update_dt = SYSDATE
        WHEN NOT MATCHED THEN INSERT (
            shipping_courier_id,
                        shipping_courier_name,
                    shipping_courier_full_name,
                shipping_courier_update_dt,
            shipping_courier_insert_dt
        ) VALUES (
            src.shipping_courier_id,
                        src.shipping_courier_name,
                    src.shipping_courier_full_name,
                SYSDATE,
            SYSDATE
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_ce_shipping_couriers;

END;
/