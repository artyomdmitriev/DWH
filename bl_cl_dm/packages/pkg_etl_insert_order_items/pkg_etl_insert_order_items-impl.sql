CREATE OR REPLACE PACKAGE BODY pkg_etl_insert_order_items AS
  /**===============================================*\
  Name...............:   pkg_etl_insert_order_items
  Contents...........:   Implementation of ETL process of loading fct_order_items
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/20/2018
  \*=============================================== */

    PROCEDURE insert_cls_order_items
        AS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table cls_order_items';
        INSERT INTO cls_order_items
            SELECT
                ord_it_id,
                ord_it_quantity,
                ord_it_tax_amount_eur,
                ord_it_total_price_eur,
                invoice_code,
                packaging_type_id_dm,
                shipping_courier_id_dm,
                user_id_dm,
                delivery_address_id_dm,
                product_id_dm,
                date_dt_dm
            FROM
                (
                    SELECT
                        coi.ord_it_id,
                        coi.ord_it_quantity,
                        coi.ord_it_tax_amount_eur,
                        coi.ord_it_total_price_eur,
                        ce_invoices.invoice_code,
                        dpt.packaging_type_id_dm,
                        dshc.shipping_courier_id_dm,
                        du.user_id_dm,
                        dda.delivery_address_id_dm,
                        dps.product_id_dm,
                        ce_invoices.invoice_order_dt date_dt_dm
                    FROM
                        ce_order_items coi,
                        dim_packaging_types dpt,
                        dim_shipping_couriers dshc,
                        dim_users du,
                        dim_delivery_addresses dda,
                        dim_products_scd dps,
                        ce_invoices
                    WHERE
                        coi.user_id = du.user_id
                        AND   coi.building_id = dda.building_id
                        AND   coi.product_id = dps.product_id
                        AND   coi.invoice_id = ce_invoices.invoice_id
                        AND   ce_invoices.shipping_courier_id = dshc.shipping_courier_id
                        AND   ce_invoices.packaging_type_id = dpt.packaging_type_id
                );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_cls_order_items;

    -----------------------------------------------------------------------------------------------

    PROCEDURE insert_fct_order_items
        IS
    BEGIN
        MERGE INTO fct_order_items dest USING ( SELECT
            ord_it_id,
            ord_it_quantity,
            ord_it_tax_amount_eur,
            ord_it_total_price_eur,
            invoice_code,
            packaging_type_id_dm,
            shipping_courier_id_dm,
            user_id_dm,
            delivery_address_id_dm,
            product_id_dm,
            date_dt_dm
                                                FROM
            cls_order_items
        MINUS
        SELECT
            ord_it_id,
            ord_it_quantity,
            ord_it_tax_amount_eur,
            ord_it_total_price_eur,
            invoice_code,
            packaging_type_id_dm,
            shipping_courier_id_dm,
            user_id_dm,
            delivery_address_id_dm,
            product_id_dm,
            date_dt_dm
        FROM
            fct_order_items
        )
        src ON (
            src.invoice_code = dest.invoice_code
            AND src.packaging_type_id_dm = dest.packaging_type_id_dm
            AND src.shipping_courier_id_dm = dest.shipping_courier_id_dm
            AND src.user_id_dm = dest.user_id_dm
            AND src.delivery_address_id_dm = dest.delivery_address_id_dm
            AND src.product_id_dm = dest.product_id_dm
            AND src.date_dt_dm = dest.date_dt_dm
        )
        WHEN MATCHED THEN UPDATE SET dest.ord_it_id = src.ord_it_id,
        dest.ord_it_quantity = src.ord_it_quantity,
        dest.ord_it_tax_amount_eur = src.ord_it_tax_amount_eur,
        dest.ord_it_total_price_eur = src.ord_it_total_price_eur
        WHEN NOT MATCHED THEN INSERT (
            ord_it_id,
                                                ord_it_quantity,
                                            ord_it_tax_amount_eur,
                                        ord_it_total_price_eur,
                                    invoice_code,
                                packaging_type_id_dm,
                            shipping_courier_id_dm,
                        user_id_dm,
                    delivery_address_id_dm,
                product_id_dm,
            date_dt_dm
        ) VALUES (
            src.ord_it_id,
                                                src.ord_it_quantity,
                                            src.ord_it_tax_amount_eur,
                                        src.ord_it_total_price_eur,
                                    src.invoice_code,
                                src.packaging_type_id_dm,
                            src.shipping_courier_id_dm,
                        src.user_id_dm,
                    src.delivery_address_id_dm,
                src.product_id_dm,
            src.date_dt_dm
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_fct_order_items;

END;
/