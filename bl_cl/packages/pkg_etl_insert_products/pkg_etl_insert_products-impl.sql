CREATE OR REPLACE PACKAGE BODY bl_cl.pkg_etl_insert_products AS

    PROCEDURE insert_wrk_products IS

        row_countrer   PLS_INTEGER DEFAULT 0;
        prod_rec       sa_src.ext_products%rowtype;
        CURSOR c_prod IS SELECT
            prod_no,
            prod_name,
            prod_price,
            prod_in_sale
                         FROM
            sa_src.ext_products;

    BEGIN
        EXECUTE IMMEDIATE 'truncate table wrk_products';
        OPEN c_prod;
        LOOP
            FETCH c_prod INTO prod_rec;
            INSERT INTO wrk_products (
                product_code,
                product_name,
                product_price,
                product_is_in_sale
            ) VALUES (
                prod_rec.prod_no,
                prod_rec.prod_name,
                prod_rec.prod_price,
                prod_rec.prod_in_sale
            );

            row_countrer := row_countrer + 1;
            EXIT WHEN c_prod%notfound;
        END LOOP;

        CLOSE c_prod;
        COMMIT;
        dbms_output.put_line('WRK_PRODUCTS loaded');
        dbms_output.put_line(row_countrer
        || ' rows inserted');
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line('Error loading WRK_PRODUCTS');
            RAISE;
    END insert_wrk_products;
        
        -----------------------------------------------------------------------------------------------     

    PROCEDURE insert_cls_products
        AS
    BEGIN
        EXECUTE IMMEDIATE 'truncate table cls_products';
        INSERT INTO cls_products (
            product_id,
            product_code,
            product_name,
            product_price,
            product_is_in_sale,
            scd_row_type_id
        )
            SELECT
                DECODE(srt.scd_row_type_id,1,ce_products_seq.NEXTVAL,m.product_id) AS product_id,
                product_code,
                nvl(product_name, 'N/D'),
                nvl(product_price, -1.0),
                nvl(product_is_in_sale, 'U'),
                m.scd_row_type_id
            FROM
                (
                    SELECT
                        cp.product_id,
                        fix_product_code(wp.product_code) product_code,
                        initcap(wp.product_name) product_name,
                        CAST(wp.product_price AS NUMBER(8,2) ) product_price,
                        wp.product_is_in_sale,
                        CASE
                                WHEN cp.product_code IS NULL THEN 1
                                WHEN (
                                    cp.product_name <> initcap(wp.product_name)
                                    OR cp.product_price <> CAST(wp.product_price AS NUMBER(8,2) )
                                    OR cp.product_is_in_sale <> wp.product_is_in_sale
                                ) THEN 2
                                ELSE 0
                            END
                        AS scd_row_type_id
                    FROM
                        wrk_products wp
                        LEFT JOIN ce_products cp ON fix_product_code(wp.product_code) = cp.product_code
                                                    AND cp.product_is_current = 'y'
                ) m
                JOIN scd_row_type srt ON ( srt.scd_row_type_id <= m.scd_row_type_id );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_cls_products;

    ---------------------------------------------------------------------------------------------------------

    PROCEDURE insert_ce_products
        IS
    BEGIN
        MERGE INTO ce_products cp USING ( SELECT
            product_id,
            product_code,
            product_name,
            product_price,
            product_is_in_sale
                                          FROM
            cls_products
        MINUS
        SELECT
            product_id,
            product_code,
            product_name,
            product_price,
            product_is_in_sale
        FROM
            ce_products
        )
        mp ON ( mp.product_id = cp.product_id )
        WHEN MATCHED THEN UPDATE SET cp.product_update_dt = SYSDATE,
        cp.product_is_current = 'n',
        cp.product_end_date = SYSDATE
        WHEN NOT MATCHED THEN INSERT (
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
            mp.product_id,
                                            mp.product_code,
                                        mp.product_name,
                                    mp.product_price,
                                mp.product_is_in_sale,
                            SYSDATE,
                        TO_DATE('9999-12-31','yyyy-mm-dd'),
                    'y',
                SYSDATE,
            SYSDATE
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE;
    END insert_ce_products;

    -----------------------------------------------------------------------------------------------
    
    -- FUNCTIONS

    FUNCTION fix_product_code (
        product_code VARCHAR2
    ) RETURN VARCHAR2 AS
        fixed_product_code   NVARCHAR2(50);
    BEGIN
        fixed_product_code := regexp_replace(product_code,'[,.!]','');
        fixed_product_code := regexp_replace(fixed_product_code,'#','0');
        RETURN fixed_product_code;
    END fix_product_code;

END;
/