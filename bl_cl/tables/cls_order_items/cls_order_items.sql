BEGIN
   EXECUTE IMMEDIATE 'DROP TABLE bl_cl.cls_order_items';
EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -942 THEN
         RAISE;
      END IF;
END;
/

CREATE TABLE bl_cl.cls_order_items (
    ord_it_id                NUMBER(15,0) NOT NULL,
    ord_it_quantity          NUMBER(5,0) NOT NULL,
    ord_it_tax_amount_eur    NUMBER(8,2) NOT NULL,
    ord_it_total_price_eur   NUMBER(8,2) NOT NULL,
    invoice_id               NUMBER(10,0) NOT NULL,
    user_id                  NUMBER(10,0) NOT NULL,
    product_id               NUMBER(10,0) NOT NULL,
    building_id              NUMBER(10,0) NOT NULL
);