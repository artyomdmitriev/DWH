CREATE OR REPLACE PACKAGE BODY pkg_etl_insert_shipping_couriers AS
  /**===============================================*\
  Name...............:   pkg_etl_insert_shipping_couriers
  Contents...........:   Implementation of ETL process of loading dim_shipping_couriers
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/21/2018
  \*=============================================== */

    PROCEDURE insert_wrk_shipping_couriers IS

        TYPE shipping_couriers_array IS
            TABLE OF wrk_shipping_couriers%rowtype INDEX BY PLS_INTEGER;
        sc   shipping_couriers_array;
        CURSOR c_ce_sc IS SELECT
            shipping_courier_id,
            shipping_courier_name,
            shipping_courier_full_name
                          FROM
            ce_shipping_couriers;

    BEGIN
        EXECUTE IMMEDIATE 'truncate table wrk_shipping_couriers';
        OPEN c_ce_sc;
        LOOP
            FETCH c_ce_sc BULK COLLECT INTO sc;
            FORALL indx IN 1..sc.count
                INSERT INTO wrk_shipping_couriers (
                    shipping_courier_id,
                    shipping_courier_name,
                    shipping_courier_full_name
                ) VALUES (
                    sc(indx).shipping_courier_id,
                    sc(indx).shipping_courier_name,
                    sc(indx).shipping_courier_full_name
                );

            EXIT WHEN c_ce_sc%notfound;
        END LOOP;

        CLOSE c_ce_sc;
        COMMIT;
        dbms_output.put_line('WRK_SHIPPING_COURIERS table loaded');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Errors loading data in WRK_SHIPPING_COURIERS');
            RAISE;
    END insert_wrk_shipping_couriers;

  -----------------------------------------------------------------------------------------------

    PROCEDURE insert_cls_shipping_couriers
        AS
        truncate_statement varchar(2000);
    BEGIN
    truncate_statement := 'truncate table cls_shipping_couriers';
        EXECUTE IMMEDIATE truncate_statement;
        INSERT INTO cls_shipping_couriers
            SELECT
                DECODE(dim_shipping_couriers.shipping_courier_id,NULL,dim_shipping_couriers_seq.NEXTVAL,dim_shipping_couriers.shipping_courier_id_dm
),
                sc.shipping_courier_id,
                sc.shipping_courier_name,
                sc.shipping_courier_full_name
            FROM
                (
                    SELECT
                        shipping_courier_id,
                        shipping_courier_name,
                        shipping_courier_full_name
                    FROM
                        wrk_shipping_couriers
                ) sc,
                dim_shipping_couriers
            WHERE
                sc.shipping_courier_id = dim_shipping_couriers.shipping_courier_id (+);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_cls_shipping_couriers;

    -----------------------------------------------------------------------------------------------

    PROCEDURE insert_dim_shipping_couriers
        IS
    BEGIN
        MERGE INTO dim_shipping_couriers dest USING ( SELECT
            shipping_courier_id_dm,
            shipping_courier_id,
            shipping_courier_name,
            shipping_courier_full_name
                                                      FROM
            cls_shipping_couriers
        MINUS
        SELECT
            shipping_courier_id_dm,
            shipping_courier_id,
            shipping_courier_name,
            shipping_courier_full_name
        FROM
            dim_shipping_couriers
        )
        src ON ( src.shipping_courier_id_dm = dest.shipping_courier_id_dm )
        WHEN MATCHED THEN UPDATE SET dest.shipping_courier_id = src.shipping_courier_id,
        dest.shipping_courier_name = src.shipping_courier_name,
        dest.shipping_courier_full_name = src.shipping_courier_full_name,
        dest.shipping_courier_update_dt = SYSDATE
        WHEN NOT MATCHED THEN INSERT (
            shipping_courier_id_dm,
                            shipping_courier_id,
                        shipping_courier_name,
                    shipping_courier_full_name,
                shipping_courier_update_dt,
            shipping_courier_insert_dt
        ) VALUES (
            src.shipping_courier_id_dm,
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
    END insert_dim_shipping_couriers;

END;
/