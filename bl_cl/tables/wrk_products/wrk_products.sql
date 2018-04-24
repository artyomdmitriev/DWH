BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl.wrk_products';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl.wrk_products (
    product_code         NVARCHAR2(50),
    product_name         NVARCHAR2(255),
    product_price        NUMBER(8,2),
    product_is_in_sale   CHAR(1 CHAR)
);