BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl.cls_products';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl.cls_products (
    product_id           NUMBER(10,0) NOT NULL,
    product_code         NVARCHAR2(50) NOT NULL,
    product_name         NVARCHAR2(255) NOT NULL,
    product_price        NUMBER(8,2) NOT NULL,
    product_is_in_sale   CHAR(1 CHAR) NOT NULL,
    product_start_date   DATE NOT NULL,
    product_end_date     DATE NOT NULL,
    product_is_current   CHAR(1 CHAR) NOT NULL,
    scd_row_type_id      NUMBER(2,0) NOT NULL
);