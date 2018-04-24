CREATE OR REPLACE PACKAGE BODY bl_cl.pkg_etl_insert_order_items AS
  /**===============================================*\
  Name...............:   pkg_etl_insert_order_items
  Contents...........:   Implementation of ETL process of loading data that is needed for fct_order_items
  Author.............:   Artsemi Dzmitryieu
  Date...............:   04/20/2018
  \*=============================================== */

    PROCEDURE insert_wrk_invoices
        IS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table wrk_invoices';
        INSERT /*+ APPEND PARALLEL (wrk_invoices,4) */ INTO wrk_invoices
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
    
  -----------------------------------------------------------------------------------------------

    PROCEDURE insert_wrk_transactions
        IS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table wrk_transactions';
        INSERT /*+ APPEND PARALLEL (wrk_transactions,4) */ INTO wrk_transactions
            SELECT DISTINCT
                invoice_no,
                quantity,
                tax_amount,
                total_price,
                transaction_date,
                user_id,
                product_id,
                country,
                city_code,
                city,
                street_code,
                street_name,
                building_code,
                building,
                postal_code
            FROM
                ext_transactions;

        COMMIT;
        dbms_output.put_line('WRK_TRANSACTIONS loaded');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Errors loading WRK_TRANSACTIONS');
            RAISE;
    END insert_wrk_transactions;
  
  -----------------------------------------------------------------------------------------------

    PROCEDURE insert_cls_invoices
        AS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table cls_invoices';
        INSERT INTO cls_invoices
            SELECT
                DECODE(ce_invoices.invoice_code,NULL,ce_invoices_seq.NEXTVAL,ce_invoices.invoice_id),
                inv.invoice_code,
                nvl(inv.invoice_order_dt, TO_DATE('01/01/1900','DD/MM/YYYY')),
                nvl(inv.shipping_courier_id, -1),
                nvl(inv.packaging_type_id, -1)
            FROM
                (
                    SELECT
                        fix_code(wi.invoice_no) invoice_code,
                        MAX(TO_DATE(regexp_replace(wt.transaction_date,'[/.]','-'),'yyyy-mm-dd') ) invoice_order_dt,
                        ce_shipping_couriers.shipping_courier_id,
                        ce_packaging_types.packaging_type_id
                    FROM
                        wrk_invoices wi
                        JOIN ce_shipping_couriers ON fix_shipping_courier_name(wi.shipping_courier_full_name) = ce_shipping_couriers.shipping_courier_full_name
                        JOIN wrk_transactions wt ON fix_code(wt.invoice_no) = fix_code(wi.invoice_no)
                        JOIN ce_packaging_types ON ce_packaging_types.packaging_type_code = wi.packaging_code
                    GROUP BY
                        wi.invoice_no,
                        ce_shipping_couriers.shipping_courier_id,
                        ce_packaging_types.packaging_type_id
                ) inv,
                ce_invoices
            WHERE
                inv.invoice_code = ce_invoices.invoice_code (+);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_cls_invoices;
    
    -----------------------------------------------------------------------------------------------

    PROCEDURE insert_cls_order_items
        AS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table cls_order_items';
        INSERT INTO cls_order_items
            SELECT
                DECODE(ce_order_items.invoice_id,NULL,ce_order_items_seq.NEXTVAL,ce_order_items.ord_it_id),
                ord.ord_it_quantity,
                ord.ord_it_tax_amount_eur,
                ord.ord_it_total_price_eur,
                nvl(ord.invoice_id, -1),
                nvl(ord.user_id, -1),
                nvl(ord.product_id, -1),
                nvl(ord.building_id, -1)
            FROM
                (
                    SELECT
                        quantity ord_it_quantity,
                        to_number(regexp_replace(tax_amount,'[,.]','.') ) ord_it_tax_amount_eur,
                        to_number(regexp_replace(total_price,'[,.]','.') ) ord_it_total_price_eur,
                        ce_invoices.invoice_id,
                        ce_users.user_id,
                        ce_products.product_id,
                        nvl(addr.building_id,ce_users.building_id) building_id
                    FROM
                        wrk_transactions wt
                        JOIN ce_invoices ON fix_code(wt.invoice_no) = ce_invoices.invoice_code
                        JOIN ce_users ON wt.user_id = ce_users.user_code
                        JOIN ce_products ON ( fix_code(wt.product_id) = ce_products.product_code
                                              AND fix_date(transaction_date) >= ce_products.product_start_date
                                              AND fix_date(transaction_date) < ce_products.product_end_date )
                        LEFT JOIN (
                            SELECT
                                cb.building_id,
                                cb.building_code,
                                cs.street_code,
                                cpc.postal_code,
                                cc.city_code,
                                cco.country_name
                            FROM
                                ce_buildings cb,
                                ce_streets cs,
                                ce_postal_codes cpc,
                                ce_cities cc,
                                ce_countries cco
                            WHERE
                                cb.street_id = cs.street_id
                                AND   cs.postal_code_id = cpc.postal_code_id
                                AND   cs.city_id = cc.city_id
                                AND   cc.country_id = cco.country_id
                        ) addr ON wt.building_code = addr.building_code
                                  AND wt.street_code = addr.street_code
                                  AND wt.postal_code = addr.postal_code
                                  AND wt.city_code = addr.city_code
                                  AND wt.country = addr.country_name
                ) ord,
                ce_order_items
            WHERE
                ord.ord_it_quantity = ce_order_items.ord_it_quantity (+)
                AND   ord.ord_it_tax_amount_eur = ce_order_items.ord_it_tax_amount_eur (+)
                AND   ord.ord_it_total_price_eur = ce_order_items.ord_it_total_price_eur (+)
                AND   ord.invoice_id = ce_order_items.invoice_id (+)
                AND   ord.user_id = ce_order_items.user_id (+)
                AND   ord.product_id = ce_order_items.product_id (+)
                AND   ord.building_id = ce_order_items.building_id (+);

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_cls_order_items;
    
    -----------------------------------------------------------------------------------------------

    PROCEDURE insert_ce_invoices
        IS
    BEGIN
        MERGE INTO ce_invoices dest USING ( SELECT
            invoice_id,
            invoice_code,
            invoice_order_dt,
            shipping_courier_id,
            packaging_type_id
                                            FROM
            cls_invoices
        MINUS
        SELECT
            invoice_id,
            invoice_code,
            invoice_order_dt,
            shipping_courier_id,
            packaging_type_id
        FROM
            ce_invoices
        )
        src ON ( src.invoice_id = dest.invoice_id )
        WHEN MATCHED THEN UPDATE SET dest.invoice_code = src.invoice_code,
        dest.invoice_order_dt = src.invoice_order_dt,
        dest.shipping_courier_id = src.shipping_courier_id,
        dest.packaging_type_id = src.packaging_type_id
        WHEN NOT MATCHED THEN INSERT (
            invoice_id,
                        invoice_code,
                    invoice_order_dt,
                shipping_courier_id,
            packaging_type_id
        ) VALUES (
            src.invoice_id,
                        src.invoice_code,
                    src.invoice_order_dt,
                src.shipping_courier_id,
            src.packaging_type_id
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_ce_invoices;
    
    ---------------------------------------------------------------------------------------------

    PROCEDURE insert_ce_order_items
        IS
    BEGIN
        MERGE INTO ce_order_items dest USING ( SELECT
            ord_it_id,
            ord_it_quantity,
            ord_it_tax_amount_eur,
            ord_it_total_price_eur,
            invoice_id,
            user_id,
            product_id,
            building_id
                                               FROM
            cls_order_items
        MINUS
        SELECT
            ord_it_id,
            ord_it_quantity,
            ord_it_tax_amount_eur,
            ord_it_total_price_eur,
            invoice_id,
            user_id,
            product_id,
            building_id
        FROM
            ce_order_items
        )
        src ON ( src.ord_it_id = dest.ord_it_id )
        WHEN MATCHED THEN UPDATE SET dest.ord_it_quantity = src.ord_it_quantity,
        dest.ord_it_tax_amount_eur = src.ord_it_tax_amount_eur,
        dest.ord_it_total_price_eur = src.ord_it_total_price_eur,
        dest.invoice_id = src.invoice_id,
        dest.user_id = src.user_id,
        dest.product_id = src.product_id,
        dest.building_id = src.building_id
        WHEN NOT MATCHED THEN INSERT (
            ord_it_id,
                                    ord_it_quantity,
                                ord_it_tax_amount_eur,
                            ord_it_total_price_eur,
                        invoice_id,
                    user_id,
                product_id,
            building_id
        ) VALUES (
            src.ord_it_id,
                                    src.ord_it_quantity,
                                src.ord_it_tax_amount_eur,
                            src.ord_it_total_price_eur,
                        src.invoice_id,
                    src.user_id,
                src.product_id,
            src.building_id
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_ce_order_items;
    
    ------------ FUNCTIONS

    FUNCTION fix_code (
        code VARCHAR2
    ) RETURN VARCHAR2 AS
        fixed_code   NVARCHAR2(50);
    BEGIN
        fixed_code := regexp_replace(code,'[,.!]','');
        fixed_code := regexp_replace(fixed_code,'#','0');
        RETURN fixed_code;
    END fix_code;

    FUNCTION fix_shipping_courier_name (
        shipping_courier_name VARCHAR2
    ) RETURN VARCHAR2 AS
        fixed_shipping_courier_name   VARCHAR2(255);
    BEGIN
        fixed_shipping_courier_name :=
            CASE shipping_courier_name
                WHEN 'UPS' THEN 'United Parcel Service'
                WHEN 'DHL' THEN 'DHL Express'
                WHEN 'FedEx' THEN 'FedEx Corporation'
                WHEN 'USPS' THEN 'United States Postal Service'
                ELSE shipping_courier_name
            END;

        RETURN fixed_shipping_courier_name;
    END fix_shipping_courier_name;

    FUNCTION fix_date (
        date_str VARCHAR2
    ) RETURN DATE AS
        fixed_date   DATE;
    BEGIN
        fixed_date := TO_DATE(regexp_replace(date_str,'[/.]','-'),'yyyy-mm-dd');
        RETURN fixed_date;
    END fix_date;

END;
/