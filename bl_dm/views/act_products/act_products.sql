BEGIN
  EXECUTE IMMEDIATE 'DROP VIEW bl_dm.act_products';
EXCEPTION
  WHEN OTHERS THEN
    IF SQLCODE != -942 THEN
      RAISE;
    END IF;
END;
/

CREATE VIEW bl_dm.act_products AS
    SELECT
        product_id_dm,
        product_id,
        product_code,
        product_name,
        LAST_VALUE(product_name) OVER(
            PARTITION BY product_code
        ) product_current_name,
        product_price,
        product_is_in_sale,
        product_start_date,
        product_end_date,
        product_is_current,
        product_insert_dt,
        product_update_dt
    FROM
        dim_products_scd
    ORDER BY
        product_code;