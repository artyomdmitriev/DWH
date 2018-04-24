CREATE OR REPLACE PACKAGE BODY pkg_etl_insert_products_scd AS
  /**===============================================*\
  Name...............:   pkg_etl_insert_products_scd
  Contents...........:   Implementation of ETL process of loading dim_products_scd
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/20/2018
  \*=============================================== */

    PROCEDURE insert_cls_products_scd
        AS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table cls_products_scd';
        INSERT INTO cls_products_scd
            SELECT
                DECODE(dim_products_scd.product_id,NULL,dim_products_scd_seq.NEXTVAL,dim_products_scd.product_id_dm),
                prod.product_id,
                prod.product_code,
                prod.product_name,
                prod.product_price,
                prod.product_is_in_sale,
                prod.product_start_date,
                prod.product_end_date,
                prod.product_is_current
            FROM
                (
                    SELECT
                        product_id,
                        product_code,
                        product_name,
                        product_price,
                        product_is_in_sale,
                        product_start_date,
                        product_end_date,
                        product_is_current
                    FROM
                        ce_products
                ) prod,
                dim_products_scd
            WHERE
                prod.product_id = dim_products_scd.product_id (+);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_cls_products_scd;

    -----------------------------------------------------------------------------------------------

    PROCEDURE insert_dim_products_scd
        IS
    BEGIN
        MERGE INTO dim_products_scd dest USING ( SELECT
            product_id_dm,
            product_id,
            product_code,
            product_name,
            product_price,
            product_is_in_sale,
            product_start_date,
            product_end_date,
            product_is_current
                                                 FROM
            cls_products_scd
        MINUS
        SELECT
            product_id_dm,
            product_id,
            product_code,
            product_name,
            product_price,
            product_is_in_sale,
            product_start_date,
            product_end_date,
            product_is_current
        FROM
            dim_products_scd
        )
        src ON ( src.product_id_dm = dest.product_id_dm )
        WHEN MATCHED THEN UPDATE SET dest.product_id = src.product_id,
        dest.product_code = src.product_code,
        dest.product_name = src.product_name,
        dest.product_price = src.product_price,
        dest.product_is_in_sale = src.product_is_in_sale,
        dest.product_start_date = src.product_start_date,
        dest.product_end_date = src.product_end_date,
        dest.product_is_current = src.product_is_current,
        dest.product_update_dt = SYSDATE
        WHEN NOT MATCHED THEN INSERT (
            product_id_dm,
                                                product_id,
                                            product_code,
                                        product_name,
                                    product_price,
                                product_is_in_sale,
                            product_start_date,
                        product_end_date,
                    product_is_current,
                product_insert_dt,
            product_update_dt
        ) VALUES (
            src.product_id_dm,
                                                src.product_id,
                                            src.product_code,
                                        src.product_name,
                                    src.product_price,
                                src.product_is_in_sale,
                            src.product_start_date,
                        src.product_end_date,
                    src.product_is_current,
                SYSDATE,
            SYSDATE
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_dim_products_scd;

END;
/