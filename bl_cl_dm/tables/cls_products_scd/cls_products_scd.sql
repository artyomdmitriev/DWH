BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl_dm.cls_products_scd';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl_dm.cls_products_scd (
    product_id_dm        NUMBER(10,0),
    product_id           NUMBER(10,0),
    product_code         NVARCHAR2(50),
    product_name         NVARCHAR2(255),
    product_price        NUMBER(8,2),
    product_is_in_sale   CHAR(1 CHAR),
    product_start_date   DATE,
    product_end_date     DATE,
    product_is_current   CHAR(1 CHAR)
);