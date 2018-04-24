BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_3nf.ce_products';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_3nf.ce_products (
    product_id           NUMBER(10) NOT NULL,
    product_code         NVARCHAR2(50) NOT NULL,
    product_name         NVARCHAR2(255) NOT NULL,
    product_price        NUMBER(8,2) NOT NULL,
    product_is_in_sale   CHAR(1 CHAR) NOT NULL,
    product_start_date   DATE NOT NULL,
    product_end_date     DATE NOT NULL,
    product_is_current   CHAR(1 CHAR) NOT NULL,
    product_insert_dt    DATE NOT NULL,
    product_update_dt    DATE NOT NULL
);

ALTER TABLE bl_3nf.ce_products ADD CONSTRAINT products_pk PRIMARY KEY ( product_id );

INSERT INTO bl_3nf.ce_products (
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
    -1,
    'N/D',
    'N/D',
    -1.0,
    'U', -- U stands for unknown using one symbol
    TO_DATE('01/01/1900','DD/MM/YYYY'),
    TO_DATE('01/01/1900','DD/MM/YYYY'),
    'U',
    TO_DATE('01/01/1900','DD/MM/YYYY'),
    TO_DATE('01/01/1900','DD/MM/YYYY')
);

COMMIT;